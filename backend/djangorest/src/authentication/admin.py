from django.contrib import admin
from django.contrib.auth.models import Group
from authentication.models import User

# Remove Groups from admin
admin.site.unregister(Group)

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    fields = (
        'id',
        'full_name', 
        'username', 
        'email',
        'language',
        'image',
        'last_login', 
        'date_joined',
        ('is_superuser', 'is_staff',),
        ('verified', 'is_active',),
        'code_sent',
        'date_code_sent',
        'pass_reset', 
        'date_pass_reset',
    )
    readonly_fields = (
        'id', 'last_login', 'date_joined', 
        'code_sent', 'date_code_sent',
    )
    list_display = (
        'email', 
        'username',
        'last_login',
        'is_active',
        'verified',
        'code_sent',
        'date_code_sent',
    )
    list_filter = ('is_active',)
    search_fields = ('email', 'username',)
    ordering = ('last_login','date_code_sent',)