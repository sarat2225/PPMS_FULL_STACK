from rest_framework import generics,status
from rest_framework import permissions
from rest_framework.response import Response
from django.contrib.auth import login, logout
from .models import CustomUser
from .serializers import CustomUserSerializer,LogSerializer,ChangePasswordSerializer
from django.shortcuts import get_object_or_404

class RegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data)

class LoginView(generics.GenericAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = LogSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        user = get_object_or_404(CustomUser, email=email)
        if user.check_password(password):
            login(request, user)
            return Response({'message': 'Logged in successfully','role': user.role})
        else:
            return Response({'error': 'Invalid email or password'},status=status.HTTP_400_BAD_REQUEST)

class LogoutView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = LogSerializer

    def post(self, request):
        logout(request)
        return Response({'message': 'Logged out successfully'},status=status.HTTP_200_OK)

class ChangePasswordView(generics.GenericAPIView):
    queryset=CustomUser.objects.all()
    serializer_class=ChangePasswordSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        useremail=request.data.get('email')
        present_user=CustomUser.objects.get(email=useremail)
        present_user.set_password((request.data.get('password')))
        present_user.save()
        return Response({'message':'Password updated successfully'})