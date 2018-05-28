from django.apps import AppConfig


class MainappConfig(AppConfig):
    name = 'mainapp'
    verbose_name = "Katalog - zarządzanie stronami"


class ConstanceConfig(AppConfig):
    name = 'constance'
    verbose_name = 'Ustawienia katalogu'
