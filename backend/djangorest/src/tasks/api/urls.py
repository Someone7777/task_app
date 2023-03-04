from django.urls import path
from tasks.api.views import TaskListCreateView, TaskReadUpdateDeleteView

urlpatterns = [
    path("task", TaskListCreateView.as_view(), name='task_list_create'),
    path("task/<int:pk>", TaskReadUpdateDeleteView.as_view(), name='task_read_update_destroy'),
]