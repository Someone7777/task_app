from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from authentication.models import User
import logging
import core.tests.utils as test_utils


class UserGetDelTests(APITestCase):
    def setUp(self):
        # Avoid WARNING logs while testing wrong requests
        logging.disable(logging.WARNING)

        self.user_post_url = reverse('user_post')
        self.jwt_obtain_url = reverse('jwt_obtain_pair')
        self.user_get_del_url = reverse('user_put_get_del')

        # User data
        self.user_data = {
            "username": "username",
            "full_name": "username",
            "email": "email@test.com",
            "password": "password1@212",
            "password2": "password1@212",
            'language': 'en'
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
        # Authenticate
        test_utils.authenticate_user(self.client, self.credentials)
        return super().setUp()

    def test_get_user_data(self):
        """
        Checks that user data is correct
        """
        response = test_utils.get(self.client, self.user_get_del_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user_data2 = {
            "username": self.user_data["username"],
            "email": self.user_data["email"],
            "full_name": self.user_data["full_name"],
        }
        self.assertEqual(response.data["username"], user_data2["username"])
        self.assertEqual(response.data["email"], user_data2["email"])
        self.assertEqual(response.data["full_name"], user_data2["full_name"])

    def test_delete_user(self):
        """
        Checks that user gets deleted
        """
        response = test_utils.delete(self.client, self.user_get_del_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
