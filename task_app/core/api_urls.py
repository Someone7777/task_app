from django.urls import path, include
from authentication.api import urls as auth_urls

urlpatterns = [
    # Auth app urls:
    path("", include(auth_urls)),
]