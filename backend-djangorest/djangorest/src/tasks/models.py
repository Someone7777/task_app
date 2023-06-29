from django.db import models
from django.core.validators import MinLengthValidator
from django.utils.translation import gettext_lazy as _
from authentication.models import User

# Create your models here.
class Task(models.Model):
    title = models.CharField(
        verbose_name =_("title"),
        validators = [MinLengthValidator(1)],
        max_length = 50
    )
    description = models.CharField(
        verbose_name =_("description"),
        validators = [MinLengthValidator(0)],
        max_length = 300
    )
    created = models.DateTimeField(auto_now_add=True)
    finished = models.DateTimeField(
        verbose_name =_("finished"),
        null=True,
        blank=True
    )
    deadline = models.DateTimeField(
        verbose_name =_("deadline"),
    )
    owner = models.ForeignKey(
        User,
        verbose_name = _('owner'),
        on_delete = models.CASCADE
    )

    class Meta:
        ordering = ['-created']
