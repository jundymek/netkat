from django.conf.urls import url
from mainapp import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^contact/$', views.contact, name='contact'),
    url(r'^rejestracja/$', views.register, name='register'),
    url(r'^regulamin/$', views.regulamin, name='regulamin'),
    url(r'^logowanie/$', views.user_login, name='login'),
    url(r'^wylogowanie/$', views.user_logout, name='logout'),
    url(r'^get_subcategory/(?P<category_id>[0-9]+)/$', views.get_subcategory, name='get_subcategory'),
    url(r'^tag/(?P<slug>[\w-]+)/$', views.tags, name='tags'),
    url(r'^premium/(?P<id>[\w\-]+)/$', views.premium, name='premium'),
    url(r'^(?P<category_slug>[\w\-]+)/$', views.category, name='category'),
    url(r'^(?P<category_slug>[\w\-]+)/(?P<subcategory_slug>[\w\-]+)/$',
        views.subcategory, name='subcategory'),
    url(r'^(?P<category_slug>[\w\-]+)/(?P<subcategory_slug>[\w\-]+)/add_new_site/$',
        views.add_site, name='add_site'),
    url(r'^(?P<category_slug>[\w\-]+)/(?P<subcategory_slug>[\w\-]+)/(?P<slug>[\w\-]+)/(?P<id>[\w\-]+)/$',
        views.site,
        name='site'),
]
