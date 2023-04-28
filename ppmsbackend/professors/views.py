from rest_framework import generics, pagination
from django.db.models import Q
from .models import Professor, DoctoralCommittee
from .serializers import ProfessorSerializer, DoctoralCommitteeSerializer
from students.models import Student
from students.serializers import StudentSerializer

class CustomPagination(pagination.PageNumberPagination):
    page_size = 10  # Number of items to display per page
    page_size_query_param = 'page_size'
    max_page_size = 100

class ProfessorDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Professor.objects.all()
    serializer_class = ProfessorSerializer
    lookup_field = 'email'
    pagination_class = CustomPagination

class ProfessorStudentGuideListView(generics.ListAPIView):
    serializer_class = StudentSerializer

    def get_queryset(self):
        # Retrieve the professor object based on the email
        professor = Professor.objects.get(email=self.kwargs['email'])

        # Retrieve the list of students under the professor's guidance
        students = Student.objects.filter(Q(doctoralcommittee__guide=professor) | Q(doctoralcommittee__coguide=professor))

        return students
    
class ProfessorStudentDCListView(generics.ListAPIView):
    serializer_class = StudentSerializer

    def get_queryset(self):
        # Retrieve the professor object based on the email
        professor = Professor.objects.get(email=self.kwargs['email'])

        # Retrieve the list of students under the professor's guidance
        students = Student.objects.filter(Q(doctoralcommittee__dc1=professor) | Q(doctoralcommittee__dc2=professor) | Q(doctoralcommittee__dc3=professor))

        return students