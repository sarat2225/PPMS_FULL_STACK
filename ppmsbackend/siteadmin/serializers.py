from rest_framework import serializers
from .models import AcademicProgress
from students.models import *
from students.serializers import *
from professors.serializers import *

class AcademicProgressSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False,read_only=True)
    class Meta:
        model = AcademicProgress
        fields = '__all__'

class StudentLoginAcademicDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = AcademicProgress
        fields = '__all__'