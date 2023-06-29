from django.urls import path
from authentication.api.views.jwt_views import (
    CustomTokenObtainPairView,
    CustomTokenRefreshView,
)
from authentication.api.views.user_views import (
    UserCreationView,
    UserRetrieveUpdateDestroyView
)
from authentication.api.views.code_views import (
    ChangePasswordView,
    UserCodeVerifyView, 
    UserCodeSendView,
    ResetPasswordStartView,
    ResetPasswordVerifyView,
)

urlpatterns = [
    path("jwt", CustomTokenObtainPairView.as_view(), name="jwt_obtain_pair"),
    path("jwt/refresh", CustomTokenRefreshView.as_view(), name="jwt_refresh"),
    path("user", UserCreationView.as_view(), name="user_post"),
    path("user/code/send", UserCodeSendView.as_view(), name="email_code_send"),
    path("user/code/verify", UserCodeVerifyView.as_view(), name="email_code_verify"),
    path("user/profile", UserRetrieveUpdateDestroyView.as_view(), name='user_put_get_del'),
    path('user/password/change', ChangePasswordView.as_view(), name='change_password'),
    path('user/password/reset', ResetPasswordStartView.as_view(), name='reset_password_start'),
    path('user/password/reset/verify', ResetPasswordVerifyView.as_view(), name='reset_password_verify'),
]