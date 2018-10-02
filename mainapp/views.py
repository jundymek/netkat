# Stdlib imports
import json
from datetime import datetime, timedelta

# Core Django imports
from django.conf import settings
from django.http import Http404, HttpResponseRedirect, HttpResponse, JsonResponse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import Permission
from django.core.urlresolvers import reverse
from django.template.defaultfilters import slugify
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

# Third-party app imports
from constance import config
from ipware.ip import get_ip

# Imports form my apps
from .models import Category, SubCategory, Site, Group
from .forms import SiteAddForm, SiteAddFormFull, UserForm, ContactForm, PremiumForm
from .calculations import AddNewSite, SiteList, Tags, SendEmail, CodeCheck, Keywords


def index(request):
    '''
    Wyswietlanie kategorii, strona glowna
    '''
    context = {}
    categories = Category.objects.all()
    subcategories = SubCategory.objects.all()
    sites = Site.objects.filter(is_active=True).order_by('-date')[:10]
    context['categories'] = categories
    context['subcategories'] = subcategories
    context['sites'] = sites
    context['desc'] = config.DESC
    return render(request, 'mainapp/index.html', context)


def category(request, category_slug):
    context = SiteList(category_slug).get_context()
    paginator = Paginator(context['sites'], 10)
    page = request.GET.get('page')
    tags = Tags(category_slug).all_tags()
    try:
        sites = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        sites = paginator.page(1)
    except EmptyPage:
        # If page is out of range (e.g. 9999), deliver last page of results.
        sites = paginator.page(paginator.num_pages)
    except Category.DoesNotExist:
        raise Http404("Nie ma takiej kategorii")
    context['sites'] = sites
    context['tags'] = tags
    obj = Category.objects.get(slug=category_slug)
    context['keywords'] = Keywords(obj.category_keywords).proper_keywords()
    return render(request, 'mainapp/category.html', context)


def subcategory(request, category_slug, subcategory_slug):
    '''
    Wyswietlanie stron w podkategoriach i mozliwoscia dodania nowej strony
    '''
    context = SiteList(category_slug, subcategory_slug).get_context()
    paginator = Paginator(context['sites'], 10)
    page = request.GET.get('page')
    tags = Tags(category_slug, subcategory_slug).all_tags()
    form = SiteAddForm(initial={'url': 'http://'})
    context['form'] = form
    context['tags'] = tags
    context['keywords'] = ', '.join([x.strip() for x in tags][:3])
    try:
        sites = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        sites = paginator.page(1)
    except EmptyPage:
        # If page is out of range (e.g. 9999), deliver last page of results.
        sites = paginator.page(paginator.num_pages)
    except (SubCategory.DoesNotExist, Category.DoesNotExist):
        raise Http404("Nie ma takiej strony")
    context['sites'] = sites
    if request.method == 'POST':
        form = SiteAddForm(request.POST)
        if form.is_valid():
            siteurl = form.cleaned_data['url']
            user = 'request.user.username'
            context['siteurl'] = siteurl
            request.session['url'] = siteurl  # przechwycenie url dla sesji
            page = AddNewSite(siteurl, user)
            # sprawdzenie czy strona wczytuje sie prawidlowo
            if page.check_soup():
                messages.add_message(request, messages.WARNING,
                                     'Sprawdź czy dodajesz poprawną stronę. \
                                     Program nie może pobrać metatagów strony. \
                                     Być może wprowadzony adres url zawiera\
                                     błąd lub strona nie działa prawidłowo!!!')
            # sprawdzenie czy url nie prowadzi do podstrony
            if page.check_url_subpage():
                messages.add_message(request, messages.ERROR,
                                     'Dodawanie podstron jest zablokowane.')
                return render(request, 'mainapp/subcategory.html', context)
            # sprawdzenie czy url znajduje sie w bazie
            if page.check_url_in_database():
                messages.add_message(request, messages.ERROR,
                                     'Taka strona istnieje już w bazie')
                return render(request, 'mainapp/subcategory.html', context)
            else:
                return redirect('add_site', category_slug=category_slug, subcategory_slug=subcategory_slug)

    return render(request, 'mainapp/subcategory.html', context)


def add_site(request, category_slug, subcategory_slug):
    context = {}
    host = request.META['HTTP_HOST']
    try:
        url = request.session['url']
        context['url'] = url
    except KeyError:
        return redirect('index')
    user = request.user.username
    if user:
        user = user
        email = request.user.email
    else:
        user = get_ip(request)
        email = None
    category = Category.objects.get(slug=category_slug)
    subcategory = SubCategory.objects.filter(category=category
                                             ).get(slug=subcategory_slug)
    page = AddNewSite(url, user, email, category, subcategory, date_end=None)
    form_extended = SiteAddFormFull(initial=page.get_initial_data())
    context['form_extended'] = form_extended
    if request.method == 'POST':
        form_extended = SiteAddFormFull(request.POST)
        if form_extended.is_valid():
            group = Group.objects.get(id=request.POST["group"])
            if form_extended.cleaned_data['kod'] is not None:
                CodeCheck(form_extended.cleaned_data['kod'], group).code_remove()
            obj = form_extended.save(commit=False)
            if obj.group.time == 'T':
                obj.date_end = datetime.now() + timedelta(days=obj.group.days)
            obj.keywords = Keywords(form_extended.cleaned_data['keywords']).proper_keywords()
            obj.save()
            SendEmail(form_extended.cleaned_data['email'],
                      form_extended.cleaned_data['user'],
                      form_extended.cleaned_data['url'], host).send_confirmation_email()
            return JsonResponse({'success': 'Strona {} została dodana i przekazana do\
                moderacji. O akceptacji zostaniesz powiadomiony emailem, który zostanie wysłany na\
                adres {}.'.format(obj.url, obj.email)})
        else:
            errors = ''
            for message in form_extended.errors:
                errors += str(form_extended.errors[message]) + '\n'
                return JsonResponse({'error': errors})
    else:
        form_extended = SiteAddFormFull()
    return render(request, 'mainapp/add_site.html', context)


