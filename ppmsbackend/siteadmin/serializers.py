from rest_framework import serializers
from .models import AcademicProgress
from students.models import *
from students.serializers import *
from professors.serializers import *

class AcademicProgressSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False)
    class Meta:
        model = AcademicProgress
        fields = '__all__'