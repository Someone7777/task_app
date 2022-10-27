from authentication.api.serializers.jwt_code_serializers import CustomTokenObtainPairSerializer
from rest_framework.parsers import JSONParser
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView

class CustomTokenObtainPairView(TokenObtainPairView):
    permission_classes = (AllowAny,)
    serializer_class = CustomTokenObtainPairSerializer
    parser_classes = (JSONParser,)