def site(request, category_slug, subcategory_slug, slug, id):
    context = {}
    try:
        context = SiteList(category_slug, subcategory_slug).get_context()
        category = Category.objects.get(slug=category_slug)
        subcategory = SubCategory.objects.filter(category=category
                                                 ).get(slug=subcategory_slug)
        site = Site.objects.filter(subcategory=subcategory).get(id=id)
        keywords = (site.keywords).split(',')
        description = site.description[:160].replace("&nbsp;", "")
    except (SubCategory.DoesNotExist, Category.DoesNotExist, Site.DoesNotExist):
        raise Http404("Nie ma takiej strony")
    context['subcategory'] = subcategory
    context['site'] = site
    context['keywords'] = keywords
    context['description'] = description
    return render(request, 'mainapp/site.html', context)
    # TODO: poprawic description (teraz zostaja krzaczki)


def tags(request, slug):
    context = {}
    tags = Tags().all_tags()
    for tag in tags:
        if slugify(tag) == slug:
            tags = Tags().tag_filer_sites(tag)
            context['tag'] = tag
    context['sites'] = tags['sites'].order_by('-date')
    return render(request, 'mainapp/all_tags.html', context)


def get_subcategory(request, category_id):
    '''
    Filtrowanie subkategorii dla wybranej kategorii dla formularzy,
    widok pomocniczy
    '''
    category = Category.objects.get(pk=category_id)
    subcategories = category.subcategory.all()
    subcategories_dict = {}
    for subcategory in subcategories:
        subcategories_dict[subcategory.id] = subcategory.subcategory_name
    return HttpResponse(json.dumps(subcategories_dict), content_type="application/json")


def register(request):
    registered = False
    if request.method == 'POST':
        user_form = UserForm(data=request.POST)

        if user_form.is_valid():
            user = user_form.save()
            user.set_password(user.password)
            user.is_staff = True
            user.save()
            permission = Permission.objects.filter(name='Can change site')
            user.user_permissions.add(permission[0])
            registered = True
            messages.success(request, 'Dziękujmy za rejestrację')
            return redirect('index')
        else:
            print(user_form.errors)
    else:
        user_form = UserForm()

    return render(request,
                  'mainapp/register.html',
                  {'user_form': user_form,
                   'registered': registered})


def user_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(username=username, password=password)

        if user:
            if user.is_active:
                login(request, user)
                return HttpResponseRedirect(reverse('index'))
            else:
                messages.info(request, 'Konto nie jest aktywne')
                return HttpResponseRedirect(reverse('index'))
        else:
            messages.error(request, 'Nazwa użytkownika/hasło nie są poprawne!!!')
            return HttpResponseRedirect(reverse('index'))
    else:
        return render(request, 'mainapp/login.html', {})


@login_required
def user_logout(request):
    logout(request)
    return HttpResponseRedirect(reverse('index'))


def regulamin(request):
    return render(request, 'mainapp/regulamin.html', {})


def contact(request):
    if request.method == 'POST':
        contact_form = ContactForm(request.POST)
        if contact_form.is_valid():
            email = request.POST.get('contact_email')
            user = request.POST.get('contact_name')
            message = request.POST.get('contact_message')
            SendEmail(email, user, None, None, message).contact_email()
            messages.success(request, 'Dziękujęmy za wysłanie wiadomości')
            return HttpResponseRedirect(reverse('contact'))
    else:
        contact_form = ContactForm()

    return render(request, 'mainapp/contact.html', {
        'form': contact_form, 'key': settings.RECAPTCHA_PUBLIC_KEY})

def premium(request, id):
    context = {}
    try:
        site = Site.objects.get(id=id)
        premium_form = PremiumForm()
        premium_form.fields['group'].queryset = premium_form.fields['group'].queryset.exclude(group_name=site.group)
    except Site.DoesNotExist:
        raise Http404("Nie ma takiej strony")
    if request.method == 'POST':
        premium_form = PremiumForm(request.POST)
        premium_form.fields['group'].queryset = premium_form.fields['group'].queryset.exclude(group_name=site.group)
        if premium_form.is_valid():
            group = Group.objects.get(id=request.POST["group"])
            sprawdzenie_kodu = CodeCheck(premium_form.cleaned_data['kod'], group)
            if sprawdzenie_kodu.check_code_validation():
                site.group = group
                if site.group.time == 'T':
                    site.date_end = datetime.now() + timedelta(days=site.group.days)
                site.save()
                messages.add_message(request, messages.SUCCESS, 'Strona {} została przeniesiona \
            do grupy {}. Dziękujemy za korzystanie z naszego katalogu stron.'.format(site.url, site.group))
                return redirect('index')
            else:
                premium_form = PremiumForm()
                context['form'] = premium_form
                premium_form.fields['group'].queryset = premium_form.fields['group'].queryset.exclude(
                    group_name=site.group)
                context['site'] = site
                context['category'] = site.category
                context['subcategory'] = site.subcategory
                messages.add_message(request, messages.ERROR,
                                     'Podany kod jest nieprawidłowy')
                return render(request, 'mainapp/premium.html', context)
    context['site'] = site
    context['form'] = premium_form
    context['category'] = site.category
    context['subcategory'] = site.subcategory
    return render(request, 'mainapp/premium.html', context)
