from django.test import TestCase
from .models import CustomUser
from .serializers import CustomUserSerializer
from django.db.utils import IntegrityError
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

class CustomUserTest(TestCase):
    def setUp(self):
        self.serializer=CustomUserSerializer
        
    def test_user(self):
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        self.assertEqual(self.user.email,'test@iith.ac.in')
        self.assertTrue(self.user.check_password('testpassword'))
        self.assertEqual(self.user.role,'S')

    def test_without_email(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'password':'testpassword','role':'S'})

    def test_without_password(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','role':'S'})

    def test_without_role(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'password':'testpassword','email':'test@iith.ac.in'})

    def test_duplicate_email(self):
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        with self.assertRaises(IntegrityError):
            self.user2=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})

class RegisterViewTestCase(APITestCase):
    def setUp(self):
        self.serializer=CustomUserSerializer
        
    def test_create_user(self):
        url = reverse('users:register')
        data = {'email': 'test@iith.ac.in', 'password': 'testpassword', 'role': 'S'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(CustomUser.objects.count(), 1)
        self.assertEqual(CustomUser.objects.get().email, 'test@iith.ac.in')

    def test_create_user_with_existing_email(self):
        #user = CustomUser.objects.create_user(email='testuser@test.com', password='testpass', role='S')
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        
        url = reverse('users:register')
        data = {'email': 'test@iith.ac.in', 'password': 'testpassword', 'role': 'S'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(CustomUser.objects.count(), 1)

    def test_create_user_with_invalid_role(self):
        url = reverse('users:register')
        data = {'email': 'test@iith.ac.in', 'password': 'testpassword', 'role': 'X'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(CustomUser.objects.count(), 0)

class LoginViewTestCase(TestCase):
    def setUp(self):
        self.user = CustomUser.objects.create_user(
            email='test@iith.ac.in',
            password='testpassword',
            role='P'
        )
        self.valid_payload = {
            'email': 'test@iith.ac.in',
            'password': 'testpassword',
        }
        self.invalid_payload = {
            'email': 'test@iith.ac.in',
            'password': 'invalidpassword',
        }

    def test_login_user_with_valid_credentials(self):
        response = client.post(
            reverse('login'),
            data=json.dumps(self.valid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_login_user_with_invalid_credentials(self):
        response = client.post(
            reverse('login'),
            data=json.dumps(self.invalid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class LogoutViewTestCase(TestCase):
    def setUp(self):
        self.user = CustomUser.objects.create_user(
            email='test@iith.ac.in',
            password='testpassword',
            role='P'
        )

    def test_logout_user(self):
        client.login(email='test@iith.ac.in', password='testpassword')
        response = client.post(reverse('logout'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)