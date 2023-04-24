from rest_framework import serializers
from .models import Professor, DoctoralCommittee 
from students.serializers import StudentSerializer 

class ProfessorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Professor
        fields = '__all__'

class DoctoralCommitteeSerializer(serializers.ModelSerializer):
    student = StudentSerializer(many=False)
    guide = ProfessorSerializer(many=False)
    co_guide = ProfessorSerializer(many=False)
    dc1 = ProfessorSerializer(many=False)
    dc2 = ProfessorSerializer(many=False)
    dc3 = ProfessorSerializer(many=False)
    
    class Meta:
        model = DoctoralCommittee
        fields = '__all__'

