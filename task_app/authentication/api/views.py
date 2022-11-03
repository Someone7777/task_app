from authentication.api.serializers.jwt_code_serializers import CustomTokenObtainPairSerializer
from rest_framework.parsers import JSONParser
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from authentication.api.serializers.jwt_code_serializers import CustomTokenRefreshSerializer

class CustomTokenObtainPairView(TokenObtainPairView):
    permission_classes = (AllowAny,)
    serializer_class = CustomTokenObtainPairSerializer
    parser_classes = (JSONParser,)

class CustomTokenRefreshView(TokenRefreshView):
    """
    Refresh token generator view.
    """
    serializer_class = CustomTokenRefreshSerializer