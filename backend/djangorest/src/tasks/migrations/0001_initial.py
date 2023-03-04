# Generated by Django 4.0.8 on 2022-12-29 18:52

from django.conf import settings
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Task',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=50, validators=[django.core.validators.MinLengthValidator(1)], verbose_name='title')),
                ('description', models.CharField(max_length=300, validators=[django.core.validators.MinLengthValidator(0)], verbose_name='description')),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('finished', models.DateTimeField(blank=True, null=True, verbose_name='finished')),
                ('deadline', models.DateTimeField(verbose_name='deadline')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='owner')),
            ],
        ),
    ]