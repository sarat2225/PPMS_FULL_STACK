from rest_framework import serializers
from .models import *
from students.serializers import *

class ProfessorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Professor
        fields = '__all__'

class ProfessorNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Professor
        fields = ['first_name', 'last_name']

class DoctoralCommitteeSerializer(serializers.ModelSerializer):
    student = StudentNameSerializer(many=False)
    guide = ProfessorNameSerializer(many=False)
    coguide = ProfessorNameSerializer(many=False)
    dc1 = ProfessorNameSerializer(many=False)
    dc2 = ProfessorNameSerializer(many=False)
    dc3 = ProfessorNameSerializer(many=False)
    
    class Meta:
        model = DoctoralCommittee
        fields = '__all__'