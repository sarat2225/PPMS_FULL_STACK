from django.test import TestCase,Client
from .models import CustomUser
from .serializers import CustomUserSerializer,LogSerializer
from django.db.utils import IntegrityError
from rest_framework.test import APITestCase,APIClient
from rest_framework import status
from django.urls import reverse
import json

# Testing CustomUser model and CustomUserSerializer
class CustomUserTest(TestCase):
    def setUp(self):
        self.serializer=CustomUserSerializer
        
    def test_user(self):
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        self.assertEqual(self.user.email,'test@iith.ac.in')
        self.assertTrue(self.user.check_password('testpassword'))
        self.assertEqual(self.user.role,'S')
    
    #Valueerror is raised when email is not given in the data
    def test_without_email(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'password':'testpassword','role':'S'})
    
    #Valueerror is raised when password is not given in the data
    def test_without_password(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','role':'S'})

    #Valueerror is raised when role is not given in the data
    def test_without_role(self):
        with self.assertRaises(ValueError):
            self.user=self.serializer.create(self.serializer,{'password':'testpassword','email':'test@iith.ac.in'})

    #Integrityerror is raised when email has been already used 
    def test_duplicate_email(self):
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        with self.assertRaises(IntegrityError):
            self.user2=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})

# Testing RegisterView
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

    # User cannot be created using existing email.
    def test_create_user_with_existing_email(self):
        #user = CustomUser.objects.create_user(email='testuser@test.com', password='testpass', role='S')
        self.user=self.serializer.create(self.serializer,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        
        url = reverse('users:register')
        data = {'email': 'test@iith.ac.in', 'password': 'testpassword', 'role': 'S'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(CustomUser.objects.count(), 1)

    # Role should be valied.
    def test_create_user_with_invalid_role(self):
        url = reverse('users:register')
        data = {'email': 'test@iith.ac.in', 'password': 'testpassword', 'role': 'X'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(CustomUser.objects.count(), 0)

client=Client()

class LoginViewTestCase(TestCase):
    def setUp(self):
        self.serializerlogin=LogSerializer
        self.user=self.serializerlogin.create(self.serializerlogin,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        
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
            reverse('users:login'),
            data=json.dumps(self.valid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_login_user_with_invalid_credentials(self):
        response = client.post(
            reverse('users:login'),
            data=json.dumps(self.invalid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class LogoutViewTestCase(TestCase):
    def setUp(self):
        self.serializerlogout=LogSerializer
        self.user=self.serializerlogout.create(self.serializerlogout,{'email':'test@iith.ac.in','password':'testpassword','role':'S'})
        

    def test_logout_user(self):
        client=APIClient()
        client.force_authenticate(user=self.user)
        response = client.post(reverse('users:logout'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)