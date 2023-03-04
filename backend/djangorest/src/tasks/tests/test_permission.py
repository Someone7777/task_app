from django.utils.timezone import now
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from authentication.models import User
import logging
from tasks.models import Task
import core.tests.utils as test_utils


class TaskPermissionsTests(APITestCase):
    def setUp(self):
        # Avoid WARNING logs while testing wrong requests
        logging.disable(logging.WARNING)

        self.task_url = reverse('task_list_create')
        
        # Test user data
        self.user_data1 = {
            'username': "username1",
            'full_name': "User Name",
            'email': "email1@test.com",
            "password": "password1@212",
            "password2": "password1@212",
        }
        self.user_data2 = {
            'username': "username2",
            'full_name': "User Name",
            'email': "email2@test.com",
            "password": "password1@212",
            "password2": "password1@212",
        }
        self.credentials1 = {
            'email': "email1@test.com",
            "password": "password1@212"
        }
        self.credentials2 = {
            'email': "email2@test.com",
            "password": "password1@212"
        }
        # User creation
        user1 = User.objects.create(
            username=self.user_data1["username"],
            full_name=self.user_data1["full_name"],
            email=self.user_data1["email"],
            verified=True,
        )
        user1.set_password(self.user_data1['password'])
        user1.save()
        user2 = User.objects.create(
            username=self.user_data2["username"],
            full_name=self.user_data2["full_name"],
            email=self.user_data2["email"],
            verified=True,
        )
        user2.set_password(self.user_data2['password'])
        user2.save()
        return super().setUp()

    def get_task_data(self):
        return {
            'title': 'Test name',
            'description': 'Test description',
            'finished': str(now().date()),
            'deadline': str(now().date()),
        }

    def test_task_post_url(self):
        """
        Checks permissions with Task post
        """
        data = self.get_task_data()
        # Try without authentication
        response = test_utils.post(self.client, self.task_url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        # Try with authentication
        test_utils.authenticate_user(self.client, self.credentials1)
        response = test_utils.post(self.client, self.task_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # Compare owner
        task = Task.objects.get(title="Test name")
        self.assertEqual(task.owner.email, self.user_data1['email'])

    def test_task_get_list_url(self):
        """
        Checks permissions with Task get and list
        """
        data = self.get_task_data()
        # Add new task as user1
        test_utils.authenticate_user(self.client, self.credentials1)
        test_utils.post(self.client, self.task_url, data)
        # Get task data as user1
        response = test_utils.get(self.client, self.task_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(dict(response.data)['count'], 1)
        # Get task data as user2
        test_utils.authenticate_user(self.client, self.credentials2)
        response = test_utils.get(self.client, self.task_url)
        # Gets an empty dict
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(dict(response.data)['count'], 0)
        # Try with an specific task
        task = Task.objects.get(title='Test name')
        response = test_utils.get(
            self.client, self.task_url+'/'+str(task.id))
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_task_put_url(self):
        """
        Checks permissions with Task patch (almost same as put)
        """
        data = self.get_task_data()
        # Add new task as user1
        test_utils.authenticate_user(self.client, self.credentials1)
        test_utils.post(self.client, self.task_url, data)
        task = Task.objects.get(title='Test name')
        # Try update as user1
        response = test_utils.patch(self.client, self.task_url+'/' +
                                    str(task.id), {'description': "Test 2"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Check task
        task = Task.objects.get(title='Test name')
        self.assertEqual(task.description, "Test 2")
        # Try update as user2
        test_utils.authenticate_user(self.client, self.credentials2)
        response = test_utils.patch(self.client, self.task_url+'/' +
                                    str(task.id), {'description': "Test 2"})
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_task_delete_url(self):
        """
        Checks permissions with Task delete
        """
        data = self.get_task_data()
        # Add new expense as user1
        test_utils.authenticate_user(self.client, self.credentials1)
        test_utils.post(self.client, self.task_url, data)
        # Delete task data as user2
        test_utils.authenticate_user(self.client, self.credentials2)
        task = Task.objects.get(title='Test name')
        response = test_utils.delete(
            self.client, self.task_url+'/'+str(task.id))
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        # Delete expense data as user1
        test_utils.authenticate_user(self.client, self.credentials1)
        response = test_utils.delete(
            self.client, self.task_url+'/'+str(task.id))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)