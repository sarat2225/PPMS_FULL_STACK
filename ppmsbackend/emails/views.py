from django.core.mail import send_mail
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Email
from rest_framework import status
from .serializers import EmailSerializer

class EmailView(APIView):
    def post(self, request, format=None):
        serializer = EmailSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.save()
            send_mail(email.subject, email.message, 'your_email_address@gmail.com', [email.to])
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
