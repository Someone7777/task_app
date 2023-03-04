from rest_framework import serializers
from authentication.models import User
from django.utils.translation import gettext_lazy as _

def check_user_with_email(email):
    """
    Checks an user exists with email arg and is verified
    """
    user = None
    try: user = User.objects.get(email=email)
    except: raise serializers.ValidationError(
            {"email": _("User not found")})
    if user.verified:
        raise serializers.ValidationError(
            {"email": _("User already verified")})

def check_username_pass12(username, email, full_name, password1, password2):
    """
    Checks if 2 passwords are different, also that username and email 
    are different to the passwords
    """
    if password1 != password2:
        raise serializers.ValidationError(
            {"password": _("Password fields do not match")})
    if username == password1 or email == password1 or full_name == password1:
        raise serializers.ValidationError(
            {"password": _("Password cannot match other profile data")})

def check_username_newpass(username, email, new_password):
    """
    Checks if new password is different to username and email
    """
    if username == new_password or email == new_password:
        raise serializers.ValidationError(
            {"new_password": _("New password cannot match other profile data")})