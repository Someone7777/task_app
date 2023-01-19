from django.contrib import admin
from tasks.models import Task

@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    fields = (
        'id',
        'title', 
        'description', 
        'created',
        'finished',
        'deadline',
        'owner', 
    )
    readonly_fields = (
        'id', 'created',
    )
    list_display = (
        'finished', 
        'deadline',
        'created',
    )
    list_filter = ('finished',)
    search_fields = ('title',)
    ordering = ('created','deadline',)