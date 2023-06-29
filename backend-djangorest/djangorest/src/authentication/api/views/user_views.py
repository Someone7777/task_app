from rest_framework.permissions import AllowAny
from authentication.models import User
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from rest_framework import generics, status, mixins
from authentication.api.serializers.user_serializers import UserCreationSerializer, UserRetrieveUpdateDestroySerializer
from core.permissions import IsCurrentVerifiedUser

class UserCreationView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny,)
    serializer_class = UserCreationSerializer
    parser_classes = (FormParser, JSONParser,)

class UserRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    permission_classes = (IsCurrentVerifiedUser,)
    serializer_class = UserRetrieveUpdateDestroySerializer
    parser_classes = (MultiPartParser, FormParser, JSONParser)
    
    def get_object(self, queryset=None):
        return self.request.user
    
    def perform_update(self, serializer):
        if 'email' in serializer.validated_data:
            serializer.validated_data['verified'] = False
        serializer.save()