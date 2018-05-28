from django.db import models
from django.forms import Textarea


class MyTextField(models.TextField):
    '''
    Textfield dla keywordsow - modyfikacja parametrow
    '''

    def formfield(self, **kwargs):
        kwargs.update(
            {"widget": Textarea(attrs={'rows': 2, 'cols': 85})}
        )
        return super(MyTextField, self).formfield(**kwargs)
