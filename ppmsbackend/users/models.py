from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=128)
    ROLE_CHOICES = [
        ('S', 'Student'),
        ('P', 'Professor'),
        ('A', 'Admin')
    ]
    role = models.CharField(
        max_length=1,
        choices=ROLE_CHOICES,
        default='S'
    )