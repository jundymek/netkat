# ------------------------------------------------------------------
# USTAWIENIA NETKAT - SKONFIGURUJ PONIŻSZE POLA ZGODNIE Z INSTRUKCJĄ
# ------------------------------------------------------------------


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'YOUR SECRET KEY'

ALLOWED_HOSTS = ['YOUR ALLOWED HOSTS']

GOOGLE_ANALYTICS_PROPERTY_ID = 'YOUR GA ID'

# Database settings

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'NAZWA_BAZY',
        'USER': 'NAZWA_UZYTKOWNIKA',
        'PASSWORD': 'HASLO_BAZY',
        'HOST': 'ADRES_HOSTA',
        'PORT': '',
    }
}

# SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTOCOL', 'https')
# SECURE_SSL_REDIRECT = True
# SESSION_COOKIE_SECURE = True
# CSRF_COOKIE_SECURE = True

# Email settings

EMAIL_HOST = ''  # serwer poczty
EMAIL_PORT = 25  # port poczty
EMAIL_HOST_USER = 'user@domena.pl'
EMAIL_ADRESS = 'user@domena.pl'
EMAIL_HOST_PASSWORD = ''  # hasło poczty

# Captcha settings

RECAPTCHA_PUBLIC_KEY = 'YOUR RECAPTCHA_PUBLIC_KEY'
RECAPTCHA_PRIVATE_KEY = 'YOUR_RECAPTCHA_PRIVATE_KEY'
