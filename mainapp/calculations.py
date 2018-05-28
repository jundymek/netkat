#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Stdlib imports
from collections import Counter
import random
import operator
from datetime import datetime
from urllib.parse import urlsplit
import re
import requests

# Core Django imports
from django.db.models import Q
from django.core.mail import send_mail
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist

# Third-party app imports
from bs4 import BeautifulSoup
from constance import config

# Imports form my apps
from .models import Site, Category, SubCategory, Group


class SiteList():
    """
    Wczytanie do widoku subcategory listy stron dla podkategorii
    """

    def __init__(self, category_slug, subcategory_slug=None):
        self.cat_slug = category_slug
        self.subcat_slug = subcategory_slug

    def get_context(self):
        context = {}
        if self.subcat_slug is None:
            category = Category.objects.get(slug=self.cat_slug)
            sites = Site.objects.filter(Q(category=category) | Q(category1=category),
                                        is_active=True).order_by('-group', '-date')
            subcategory = SubCategory.objects.values().filter(category=category)
        else:
            category = Category.objects.get(slug=self.cat_slug)
            subcategory = SubCategory.objects.filter(category=category
                                                     ).get(slug=self.subcat_slug)
            sites = Site.objects.filter(Q(subcategory=subcategory) | Q(
                subcategory1=subcategory), is_active=True).order_by('-group', '-date')
        context['subcategory'] = subcategory
        context['category'] = category
        context['sites'] = sites
        return context


class AddNewSite():

    def __init__(self, url, user=None, email=None, category=None, subcategory=None, date_end=None):
        self.url = url
        self.user = user
        self.email = email
        try:
            req = requests.get(self.url, timeout=2, headers={
                'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0'})
            req.encoding = 'utf-8'
            self.page = req.text
        except(requests.ConnectionError, requests.HTTPError):
            self.page = ''
        self.soup = BeautifulSoup(self.page)
        self.meta = self.soup.find_all('meta')
        self.category = category
        self.subcategory = subcategory
        self.date_end = datetime.now()

    def check_soup(self):
        """
        Sprawdzenie moduł Request nawiązuje połączenie z serwerem strony w celu
        pobrania metadanych
        """
        if self.page == '':
            return True

    def get_initial_data(self):
        keywords = AddNewSite(self.url).keywords()
        description = AddNewSite(self.url).description()
        name = AddNewSite(self.url).title()
        if name and (len(name) > config.TITLE_LENGTH_MAX):
            name = name[:config.TITLE_LENGTH_MAX].split(' ')
            del name[-1]
            name = ' '.join(name)
        if keywords and (len(keywords) > config.KEYWORDS_LENGTH_MAX):
            keywords = keywords[:config.KEYWORDS_LENGTH_MAX].split(',')
            del keywords[-1]
            keywords = ','.join(keywords)
        if description and (len(description) > config.DESCRIPTION_LENGTH_MAX):
            description = description[:config.DESCRIPTION_LENGTH_MAX].split(' ')
            del description[-1]
            description = ' '.join(description)
        initial_data = {
            'user': self.user,
            'email': self.email,
            'url': self.url,
            'name': name,
            'description': description,
            'keywords': keywords,
            'category': self.category,
            'subcategory': self.subcategory,
            'date_end': self.date_end
        }
        return initial_data

    def title(self):
        try:
            name = self.soup.title.string
            return name
        except AttributeError:
            return ''

    def description(self):
        description = self.soup.find_all(attrs={'name':
                                                    ['description', 'Description']})
        if description:
            return (description[0]['content'])

    def keywords(self):
        keywords = self.soup.find_all(attrs={'name': ['keywords',
                                                      'Keywords']})
        if keywords:
            return (keywords[0]['content'])

    def check_url_in_database(self):
        """
        Sprawdzenie czy wprowadzony url wystepuje w bazie
        """
        url = urlsplit(self.url).netloc
        if url.startswith('www.'):
            url = url[4:]
        try:
            Site.objects.get(url__contains=url)
            return True
        except ObjectDoesNotExist:
            return False

    def check_url_subpage(self):
        """
        Sprawdzanie czy podany url nie jest podstrona
        """
        if self.url.count('/') > 2:
            if self.url.count('/') == 3 and self.url[-1] == '/':
                return False
            return True

    def check_urls(self):
        """
        Sprawdza liczbe urli w opisie strony
        """
        url_number = self.description().count('href')
        return url_number


class CodeCheck():

    def __init__(self, code, group):
        self.code = code
        self.group = group

    def check_code_validation(self):
        """
        Sprawdzenie czy podany kod istnieje w danej grupie
        """
        x = Group.objects.get(group_name=self.group)
        kody = []
        kody_tajne = []
        if x.codes:
            kody = x.codes.strip().split()
        if x.secret_codes:
            kody_tajne = x.secret_codes.strip().split()
        if self.code in kody_tajne:
            return True
        if self.code in kody:
            return True
        return False

    def code_remove(self):
        """
        Usuniecie wykorzystanego kodu z grupy
        """
        x = Group.objects.get(group_name=self.group)
        kody = x.codes.strip().split()
        if self.code in kody:
            kody.remove(self.code)
            nowa_lista_kodow = ''
            for kod in kody:
                nowa_lista_kodow += (kod + '\n')
            x.codes = nowa_lista_kodow
            x.save()


