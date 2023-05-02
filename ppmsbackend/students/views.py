from rest_framework import generics, pagination, status
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import *
from .serializers import *
from professors.models import *
from professors.serializers import *

class CustomPagination(pagination.PageNumberPagination):
    page_size = 10  # Number of items to display per page
    page_size_query_param = 'page_size'
    max_page_size = 100

class AllStudents(generics.ListCreateAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class StudentDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    lookup_field = 'rollno'

class AllStudentPersonalDetails(generics.ListCreateAPIView):
    queryset = StudentPersonalDetails.objects.all()
    serializer_class = StudentPersonalDetailsSerializer

class StudentDcView(APIView):
    def get(self, request, rollno):
        student = get_object_or_404(Student, rollno=rollno)

        student_serializer = StudentSerializer(student)
        student_personal_details_serializer = StudentPersonalDetailsSerializer(student.personal_details)

        dc = DoctoralCommittee.objects.get(student=student)

        guide_serializer = ProfessorNameSerializer(dc.guide)
        coguide_serializer = ProfessorNameSerializer(dc.coguide) if dc.coguide else None
        dc1_serializer = ProfessorNameSerializer(dc.dc1)
        dc2_serializer = ProfessorNameSerializer(dc.dc2)
        dc3_serializer = ProfessorNameSerializer(dc.dc3)

        data = {
            'guide': guide_serializer.data,
            'coguide': coguide_serializer.data if coguide_serializer else None,
            'dc1': dc1_serializer.data,
            'dc2': dc2_serializer.data,
            'dc3': dc3_serializer.data,
        }
        return Response(data)

class IndividualStudentPersonalDetails(generics.RetrieveUpdateDestroyAPIView):
    queryset = StudentPersonalDetails.objects.all()
    serializer_class = StudentPersonalDetailsSerializer
    lookup_field = 'student__rollno'
    
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        obj = queryset.get(student__rollno=self.kwargs['rollno'])
        self.check_object_permissions(self.request, obj)
        return obj
        
    def put(self, request):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)