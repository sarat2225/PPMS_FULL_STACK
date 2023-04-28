from rest_framework import serializers
from .models import Student, StudentPersonalDetails 

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'

class StudentNameSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()

    class Meta:
        model = Student
        fields = ['name','rollno']

    def get_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

class StudentPersonalDetailsSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False)
    class Meta:
        model = StudentPersonalDetails
        fields = '__all__'