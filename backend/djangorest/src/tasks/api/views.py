from rest_framework import generics
from tasks.models import Task
from core.permissions import IsCurrentVerifiedUser
from tasks.api.serializers import TaskSerializer
from django.db import transaction


class TaskReadUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Task.objects.all()
    permission_classes = (IsCurrentVerifiedUser,)
    serializer_class = TaskSerializer
    
    def get_queryset(self):
        """
        Filter objects by owner
        """
        if getattr(self, 'swagger_fake_view', False):
            return Task.objects.none()  # return empty queryset
        return Task.objects.filter(owner=self.request.user)

    def perform_update(self, serializer):
        with transaction.atomic():
            serializer.save()

    def perform_destroy(self, instance):
        with transaction.atomic():
            instance.delete()


class TaskListCreateView(generics.ListCreateAPIView):
    queryset = Task.objects.all()
    permission_classes = (IsCurrentVerifiedUser,)
    serializer_class = TaskSerializer
    
    def get_queryset(self):
        """
        Filter objects by owner
        """
        if getattr(self, 'swagger_fake_view', False):
            return Task.objects.none()  # return empty queryset
        if self.request.method == 'GET':
            return Task.objects.filter(owner=self.request.user)
        else: return super().get_queryset()

    def perform_create(self, serializer):
        owner = self.request.user
        with transaction.atomic():
            # Inject owner data to the serializer
            serializer.save(owner=owner)
