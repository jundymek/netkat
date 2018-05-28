# Stdlib imports
import json
from datetime import datetime, timedelta

# Django imports
from django.contrib import admin, messages
from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.models import Group as Groups
from django.shortcuts import redirect
from django.utils.translation import ugettext_lazy as _
from django_admin_listfilter_dropdown.filters import RelatedDropdownFilter
from django.conf.urls import url
from django.core.management import call_command
from django.contrib.auth.admin import UserAdmin
from django.utils.html import format_html
from django.contrib.auth.models import Permission
from django.http import HttpResponseRedirect

# Third-party app imports
from constance.admin import config, ConstanceAdmin, Config
from admin_interface.models import Theme

# Imports form my apps
from mainapp.models import Category, SubCategory, Site, Group
from .calculations import CodeCheck, SendEmail
from .forms import SiteAddFormFull, EmailForm


def activate_sites(modeladmin, request, queryset):
    '''
    Aktywowanie stron z wysylka potwierdzenia email
    '''
    host = request.META['HTTP_HOST']
    counter = 0
    for site in queryset:
        SendEmail(site.email, site.user, site.url, host, None, site.get_absolute_url()).send_activation_email()
        counter += 1
    queryset.update(is_active=True)
    messages.info(request, 'Aktywowano {} stron(y) '.format(counter))


activate_sites.short_description = "Aktywuj zaznaczone (potwierdzenie email)"


def activate_sites1(modeladmin, request, queryset):
    '''
    Aktywowanie stron bez potwierdzenia
    '''
    counter = 0
    for site in queryset:
        counter += 1
    queryset.update(is_active=True)
    messages.info(request, 'Aktywowano {} stron(y) '.format(counter))


activate_sites1.short_description = "Aktywuj zaznaczone (brak potwierdzenia email)"


def deactivate_sites(modeladmin, request, queryset):
    '''
    Dezaktywowanie stron
    '''
    counter = 0
    for site in queryset:
        counter += 1
    queryset.update(is_active=False)
    messages.info(request, 'Dezaktywowano {} stron(y) '.format(counter))


deactivate_sites.short_description = "Dezaktywuj zaznaczone"


def unflag_sites(modeladmin, request, queryset):
    '''
    Odflagowanie stron
    '''
    queryset.update(flagged_true=False, flagged='')


unflag_sites.short_description = "Usuń oznaczenie 'Niedziałające/podejrzane'"


def delete_sites_email(modeladmin, request, queryset):
    '''
    Usunięcie stron z potwierdzeniem email
    '''
    message = request.POST['email_template']
    host = request.META['HTTP_HOST']
    counter = 0
    for site in queryset:
        site.delete()
        SendEmail(site.email, site.user, site.url, host, message).send_delete_email()
        counter += 1
    messages.info(request, 'Usunięto {} stron(y) '.format(counter))


delete_sites_email.short_description = "Usuń zaznaczone strony (potwierdzenie email)"


def delete_sites(self, request, queryset):
    counter = 0
    for site in queryset:
        site.delete()
        counter += 1
    messages.info(request, 'Usunięto {} stron(y) '.format(counter))


delete_sites.short_description = "Usuń zaznaczone strony (brak potwierdzenia email)"


class SubcategoryInline(admin.TabularInline):
    model = SubCategory
    fields = ('subcategory_name',)


class CategoryAdmin(admin.ModelAdmin):
    inlines = [SubcategoryInline, ]
    list_display = ('category_name',)

    fields = ('category_name', 'category_description', 'category_keywords', 'image', 'admin_image_thumb',)
    readonly_fields = ('admin_image_thumb',)


class SubCategoryAdmin(admin.ModelAdmin):
    list_display = ('subcategory_name', 'category')
    fields = ('subcategory_name', 'category')


class SiteForm(forms.ModelForm):
    '''
    Weryfikacja formularza - edycja strony - kody premium
    '''
    user = forms.CharField(label="Nazwa użytkownika", widget=forms.TextInput(attrs={'readonly': 'readonly'}))

    class Meta:
        model = Site
        fields = '__all__'

    def clean(self):
        kod = self.cleaned_data.get('kod')
        sprawdzenie_kodu = CodeCheck(kod)
        if kod and not sprawdzenie_kodu.check_code_validation():
            raise forms.ValidationError("Podany kod jest nieprawidłowy")
        return self.cleaned_data

