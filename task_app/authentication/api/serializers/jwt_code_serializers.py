from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.utils.translation import gettext_lazy as _


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):

    @classmethod
    def get_token(cls, user):
        if not user.verified:
            raise serializers.ValidationError(
                {"verified": _("Unverified email")})
        token = super(CustomTokenObtainPairSerializer, cls).get_token(user)

        # Custom keys added in PAYLOAD
        token['username'] = user.username
        token['email'] = user.email
        return token
