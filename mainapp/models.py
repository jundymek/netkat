# Stdlib imports
from datetime import datetime, timedelta
from urllib.parse import urlparse

# Django imports
from django.db import models
from django.urls import reverse
from django.db.models import Q
from django.template.defaultfilters import slugify

# Third-party app imports
from smart_selects.db_fields import ChainedForeignKey
from constance import config
from ckeditor.fields import RichTextField

# Imports form my apps
from mainapp.widgets import MyTextField


class Category(models.Model):
    category_name = models.CharField(max_length=30, unique=True,
                                     verbose_name='Nazwa kategorii')
    slug = models.SlugField()
    image = models.ImageField(upload_to='category_images',
                              verbose_name="Obrazek kategorii",
                              blank=True)
    category_description = models.TextField(default='Opis kategorii',
                                            verbose_name="Opis kategorii (pole nie wymagane)", blank=True)
    category_keywords = models.TextField(default='', verbose_name="Słowa kluczowe (pole nie wymagane)", blank=True)

    class Meta:
        verbose_name_plural = " Kategorie"
        verbose_name = "Kategorię"
        ordering = ['category_name']

    def save(self, *args, **kwargs):
        self.slug = slugify(self.category_name)
        super(Category, self).save(*args, **kwargs)

    def admin_image_thumb(self):
        '''
        Miniaturka obrazka kategorii dla panelu admina
        '''
        if self.image:
            return '<img src="/media/%s" height="42" width="42" />' % self.image
        else:
            return '<img src="/media/category_images/default.ico" alt="" />'

    admin_image_thumb.short_description = 'Miniaturka'
    admin_image_thumb.allow_tags = True

    def image_thumb(self):
        '''
        Miniaturka obrazka kategorii
        '''
        if self.image:
            return '/media/%s' % self.image
        else:
            return '/media/category_images/default.ico'

    def get_active_sites(self):
        return Site.objects.filter(Q(category=self) | Q(category1=self), is_active=True)

    image_thumb.short_description = 'Miniaturka'
    image_thumb.allow_tags = True

    def __str__(self):
        return self.category_name


class SubCategory(models.Model):
    category = models.ForeignKey(
        'Category',
        related_name='subcategory',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        verbose_name='Kategoria nadrzędna'
    )
    subcategory_name = models.CharField(max_length=30, verbose_name="Nazwa subkategorii")
    slug = models.SlugField()

    def save(self, *args, **kwargs):
        self.slug = slugify(self.subcategory_name)
        super(SubCategory, self).save(*args, **kwargs)

    def get_active_sites(self):
        return Site.objects.filter(Q(subcategory=self) | Q(subcategory1=self), is_active=True)

    class Meta:
        verbose_name_plural = " Subkategorie"
        ordering = ['subcategory_name']

    def __str__(self):
        return self.subcategory_name


def get_deadline():
    return datetime.today() + timedelta(days=20)


