from rest_framework import serializers
from .models import AcademicProgress
from students.serializers import StudentSerializer 

class AcademicProgressSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False)
    class Meta:
        model = AcademicProgress
        fields = '__all__'