class SendEmail():
    """
    Wysylanie maili potwierdzajacych przyjecie wpisu do moderacji
    """

    def __init__(self, email, user, url=None, host=None, message=None, path=None, ):
        self.email = email
        self.url = url
        self.user = user
        self.host = host
        self.message = message
        if host:
            self.path = str(host) + str(path)

    def send_confirmation_email(self):
        subject = 'Potwierdzenie dodania strony {}'.format(self.url)
        # message = config.EMAIL_ADD_SITE.format(self.url, self.email, self.user, self.host)
        message = 'Strona {} została dodana do moderacji. Po zatwierdzeniu ' \
                  'przez moderatora otrzymasz stosowną informację.\n\n{}'.format(
            self.url, self.host)
        from_email = settings.EMAIL_ADRESS
        to_email = self.email
        send_mail(
            subject,
            message,
            from_email,
            [to_email],
            fail_silently=False,
        )

    def send_activation_email(self):
        subject = 'Strona {} została aktywowana'.format(self.url)
        message = 'Witaj {} \n\nStrona {} została dodana do katalogu {} i ' \
                  'znajduje się na stronie {}.\n\n{}'.format(
            self.user, self.url, config.SITE_TITLE, self.path, self.host)
        from_email = settings.EMAIL_ADRESS
        to_email = self.email
        send_mail(
            subject,
            message,
            from_email,
            [to_email],
            fail_silently=False,
        )

    def send_delete_email(self):
        subject = 'Strona {} została usunięta z katalogu {}'.format(self.url, self.host)
        message = 'Witam {} \n\nStrona {} została usunięta z katalogu {} decyzją moderatora\n\n' \
                  'Przyczyna usunięcia wpisu: {}'.format(self.user, self.url, self.host, self.message)
        from_email = settings.EMAIL_ADRESS
        to_email = self.email
        send_mail(
            subject,
            message,
            from_email,
            [to_email],
            fail_silently=False,
        )

    def premium_end_email(self):
        subject = 'Wygaśnięcie wpisu PREMIUM - {}'.format(self.url)
        message = 'Witaj {} \n\nTwój wpis {} został przeniesiony do grupy ' \
                  'podstawowej z powodu wygaśnięcia wpisu premium. \n\n{}'.format(
            self.user, self.url, settings.ALLOWED_HOSTS[1])
        from_email = settings.EMAIL_ADRESS
        to_email = self.email
        send_mail(
            subject,
            message,
            from_email,
            [to_email],
            fail_silently=False,
        )

    def contact_email(self):
        subject = 'Formularz kontaktowy - nadawca {}'.format(self.user)
        from_email = settings.EMAIL_ADRESS
        to_email = settings.EMAIL_ADRESS
        message = self.user + str('\n\n') + self.message + str('\n\n' + str(self.email))
        send_mail(
            subject,
            message,
            from_email,
            [to_email],
            fail_silently=False,
        )


class Tags():
    """
    Klasa odpowiedzialna za generowanie tagow
    """

    def __init__(self, category_slug=None, subcategory_slug=None):
        self.category_slug = category_slug
        self.subcategory_slug = subcategory_slug

    def all_tags(self):
        """
        Zwrocenie wszystkich tagow, tagow kategorii lub subkategorii
        """
        try:
            category = Category.objects.get(slug=self.category_slug)
            sites = Site.objects.filter(category=category, is_active=True).values('keywords')
            try:
                subcategory = SubCategory.objects.filter(category=category
                                                         ).get(slug=self.subcategory_slug)
                # sprawdzanie czy strony widnieja w subkategoriach, czy subkategoriach1 i
                # odpowiednie filtrowanie tagow
                if Site.objects.filter(subcategory=subcategory, is_active=True).values('keywords'):
                    sites = Site.objects.filter(subcategory=subcategory, is_active=True).values('keywords')
                else:
                    sites = Site.objects.filter(subcategory1=subcategory, is_active=True).values('keywords')
            except ObjectDoesNotExist:
                sites = Site.objects.filter(category=category, is_active=True).values('keywords')
        except ObjectDoesNotExist:
            sites = Site.objects.filter(is_active=True).values('keywords')
        keywords = []
        tags = []
        for site in sites:
            keywords.append(site['keywords'].split(','))
        for keyword in keywords:
            for tag in keyword:
                tags.append(tag.strip())
        tags_dictionary = (dict(Counter(tags)))  # zliczenie wystepowania tagow i utworzenie slownika
        tags_dictionary = dict(sorted(tags_dictionary.items(), key=operator.itemgetter(1), reverse=True))
        for tag in tags_dictionary:
            # dodanie koloru i wielkosci dla kazdej wartosci
            size = ''
            color = "#%06x" % random.randint(0, 0xFFFFFF)
            if tags_dictionary[tag] in range(1, 5):
                size = 12
            elif tags_dictionary[tag] in range(6, 10):
                size = 16
            else:
                size = 20
            tags_dictionary[tag] = [tags_dictionary[tag], color, size]
        return (tags_dictionary)

    def tag_filer_sites(self, tag):
        """
        Filtrowanie stron dla konkretnego tagu
        """
        context = {}
        context['sites'] = Site.objects.filter(keywords__contains=tag, is_active=True)
        return context


class Keywords():
    """
    Formatowanie keywordsow (slowo, przecinek, spacja)
    """

    def __init__(self, object_keywords):
        self.keywords = object_keywords

    def proper_keywords(self):
        new = []
        result = []
        for x in self.keywords.split(','):
            new.append(re.sub('\W+', ' ', x))
        for keyword in new:
            if keyword != '':
                result.append(keyword)
        return ' '.join(', '.join(result).split()).lower().strip()
