from rest_framework.permissions import AllowAny
from authentication.models import User
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from rest_framework import generics, status, mixins
from authentication.api.serializers.user_serializers import UserCreationSerializer

class UserCreationView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny,)
    serializer_class = UserCreationSerializer
    parser_classes = (FormParser, JSONParser,)