# Stdlib imports

# Core Django imports
from django import forms
from django.contrib.auth.models import User
from django.utils.html import strip_tags
from django.conf import settings

# Third-party app imports
from constance import config
from ckeditor.widgets import CKEditorWidget
from urllib.parse import urlsplit
from captcha.fields import ReCaptchaField

# Imports form my apps
from mainapp.models import Site, Group
from .calculations import CodeCheck


class SiteAddForm(forms.Form):
    '''
    Formularz dodania strony z podkategorii - tylko url
    '''
    url = forms.URLField(label='Url strony', widget=forms.TextInput(attrs={'size': 50}))


class SiteAddFormFull(forms.ModelForm):
    '''
    Glowny formularz dodania strony - wszystkie pola
    '''

    def __init__(self, *args, **kwargs):
        super(SiteAddFormFull, self).__init__(*args, **kwargs)

        self.fields['group'] = forms.ModelChoiceField(
            queryset=Group.objects.filter(is_active=True), initial=1,
            help_text="<div id='group'></div>",
            label="Rodzaj wpisu")
        if config.EDYTOR_WYSWIG == 'tak':
            self.fields['description'] = forms.CharField(widget=CKEditorWidget(), error_messages={
                                                         'required': 'Musisz podać opis strony!'})
            self.fields['description'].help_text = 'Minimalnie {} znakow, maksymalnie {} znaków'.format(
                config.DESCRIPTION_LENGTH_MIN, config.DESCRIPTION_LENGTH_MAX)
        else:
            self.fields['description'] = forms.CharField(widget=forms.Textarea(attrs={'cols': 80, 'rows': 6}))

    url = forms.URLField(widget=forms.TextInput(attrs={'readonly': 'readonly'}),
                         label='Adres internetowy')
    kod = forms.CharField(label="Kod premium", required=False)
    user = forms.CharField(label="Nazwa użytkownika", widget=forms.TextInput(attrs={'readonly': 'readonly'}))
    name = forms.CharField(widget=forms.TextInput(attrs={'style': 'min-width:30%'}))

    class Meta:
        model = Site
        fields = ['url', 'name', 'description', 'keywords', 'group', 'category',
                  'subcategory', 'category1', 'subcategory1', 'user', 'email']
        fields.insert(5, 'kod')
        labels = {
            'category': 'Kategoria podstawowa',
            'subcategory': 'Subkategoria podstawowa',
            'category1': 'Kategoria dodatkowa',
            'subcategory1': 'Subkategoria dodatkowa',
            'email': 'Adres email',
        }
        help_texts = {
            'email': 'Na ten adres prześlemy potwierdzenie dodania wpisu',
            'name': 'Minimalnie {} znakow, maksymalnie {} znaków'.format(
                config.TITLE_LENGTH_MIN, config.TITLE_LENGTH_MAX),
            'keywords': 'Minimalnie {} znakow, maksymalnie {} znaków'.format(
                config.KEYWORDS_LENGTH_MIN, config.KEYWORDS_LENGTH_MAX),
            'description': 'Minimalnie {} znakow, maksymalnie {} znaków'.format(
                config.DESCRIPTION_LENGTH_MIN, config.DESCRIPTION_LENGTH_MAX),
        }

    def clean(self):
        errors = []
        cleaned_data = super(SiteAddFormFull, self).clean()
        if self.cleaned_data.get('subcategory') is not None:
            subcategory = cleaned_data['subcategory']
        if self.cleaned_data.get('description') is not None:
            description = cleaned_data['description']
            if len(strip_tags(description)) < config.DESCRIPTION_LENGTH_MIN:
                errors.append("Liczba znaków opisu strony jest za mała. \
                    Liczba wpisanych znaków to: {}, a minimalna liczba to {}".format(
                    len(strip_tags(description)), config.DESCRIPTION_LENGTH_MIN))
            if description.count('href') > config.DESC_LINKS:
                if config.DESC_LINKS == 0:
                    errors.append('Nie możesz wstawiać linków do opisu strony')
                else:
                    errors.append("Za dużo linków w opisie strony. Maksymalnie możesz dodać \
                    {} link(i).".format(config.DESC_LINKS))
        if self.cleaned_data.get('keywords') is not None:
            keywords = cleaned_data['keywords']
            for keyword in keywords.split(','):
                if len(keyword) > 50:
                    errors.append("Pojedyńcze słowa kluczowe nie mogą mieć więcej niż 50 znaków.")
            if len(keywords) < config.KEYWORDS_LENGTH_MIN:
                errors.append("Liczba znaków słów kluczowych jest za mała. \
                    Liczba wpisanych znaków to: {}, a minimalna liczba to {}".format(
                    len(keywords), config.KEYWORDS_LENGTH_MIN))

        if self.cleaned_data.get('category1') is not None:
            category1 = cleaned_data['category1']
            if category1:
                self.fields_required(['subcategory1'])
                if self.cleaned_data.get('subcategory1') is not None:
                    subcategory1 = cleaned_data['subcategory1']
                    if subcategory1 and (subcategory == subcategory1):
                        errors.append("Subkategorie nie mogą być takie same.")

        if self.cleaned_data.get('url') is not None:
            url = urlsplit(self.cleaned_data['url']).netloc
            if url.startswith('www.'):
                url = url[4:]
            if Site.objects.filter(url__contains=url).exclude(pk=self.instance.id).count() > 0:
                error_msg = forms.ValidationError("Taki url istnieje w bazie")
                self.add_error('url', error_msg)
            if self.cleaned_data['url'].count('/') > 2:
                if self.cleaned_data['url'].count('/') == 3 and self.cleaned_data['url'][-1] == '/':
                    pass
                else:
                    error_msg = forms.ValidationError("Dodawanie podstron jest zabronione")
                    self.add_error('url', error_msg)

        if self.cleaned_data.get('kod') is not '':
            group = self.cleaned_data.get('group')
            if group.pay == 'PAID':
                sprawdzenie_kodu = CodeCheck(self.cleaned_data.get('kod'), group)
                if sprawdzenie_kodu.check_code_validation() is False:
                    errors.append("Podany kod jest nieprawidłowy")
        if errors:
            raise forms.ValidationError(errors)
        return self.cleaned_data

    def fields_required(self, fields):
        for field in fields:
            if not self.cleaned_data.get(field, ''):
                msg = forms.ValidationError("To pole jest wymagane")
                self.add_error(field, msg)


