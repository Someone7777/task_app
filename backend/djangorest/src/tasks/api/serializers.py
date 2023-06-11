from rest_framework import serializers
from tasks.models import Task

class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = [
            'id',
            'title',
            'description',
            'created',
            'finished',
            'deadline'
        ]
        read_only_fields = [
            'id',
            'created'
        ]