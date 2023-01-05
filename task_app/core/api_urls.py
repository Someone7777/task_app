from django.urls import path, include
from authentication.api import urls as auth_urls
from tasks.api import urls as task_urls

urlpatterns = [
    # Auth app urls:
    path("", include(auth_urls)),
    # Task app urls:
    path("", include(task_urls)),
]