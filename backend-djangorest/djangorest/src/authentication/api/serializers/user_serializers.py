from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from authentication.models import User
from django.contrib.auth.password_validation import validate_password
from django.utils.translation import check_for_language, gettext_lazy as _
from authentication.api.serializers.utils import check_username_pass12
from authentication.exceptions import SameUsernameEmailException
from rest_framework.serializers import ValidationError


class UserCreationSerializer(serializers.ModelSerializer):
    """
    Serializer for User creation (register)
    """
    username = serializers.CharField(
        required=True, 
        max_length=15,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    email = serializers.EmailField(
        required=True, 
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    full_name = serializers.CharField(
        required=True, 
        max_length=50,
    )
    password = serializers.CharField(
        required=True, 
        write_only=True,
        max_length=100,
        validators=[validate_password]
    )
    password2 = serializers.CharField(
        required=True, 
        write_only=True,
    )

    class Meta:
        model = User
        fields = [
            'username',
            'email',
            'full_name',
            'language',
            'password',
            'password2'
        ]
        extra_kwargs = {
            "language": {"required": True}
        }

    def validate_language(self, value):
        if not check_for_language(value):
            raise ValidationError(_("Language not supported"))
        return value

    def validate(self, attrs):
        check_username_pass12(attrs['username'], attrs['email'],
                              attrs['full_name'],
                              attrs['password'], attrs['password2'])
        if attrs['username'] == attrs['email']:
            raise SameUsernameEmailException()
        return attrs
    
    def create(self, validated_data):
        language = validated_data['language']
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            language=language
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class UserRetrieveUpdateDestroySerializer(serializers.ModelSerializer):
    """
    Serializer to get, update or delete user data
    """
    username = serializers.CharField(
        required=True, 
        max_length=15,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    
    class Meta:
        model = User
        fields = [
            'username',
            'email',
            'full_name',
            'language',
            'last_login',
            'image'
        ]
        read_only_fields = [
            'last_login',
            'email',
        ]