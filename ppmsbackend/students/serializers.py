from rest_framework import serializers
from .models import Student, StudentPersonalDetails 

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'

class StudentPersonalDetailsSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False)
    class Meta:
        model = StudentPersonalDetails
        fields = '__all__'

