import time
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from authentication.exceptions import NO_LONGER_VALID_CODE_ERROR
from authentication.models import User
import logging
from django.conf import settings
from django.utils.timezone import timedelta
from django.core.cache import cache
import core.tests.utils as test_utils


class PasswordResetTests(APITestCase):
    def setUp(self):
        # Mock Celery tasks
        settings.CELERY_TASK_ALWAYS_EAGER = True
        # Avoid WARNING logs while testing wrong requests
        logging.disable(logging.WARNING)
        # Throttling is stored in cache
        cache.clear()

        self.reset_password_start_url = reverse('reset_password_start')
        self.reset_password_verify_url = reverse('reset_password_verify')
        self.user_get_del_url = reverse('user_put_get_del')

        # User data
        self.user_data = {
            "username": "username",
            "full_name": "username",
            "email": "email@test.com",
            "password": "password1@212",
            "password2": "password1@212",
        }
        self.credentials = {
            "email": "email@test.com",
            "password": "password1@212"
        }
        # User creation
        user = User.objects.create(
            username=self.user_data["username"],
            email=self.user_data["email"],
            full_name=self.user_data["full_name"],
            verified=True
        )
        user.set_password(self.user_data['password'])
        user.save()
        return super().setUp()

    def send_code(self, email):
        return test_utils.post(
            self.client,
            self.reset_password_start_url,
            data={"email": email}
        )

    def verify_code_password(self, email, code, password):
        return test_utils.post(
            self.client,
            self.reset_password_verify_url,
            data={
                "email": email,
                "new_password": password,
                "code": code
            }
        )

    def test_send_password_reset_code(self):
        """
        Checks that password reset code is sent
        """
        response = self.send_code(self.user_data["email"])
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user = User.objects.get(email=self.user_data["email"])
        self.assertIsNotNone(user.pass_reset)

    def test_verify_password_reset_code(self):
        """
        Checks that password reset code is verified
        """
        self.send_code(self.user_data["email"])
        user = User.objects.get(email=self.user_data["email"])
        code = user.pass_reset
        response = self.verify_code_password(
            self.user_data["email"], code, "password1@214")
        self.assertEqual(response.status_code, status.HTTP_200_OK,
                         "Code verfication")
        self.credentials["password"] = "password1@214"
        response = test_utils.authenticate_user(self.client, self.credentials)
        self.assertEqual(response.status_code, status.HTTP_200_OK,
                         "Jwt obtain")

    def test_send_wrong_code(self):
        """
        Checks that sending a wrong password reset code should let change password
        """
        # Code generation first:
        self.send_code(self.user_data["email"])
        response = self.verify_code_password(
            self.user_data["email"], '123', "user123name456&")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        response = self.verify_code_password(
            self.user_data["email"], '123456', "user123name456&")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_send_invalid_code(self):
        """
        Checks that sending an invalid code should not modify the user as verified
        """
        # Code generation first:
        self.send_code(self.user_data["email"])
        # Set code validity to 1 second
        settings.EMAIL_CODE_VALID = 0
        # Get generated code
        code = User.objects.get(email=self.user_data['email']).pass_reset
        # Sleep for 2 seconds
        time.sleep(2)
        # Verify invalid code
        response = self.verify_code_password(
            self.user_data["email"], str(code), "user123name456&")
        # Undo changes
        settings.EMAIL_CODE_VALID = 120
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        self.assertEqual(NO_LONGER_VALID_CODE_ERROR,
                         response.data["error_code"])
