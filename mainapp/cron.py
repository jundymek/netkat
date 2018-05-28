# Stdlib imports
import requests
import smtplib
from datetime import datetime
# Django imports
from django.conf import settings

# Third-party app imports
from constance import config
import kronos
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Imports form my apps
from .models import Site
from .calculations import SendEmail


@kronos.register('0 19 * * *')
def check_sites():
    '''
    Sprawdzanie poprawności wczytywania stron. Flagowanie stron podejrzanych
    '''
    if config.CHECK_SITES == 'tak':
        sites = Site.objects.filter(is_active=True)
        for strona in sites.values('url'):
            change = False
            obj = Site.objects.get(url=strona['url'])
            try:
                opener = requests.get(strona['url'], headers={
                    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) \
                    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 \
                    Safari/537.36'
                })
                tekst_html = opener.text
                if tekst_html.count('\n') < 10 and obj.little_chars_check is True:
                    if obj.flagged and len(obj.flagged) == 0:
                        obj.flagged += 'Znikomy kod strony - ' + \
                            str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                        change = True
                    else:
                        obj.flagged += '\n' + 'Znikomy kod strony - ' + \
                            str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S")) + \
                            ' liczba wierszy ' + str(tekst_html.count('\n'))
                        change = True
                elif 'https://www.aftermarket.pl/login.php' in tekst_html and obj.aftermarket_check is True:
                    if len(obj.flagged) == 0:
                        obj.flagged += 'Domena prawdopodobnie wystawiona do sprzedaży: ' + \
                            str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                        change = True
                    elif len(obj.flagged) > 0:
                        obj.flagged += '\n' + 'Domena prawdopodobnie wystawiona do sprzedaży: ' + \
                            str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                        change = True
                else:
                    if obj.evil_words_check is True:
                        zabronione = [wyraz.strip() for wyraz in str(config.EVIL_WORDS).split(',')]
                        znalezione = []
                        for wyraz in tekst_html.split():
                            if wyraz in zabronione:
                                if tekst_html.split().count(wyraz) >= config.EVIL_WORDS_COUNT:
                                    if wyraz not in znalezione:
                                        znalezione.append(wyraz)
                        if len(obj.flagged) == 0 and znalezione != []:
                            obj.flagged += 'Znaleziono podejrzane natężenie wyrazu(ów): ' + \
                                ', '.join(znalezione) + ' ' + str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                            change = True
                        elif len(obj.flagged) > 0 and znalezione != []:
                            obj.flagged += '\n' + 'Znaleziono podejrzane natężenie wyrazu(ów): ' + \
                                ', '.join(znalezione) + ' ' + str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                            change = True
            except Exception as error:
                if obj.flagged and len(obj.flagged) == 0:
                    obj.flagged += 'Błąd serwera - ' + str(error) + '- ' + \
                        str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                    change = True
                else:
                    obj.flagged += '\n' + 'Błąd serwera - ' + str(error) + '- ' + \
                        str(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))
                    change = True
            num_errors = obj.flagged.count('\n')
            if obj.flagged_true is True and config.DELETE_SITES == 'tak':
                obj.delete()
                continue
            if num_errors == 3:
                obj.flagged_true = True
            if num_errors > 3:
                obj.flagged = '\n'.join(obj.flagged.split('\n')[1:])
            if not change:
                obj.flagged = ''
                obj.flagged_true = False
            obj.save()


@kronos.register('0 20 * * *')
def to_moderate():
    '''
    Powiadomienia mailowe o wpisach oczekujących
    '''
    if config.WPISY_DO_MODERACJI == 'tak':
        inactive = Site.objects.filter(is_active=False).count()
        fromaddr = settings.EMAIL_ADRESS
        toaddr = "jundymek@gmail.com"
        msg = MIMEMultipart()
        msg['From'] = fromaddr
        msg['To'] = toaddr
        msg['Subject'] = "Do moderacji: {} wpisy(ów) - {}".format(inactive, settings.ALLOWED_HOSTS[1])
        body = "Przejdź do panelu administracyjnego, żeby wymoderować wpisy oczekujące: {}/admin".format(
            settings.ALLOWED_HOSTS[1])
        msg.attach(MIMEText(body, 'plain'))
        server = smtplib.SMTP(settings.EMAIL_HOST, settings.EMAIL_PORT)
        server.login(fromaddr, settings.EMAIL_HOST_PASSWORD)
        text = msg.as_string()
        if inactive >= config.ILOSC_WPISOW:
            server.sendmail(fromaddr, toaddr, text)
        server.quit()


@kronos.register('0 * * * *')
def premium_end():
    '''
    Sprawdzanie czy wpis premium nie dobiegl konca
    '''
    sites = Site.objects.filter(is_active=True, group_id=2)
    for site in sites.values('url'):
        obj = Site.objects.get(url=site['url'])
        if obj.date_end <= datetime.now():
            obj.group_id = 1
            obj.category1 = None
            obj.subcategory1 = None
            obj.date_end = None
            obj.save()
            SendEmail(obj.email, obj.user, obj.url, None, None, None).premium_end_email()