class UserForm(forms.ModelForm):
    password = forms.CharField(widget=forms.PasswordInput(), label='Hasło')

    class Meta:
        model = User
        fields = ('username', 'email', 'password')
        help_texts = {
            'username': ''
        }


class ContactForm(forms.Form):
    contact_name = forms.CharField(required=True)
    contact_email = forms.EmailField(required=True)
    contact_message = forms.CharField(
        required=True,
        widget=forms.Textarea
    )

    def __init__(self, *args, **kwargs):
        super(ContactForm, self).__init__(*args, **kwargs)
        self.fields['contact_name'].label = "Twoje imię"
        self.fields['contact_email'].label = "Twój adres email"
        self.fields['contact_message'].label = "Wiadomość"
        if config.CAPTCHA == 'tak':
            self.fields['captcha'] = ReCaptchaField(
                public_key=settings.CAPTCHA_PUBLIC,
                private_key=settings.CAPTCHA_PRIVATE,
                attrs={
                    'theme': 'white',
                })
            self.fields['captcha'].label = "Kod zabezpieczacjący"


class EmailForm(forms.Form):

    def __init__(self, *args, **kwargs):
        super(EmailForm, self).__init__(*args, **kwargs)
        self.fields['email_template'].choices = [(i, i) for i in config.EMAIL_TEMPLATES.splitlines(
        )]

    email_template = forms.ChoiceField(choices=[(i, i) for i in config.EMAIL_TEMPLATES.splitlines(
    )], label="Szablon email", initial='', widget=forms.Select(), required=True)
    # email_form = forms.CharField(max_length=20)


class PremiumForm(forms.Form):
    '''
    Formularz wyróżnienia wpisu
    '''

    def __init__(self, *args, **kwargs):
        super(PremiumForm, self).__init__(*args, **kwargs)
        self.fields['group'] = forms.ModelChoiceField(
            queryset=Group.objects.filter(is_active=True),
            help_text="<div id='group'></div>",
            label="Rodzaj wpisu")
        self.fields['group'].empty_label = None
        self.fields['kod'] = forms.CharField(label="Kod premium", required=True)
    # class Meta:
    #     fields = ['group', 'kod']
    # kod = forms.CharField(label="Kod premium", required=True)