class Site(models.Model):
    category = models.ForeignKey('Category', verbose_name="Kategoria")
    subcategory = ChainedForeignKey(
        'SubCategory',
        verbose_name="Subkategoria",
        chained_field='category',
        chained_model_field='category',
        show_all=False,
        auto_choose=True,
        default=None)
    name = models.CharField(max_length=config.TITLE_LENGTH_MAX, verbose_name="Tytuł")
    slug = models.SlugField(max_length=500)
    description = models.TextField(max_length=config.DESCRIPTION_LENGTH_MAX, verbose_name="Opis")
    # importuje zmienione TextFields widgets.py
    keywords = MyTextField(max_length=config.KEYWORDS_LENGTH_MAX, verbose_name="Słowa kluczowe")
    date = models.DateTimeField(default=datetime.now, verbose_name="Data dodania/modyfikacji")
    date_end = models.DateTimeField(null=True, blank=True, default=None, verbose_name="Data wygaśnięcia wpisu premium")
    url = models.URLField()
    is_active = models.BooleanField(default=False, verbose_name='Aktywna')

    flagged = models.TextField(max_length=400, verbose_name="Przesłanki do oflagowania strony jako \
        niedzełająca/podejrzana", null=True, blank=True, default='')
    flagged_true = models.BooleanField(
        default=False, verbose_name='Czy strona jest oflagowana jako niedziałająca/podejrzana')

    category1 = models.ForeignKey('Category', related_name='category', blank=True,
                                  null=True, default=None, verbose_name="Kategoria dodatkowa")
    subcategory1 = ChainedForeignKey(
        'SubCategory',
        verbose_name="Subkategoria dodatkowa",
        chained_field='category1',
        chained_model_field='category',
        related_name='subcategory',
        show_all=False,
        auto_choose=True, blank=True, null=True)

    group = models.ForeignKey('Group', verbose_name="Grupa", default='Podstawowy',
                              help_text="<div id='group'><ul><li>Możesz dodać wpis do 1 kategorii</b></li></ul></div>")

    email = models.EmailField(help_text='Podaj adres email')
    user = models.CharField(max_length=100, verbose_name="Nazwa użytkownika")
    kod = models.CharField(max_length=20, blank=False)

    # ustawienia boolean do okreslania ktore pola maja byc brane pod uwage przy
    # sprawdzaniu poprawnosci wczytywania stron

    little_chars_check = models.BooleanField(
        default=True, verbose_name='Czy sprawdzać czy kod strony zawiera podejrzanie mało znaków')
    evil_words_check = models.BooleanField(
        default=True, verbose_name='Czy sprawdzać czy kod strony zawiera podejrzane słowa (definiowane w ustawieniach)')
    aftermarket_check = models.BooleanField(
        default=True, verbose_name='Czy sprawdzać czy domena nie jest wystawiona do sprzedaży (Aftermarket)')

    def save(self, *args, **kwargs):
        self.slug = slugify(self.name)
        # if len(self.flagged.splitlines() > 3):
        #     self.flagged_true = True
        super(Site, self).save(*args, **kwargs)

    def get_absolute_url(self):
        if self.id:
            return reverse('site', args=[str(self.category.slug),
                                         str(self.subcategory.slug), str(self.slug), str(self.id)])

    def get_thumb(self):
        host = urlparse(self.url).hostname
        if host.startswith('www.'):
            host = host[4:]
        # thumb = 'http://free.pagepeeker.com/thumbs.php?size=l&url=http://' + host
        thumb = 'https://images.shrinktheweb.com/xino.php?stwembed=1&stwsize=320x&stwaccesskeyid={}&stwurl=http://{}'.format(
            config.SHRINKTHEWEB_KEY, host)
        return thumb

    class Meta:
        verbose_name_plural = "Strony"
        verbose_name = "Stronę"

    def __str__(self):
        return self.name


class Group(models.Model):
    group_name = models.CharField(max_length=30, verbose_name='Nazwa grupy', unique=True)
    codes = models.TextField(null=True, blank=True, verbose_name='Kody dostępowe wpisywane jeden pod drugim')
    secret_codes = models.TextField(
        null=True, blank=True, verbose_name='Kody tajne (wielokrotnego użytku) wpisywane jeden pod drugim')
    pay = models.CharField(
        max_length=10,
        choices=(('PAID', 'PŁATNY'), ('FREE', 'DARMOWY')),
        default='FREE',
        verbose_name="Czy płatny",
        help_text='Wpis płatny aktywowany wyłącznie po wpisaniu właściwego kodu')
    time = models.CharField(
        max_length=3,
        choices=(('T', 'CZASOWY'), ('N', 'BEZTERMINOWY')),
        default='N',
        help_text='Czy wpis ma być wyłączony po jakimś czasie czy bezterminowy')
    days = models.IntegerField(default=1, verbose_name='Czas obowiązywania')
    premium_box = models.CharField(
        max_length=3,
        choices=(('T', 'TAK'), ('N', 'NIE')),
        default='N',
        help_text='Czy wpis ma być wyświetlany w okienku reklamowym')
    category = models.CharField(
        max_length=2,
        choices=(('1', '1'), ('2', '2')),
    )
    text = RichTextField(verbose_name="Opis opcji dostępnych dla grupy")

    is_active = models.BooleanField(default=True, verbose_name='Aktywna')

    class Meta:
        verbose_name_plural = "Grupy wpisów"
        verbose_name = "grupę"

    def __str__(self):
        return self.group_name