class UserListFilter(admin.SimpleListFilter):
    # Human-readable title which will be displayed in the
    # right admin sidebar just above the filter options.
    title = _('Nazwa usera')

    # Parameter for the filter that will be used in the URL query.
    parameter_name = 'user'

    def lookups(self, request, model_admin):
        """
        Returns a list of tuples. The first element in each
        tuple is the coded value for the option that will
        appear in the URL query. The second element is the
        human-readable name for the option that will appear
        in the right sidebar.
        """
        list_users = []
        queryset = User.objects.all()
        for user in queryset:
            list_users.append(
                (str(user.is_staff), user.username)
            )
        return sorted(list_users, key=lambda tp: tp[1])
 
    def queryset(self, request, queryset):
        """
        Returns the filtered queryset based on the value
        provided in the query string and retrievable via
        `self.value()`.
        """
        # Compare the requested value (either '80s' or '90s')
        # to decide how to filter the queryset.
        queryset = Site.objects.all()
        if self.value():
            return queryset


class SiteAdmin(admin.ModelAdmin):
    change_form_template = 'admin/change_form_sites.html'
    form = SiteAddFormFull

    list_display = ('is_active', 'thumb', 'name', 'get_desc', 'show_url', 'date',)
    fieldsets = (
        (None, {'fields': ('name', 'url', 'id', 'category', 'subcategory', 'category1',
                           'subcategory1', 'description',
                           'keywords', 'date', 'date_end', 'group', 'kod', 'email', 'user', 'is_active',
                           'flagged', 'flagged_true')}),
        ('Ustawienia sprawdzania poprawności wczytywania stron', {
         'fields': ('little_chars_check', 'evil_words_check', 'aftermarket_check')}),
    )
    # fields = ('name', 'url', 'id', 'category', 'subcategory', 'category1',
    #           'subcategory1', 'description',
    #           'keywords', 'date', 'date_end', 'group', 'kod' 'email', 'is_active',
    #           'flagged', 'flagged_true', 'little_chars', 'aftermarket_check')
    readonly_fields = ('date', 'date_end', 'id')
    list_display_links = ('name',)
    list_filter = (
        ('is_active'),
        ('date'),
        ('category', RelatedDropdownFilter),
        ('group'),
        ('user'),
        (UserListFilter)
    )
    actions = [delete_sites_email, delete_sites, activate_sites, activate_sites1, deactivate_sites]
    search_fields = ('name', 'url',)
    list_per_page = 10

    def thumb(self, obj):
        return "<img class='admin_thumb' src='{}'  width='100' height='100' />".format(obj.get_thumb())

    thumb.allow_tags = True
    thumb.__name__ = 'Miniaturka'

    def get_desc(self, obj):
        if obj.description:
            return obj.description
    get_desc.allow_tags = True
    get_desc.__name__ = 'Opis strony'

    def get_queryset(self, request):
        '''
        Ustawienie wyswietlanych stron dla superusera i normalnego usera
        '''
        if request.user.is_superuser:
            return Site.objects.all()
        else:
            return Site.objects.filter(user=request.user, is_active=True)

    def get_actions(self, request):
        '''
        Wylaczenie django-actions dla normalnego usera
        '''
        actions = super(SiteAdmin, self).get_actions(request)
        if not request.user.is_superuser:
            del actions['delete_sites_email']
            del actions['activate_sites']
            del actions['activate_sites1']
            del actions['deactivate_sites']
        del actions['delete_selected']
        return actions

    def changelist_view(self, request, extra_context=None):
        extra_context = extra_context or {}
        key_length_max = json.dumps(config.KEYWORDS_LENGTH_MAX)
        extra_context['js_data_keywords'] = key_length_max
        group = Group.objects.all()
        user_sites_count = str(Site.objects.filter(user=request.user))
        if request.user.is_superuser:
            actions = [activate_sites, deactivate_sites]
            extra_context['actions'] = actions
        extra_context['group'] = group
        extra_context['user_sites_count'] = user_sites_count
        extra_context['form_email_template'] = EmailForm
        return super(SiteAdmin, self).changelist_view(request, extra_context)

    def get_fields(self, request, obj=None):
        if request.user.is_superuser:
            return ['name', 'url', 'id', 'category', 'subcategory', 'category1',
                    'subcategory1', 'description',
                    'keywords', 'date', 'date_end', 'group', 'kod', 'email',
                    'user', 'is_active', 'flagged', 'flagged_true', 'little_chars_check',
                    'evil_words_check', 'aftermarket_check']
        else:
            return ['name', 'url', 'id', 'category', 'subcategory', 'category1',
                    'subcategory1', 'description',
                    'keywords', 'date', 'group', 'kod', 'email', 'user']

    def get_form(self, request, obj=None, **kwargs):
        '''
        Wylistowanie userów do pola ChoiceField formularza user
        '''
        users = User.objects.values('username')
        user_list = []
        choices = []
        for user in users:
            for k, v in user.items():
                user_list.append(v)
        if obj and obj.user not in user_list:
            choices = [(obj.user, str(obj.user) + ' (Gość)')]
        for user_number in range(len(users)):
            if (users[user_number]['username'], users[user_number]['username']) not in choices:
                choices.append((users[user_number]['username'], users[user_number]['username']))
        form = super(SiteAdmin, self).get_form(request, obj, **kwargs)
        form.base_fields['url'] = forms.URLField(
            label='Adres internetowy', widget=forms.TextInput(attrs={'size': '46'}))
        if request.user.is_superuser:
            form.base_fields['user'] = forms.ChoiceField(
                label="Nazwa użytkownika", choices=choices)
            form.base_fields['email'] = forms.EmailField(label="Adres email", initial=request.user.email)
        else:
            form.base_fields['user'] = forms.CharField(
                label="Nazwa użytkownika", widget=forms.TextInput(attrs={'readonly': 'readonly'}))
        return form

    def save_model(self, request, obj, form, change):
        errors = []
        host = request.META['HTTP_HOST']
        obj.date = datetime.now()
        path = obj.get_absolute_url()
        try:
            if obj.group.time == 'T' and 'group' in form.changed_data:
                obj.date_end = obj.date + timedelta(days=obj.group.days)
            elif obj.group.time == 'T' and 'group' not in form.changed_data:
                obj.date_end = obj.date_end
            else:
                obj.date_end = None
            if 'is_active' in form.changed_data and obj.is_active is True:
                SendEmail(form.cleaned_data['email'], form.cleaned_data['user'],
                          form.cleaned_data['url'], host, None, path).send_activation_email()
            if 'group' in form.changed_data and obj.group.pay == 'PAID':
                if not request.user.is_superuser:
                    sprawdzenie_kodu = CodeCheck(form.cleaned_data['kod'], obj.group)
                    if sprawdzenie_kodu.check_code_validation():
                        obj.save()
                    else:
                        messages.set_level(request, messages.ERROR)
                        messages.error(request, 'Podany kod jest nieprawidłowy - strona nie została zmodyfikowana')
                        return HttpResponseRedirect(path)
                else:
                    obj.save()
            if form.cleaned_data['keywords'][-1] == ',':
                obj.keywords = form.cleaned_data['keywords'][:-1]
            obj.save()
        except Exception as e:
            print(e)
            messages.set_level(request, messages.ERROR)
            messages.error(request, 'Podany URL nie odpowiada')
        if errors:
            raise forms.ValidationError(errors)

    def show_url(self, obj):
        if obj.group.group_name == 'Premium':
            return format_html(
                '<span class="premium"><a style="color:blue" href="{}">{}</a></span>'.format(obj.url, obj.url)
            )
        return '<a style="color:blue" href="%s">%s</a>' % (obj.url, obj.url)
    show_url.allow_tags = True
    show_url.short_description = "Url"


