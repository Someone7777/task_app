from rest_framework import generics
from tasks.models import Task
from core.permissions import IsCurrentVerifiedUser
from tasks.api.serializers import TaskSerializer

class TaskReadUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Task.objects.all()
    permission_classes = (IsCurrentVerifiedUser,)
    serializer_class = TaskSerializer

class TaskListCreateView(generics.ListCreateAPIView):
    queryset = Task.objects.all()
    permission_classes = (IsCurrentVerifiedUser,)
    serializer_class = TaskSerializer
