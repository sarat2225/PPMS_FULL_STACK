from django.db import models

class Email(models.Model):
    to = models.EmailField()
    subject = models.CharField(max_length=255)
    message = models.TextField()