class InactiveSite(Site):
    class Meta:
        proxy = True
        verbose_name_plural = 'Strony nieaktywne'


class InactiveSiteAdmin(SiteAdmin):
    change_list_template = 'admin/change_list_inactive.html'
    list_display = ('is_active', 'thumb', 'name', 'show_url', 'get_desc', 'keywords',
                    'category', 'subcategory', 'category1', 'subcategory1',)
    # fields = ('name', 'url', 'id', 'category', 'subcategory', 'category1',
    #           'subcategory1', 'description',
    #           'keywords', 'date', 'group', 'user', 'is_active', 'date_end',)
    readonly_fields = ('date', 'date_end', 'id')
    list_display_links = ('name',)
    actions = [activate_sites, activate_sites1, ]

    def get_queryset(self, request):
        return Site.objects.filter(is_active=False)

    def response_change(self, request, obj):
        return redirect('/admin/mainapp/site/{}/change/'.format(obj.id))

    def has_add_permission(self, request):
        return False


class FlaggedSite(Site):
    class Meta:
        proxy = True
        verbose_name_plural = 'Strony niedziałające/podejrzane'
        verbose_name = 'strony podejrzane'


class FlaggedSiteAdmin(SiteAdmin):
    change_list_template = 'admin/change_list_inactive.html'
    list_display = ('is_active', 'thumb', 'name', 'show_url', 'date', 'flagged__custom_rendering', 'group')
    # fields = ('name', 'url', 'id' 'category', 'subcategory', 'category1',
    #           'subcategory1', 'description',
    #           'keywords', 'date', 'group', 'user', 'is_active', 'date_end', 'flagged', 'flagged_true')
    readonly_fields = ('date', 'date_end', 'id')
    list_display_links = ('name',)
    actions = [unflag_sites]

    def get_queryset(self, request):
        return Site.objects.filter(is_active=True, flagged_true=True)

    def flagged__custom_rendering(self, obj):
        '''
        Sformatowanie tekstu w list_display - pole flagged, wypisanie wierszy
        jeden pod drugim
        '''
        result = ''
        for line in obj.flagged.split('\n'):
            if len(line) > 80:
                result += line[:80] + '...' + '\n'
            else:
                result += line + '\n'
        return('<pre>%s</pre>' % result)
    flagged__custom_rendering.allow_tags = True
    flagged__custom_rendering.__name__ = 'Przesłanki do oflagowania strony jako \
        niedziałająca/podejrzana'

    def has_add_permission(self, request):
        return False

    def response_change(self, request, obj):
        return redirect('/admin/mainapp/site/{}/change/'.format(obj.id))


