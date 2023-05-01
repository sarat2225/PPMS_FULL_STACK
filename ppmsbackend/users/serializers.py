from rest_framework import serializers
from .models import CustomUser

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['email', 'password', 'role']
        extra_kwargs = {
            'password': {'write_only': True},
        }

    def create(self, validated_data):
        if 'email' not in validated_data:
            raise ValueError("Email attribute must be filled")
        if 'password' not in validated_data:
            raise ValueError("Password attribute must be filled")
        if 'role' not in validated_data:
            raise ValueError("Role attribute must be filled")
        user = CustomUser.objects.create_user(
            email=validated_data['email'],
            username=validated_data['email'],
            password=validated_data['password'],
            role=validated_data['role'],
        )
        return user

class LogSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['email', 'password']
        extra_kwargs = {
            'password': {'write_only': True},
        }

    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            email=validated_data['email'],
            username=validated_data['email'],
            password=validated_data['password'],
            #role=validated_data['role'],
        )
        return user
