from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from authentication.exceptions import SAME_USERNAME_EMAIL_ERROR
from authentication.models import User
import logging
import core.tests.utils as test_utils


class UserPostTests(APITestCase):
    def setUp(self):
        # Avoid WARNING logs while testing wrong requests
        logging.disable(logging.WARNING)

        self.user_post_url = reverse('user_post')

        # Test user data
        self.user_data = {
            "username": "username",
            "full_name": "username",
            "language": "en",
            "email": "email@test.com",
            "password": "password1@212",
            "password2": "password1@212",
        }
        return super().setUp()

    def test_user(self):
        """
        Checks that an user with user_post url is created
        """
        response = test_utils.post(
            self.client, self.user_post_url, self.user_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        new_user = User.objects.get(email=self.user_data['email'])
        self.assertIsNotNone(new_user)
        self.assertEqual(new_user.email, self.user_data['email'])
        self.assertEqual(new_user.username, self.user_data['username'])
        self.assertEqual(new_user.verified, False)

    def test_two_user_with_username(self):
        """
        Checks that an user with an used username is not created
        """
        # User 1 creation
        response = test_utils.post(
            self.client, self.user_post_url, self.user_data)
        # User 2 creation
        user_data2 = self.user_data
        user_data2['email'] = 'email2@test.com'
        response = test_utils.post(self.client, self.user_post_url, user_data2)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        self.assertIn('username', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('This field must be unique.', [field_body["detail"]
                      for field_body in response.data["fields"]])

    def test_two_user_with_email(self):
        """
        Checks that an user with an used email is not created
        """
        # User 1 creation
        response = test_utils.post(
            self.client, self.user_post_url, self.user_data)
        # User 2 creation
        user_data2 = self.user_data
        user_data2['username'] = 'username2'
        response = test_utils.post(self.client, self.user_post_url, user_data2)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        
        self.assertIn('email', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('This field must be unique.', [field_body["detail"]
                      for field_body in response.data["fields"]])

    def test_empty_user(self):
        """
        Checks that an user with no data is not created
        """
        response = test_utils.post(self.client, self.user_post_url, {})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('username', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('full_name', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('password2', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_none_email(self):
        """
        Checks that an user with no email is not created
        """
        response = test_utils.post(
            self.client,
            self.user_post_url,
            {
                'username': self.user_data['username'],
                'full_name': self.user_data['full_name'],
                "password": self.user_data['password'],
                "password2": self.user_data['password2']
            }
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_none_username(self):
        """
        Checks that an user with no username is not created
        """
        response = test_utils.post(
            self.client,
            self.user_post_url,
            {
                'email': self.user_data['email'],
                'full_name': self.user_data['full_name'],
                "password": self.user_data['password'],
                "password2": self.user_data['password2']
            }
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('username', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_none_full_name(self):
        """
        Checks that an user with no full name is not created
        """
        response = test_utils.post(
            self.client,
            self.user_post_url,
            {
                'email': self.user_data['email'],
                'username': self.user_data['username'],
                "password": self.user_data['password'],
                "password2": self.user_data['password2']
            }
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('full_name', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_different_passwords(self):
        """
        Checks that an user with diferent passwords is not created
        """
        data = self.user_data
        data["password2"] = 'pass12'
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])
        self.assertIn('Password fields do not match', [field_body["detail"]
                      for field_body in response.data["fields"]])


    def test_short_password(self):
        """
        Checks that an user with a short password is not created
        """
        data = self.user_data
        data["password"] = 'admin'
        data["password2"] = 'admin'
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_common_password(self):
        """
        Checks that an user with a too common password is not created
        """
        data = self.user_data
        data["password"] = 'admin1234'
        data["password2"] = 'admin1234'
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_only_username_user_post(self):
        """
        Checks that an user with a too common password is not created
        """
        data = self.user_data
        data["username"] = 'username@1L24'
        data["password"] = 'username@1L24'
        data["password2"] = 'username@1L24'
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_only_username_user_post(self):
        """
        Checks that an user with a numeric password is not created
        """
        data = self.user_data
        data["password"] = '12345678'
        data["password2"] = '12345678'
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('password', [field_body["name"]
                      for field_body in response.data["fields"]])

    def test_same_email_username(self):
        """
        Checks that an user with same email and username is not created
        """
        data = self.user_data
        data["username"] = self.user_data['email']
        response = test_utils.post(self.client, self.user_post_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(SAME_USERNAME_EMAIL_ERROR, response.data["error_code"])