class GroupAdmin(admin.ModelAdmin):
    change_list_template = 'admin/change_list_group.html'
    list_display = ('group_name', 'pay', 'is_active')
    fields = ('group_name', 'pay', 'time', 'days', 'premium_box', 'text', 'codes', 'secret_codes', 'is_active')
    actions = ['delete_selected']

    def delete_selected(modeladmin, request, queryset):
        queryset.exclude(group_name='Podstawowy').delete()
        messages.warning(request, 'Nie można usunąć grupy podstawowej')
    delete_selected.short_description = "Usuń wybraną grupę"

    def has_delete_permission(self, request, obj=None):
        if obj is not None and obj.group_name == 'Podstawowy':
            return False

    def has_add_permission(self, request):
        return False

    def get_fields(self, request, obj=None):
        if obj.group_name == 'Podstawowy':
            return ['group_name', 'pay', 'time', 'premium_box', 'text', 'codes', 'secret_codes', 'is_active']
        else:
            return ['group_name', 'pay', 'time', 'days', 'premium_box', 'text', 'codes', 'secret_codes', 'is_active']

    def get_readonly_fields(self, request, obj=None):
        if obj.group_name == 'Podstawowy':
            return ['group_name', 'time', 'is_active']
        return self.readonly_fields


class ConfigAdmin(ConstanceAdmin):
    change_list_template = 'admin/config/change_list.html'

    def run_cron_jobs(self, request):
        '''
        Funkcja uruchamiająca zadania CRON na serwerze
        '''
        call_command('installtasks')
        messages.success(request, 'Zadania cykliczne zostały załadowane')
        return redirect('/admin/constance/config/')

    def get_urls(self):
        urls = super(ConfigAdmin, self).get_urls()
        my_urls = [
            url(r'^run_cron_jobs/$', self.run_cron_jobs),
        ]
        return my_urls + urls


class MyConfig(Config):
    class Meta(Config.Meta):
        verbose_name_plural = _('Zmiana ustawień')
    _meta = Meta()


class MyUserAdmin(UserAdmin):
    list_display = ('username', 'email',)
    actions = ['delete_selected']
    fieldsets = (
        (None, {'fields': ('username', 'email', 'password',)}),
        (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser',)}),
        (_('Dane logowania'), {'fields': ('last_login', 'date_joined')}),
    )
    readonly_fields = ('last_login', 'date_joined')

    def delete_selected(modeladmin, request, queryset):
        queryset.exclude(username='demo').delete()
        messages.warning(request, "Nie można usunąć użytkownika 'demo'")
    delete_selected.short_description = "Usuń wybranych użytkowników"

    def has_delete_permission(self, request, obj=None):
        if obj is not None and obj.username == 'demo':
            return False

    def save_model(self, request, obj, form, change):
        user = form.save()
        user.is_staff = True
        permission = Permission.objects.filter(name='Can change site')
        user.user_permissions.add(permission[0])
        obj.save()


admin.site.unregister(User)
admin.site.register(User, MyUserAdmin)


admin.site.unregister([Config])
admin.site.register([MyConfig], ConfigAdmin)

admin.site.register(Category, CategoryAdmin)
# admin.site.register(SubCategory, SubCategoryAdmin)
admin.site.register(Site, SiteAdmin)
admin.site.register(InactiveSite, InactiveSiteAdmin)
admin.site.register(FlaggedSite, FlaggedSiteAdmin)
admin.site.register(Group, GroupAdmin)
admin.site.unregister(Groups)
admin.site.unregister(Theme)
