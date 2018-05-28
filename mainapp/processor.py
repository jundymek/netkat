# Stdlib imports
import json

# Core Django imports
from django.contrib.auth.models import User

# Third-party app imports
from constance import config

# Imports form my apps
from .models import Site, Category, SubCategory, Group
from .calculations import Tags


def my_context_processor(request):

    return {'sites_all': Site.objects.all().count(),
            'sites_active': Site.objects.filter(is_active=True).count(),
            'sites_inactive': Site.objects.filter(is_active=False).count(),
            'sites_flagged': Site.objects.filter(flagged_true=True, is_active=True).count(),
            'user_sites_count': Site.objects.filter(user=request.user,
                                                    is_active=True).count(),
            'user_count': User.objects.all().count(),
            'categories_all': Category.objects.all().count(),
            'subcategories_all': SubCategory.objects.all().count(),
            'tags': Tags().all_tags(),
            'urls': Site.objects.values('url'),
            'sites_premium': Site.objects.filter(group_id=2, is_active=True),
            'js_data_title_max': json.dumps(config.TITLE_LENGTH_MAX),
            'js_data_title_min': json.dumps(config.TITLE_LENGTH_MIN),
            'js_data_keywords_max': json.dumps(config.KEYWORDS_LENGTH_MAX),
            'js_data_keywords_min': json.dumps(config.KEYWORDS_LENGTH_MIN),
            'js_data_description_max': json.dumps(config.DESCRIPTION_LENGTH_MAX),
            'js_data_description_min': json.dumps(config.DESCRIPTION_LENGTH_MIN),
            'js_data_text_group_base': json.dumps(Group.objects.get(pk=1).text),
            'js_data_text_group_premium': json.dumps(Group.objects.get(pk=2).text),
            'wyswig': json.dumps(config.EDYTOR_WYSWIG),
            'config': config,
            'host': request.META['HTTP_HOST']}
