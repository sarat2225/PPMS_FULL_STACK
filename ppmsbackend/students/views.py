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
    # pagination_class = CustomPagination

class AllStudentPersonalDetails(generics.ListCreateAPIView):
    queryset = StudentPersonalDetails.objects.all()
    serializer_class = StudentPersonalDetailsSerializer

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

# class StudentDetailView(APIView):
# class IndividualStudentPersonalDetails(APIView):
#     def get(self, request, rollno):
#         # Get the student object with the given rollno
#         student = get_object_or_404(Student, rollno=rollno)
#         # Serialize the student and student personal details objects
#         student_serializer = StudentSerializer(student)
#         student_personal_details_serializer = StudentPersonalDetailsSerializer(student.personal_details)
#         # Get the doctoral committee object associated with the student
#         dc = DoctoralCommittee.objects.get(student=student)
#         # Serialize the guide, co-guide, and committee members
#         guide_serializer = ProfessorNameSerializer(dc.guide)
#         coguide_serializer = ProfessorNameSerializer(dc.coguide) if dc.coguide else None
#         dc1_serializer = ProfessorNameSerializer(dc.dc1)
#         dc2_serializer = ProfessorNameSerializer(dc.dc2)
#         dc3_serializer = ProfessorNameSerializer(dc.dc3)
#         # Combine all the serialized data into a single dictionary
#         data = {
#             # **student_serializer.data,
#             **student_personal_details_serializer.data,
#             'guide': guide_serializer.data,
#             'coguide': coguide_serializer.data if coguide_serializer else None,
#             'dc1': dc1_serializer.data,
#             'dc2': dc2_serializer.data,
#             'dc3': dc3_serializer.data,
#         }
#         # Return the combined data as a JSON response
#         return Response(data)


# class IndividualStudentPersonalDetails(generics.ListCreateAPIView):
#     serializer_class = StudentPersonalDetailsSerializer

#     def get_queryset(self):
#         rollno = self.kwargs['rollno']
#         queryset = StudentPersonalDetails.objects.filter(student__rollno=rollno)
#         return queryset

#     def list(self, request, *args, **kwargs):
#         rollno = kwargs['rollno']
#         student = get_object_or_404(Student, rollno=rollno)
#         student_serializer = StudentSerializer(student)
#         queryset = self.get_queryset()
#         serializer = self.get_serializer(queryset, many=True)
#         dc = DoctoralCommittee.objects.get(student=student)
#         guide_serializer = ProfessorNameSerializer(dc.guide)
#         coguide_serializer = ProfessorNameSerializer(dc.coguide) if dc.coguide else None
#         dc1_serializer = ProfessorNameSerializer(dc.dc1)
#         dc2_serializer = ProfessorNameSerializer(dc.dc2)
#         dc3_serializer = ProfessorNameSerializer(dc.dc3)
#         data = {
#             # **student_serializer.data,
#             'personal_details': serializer.data,
#             'guide': guide_serializer.data,
#             'coguide': coguide_serializer.data if coguide_serializer else None,
#             'dc1': dc1_serializer.data,
#             'dc2': dc2_serializer.data,
#             'dc3': dc3_serializer.data,
#         }
#         return Response(data)

#     def create(self, request, *args, **kwargs):
#         # create the student personal details instance
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         personal_details = serializer.save()

#         # get the associated student instance
#         rollno = kwargs['rollno']
#         student = get_object_or_404(Student, rollno=rollno)

#         # create the associated doctoral committee instance
#         dc_data = {
#             'student': student,
#             'guide': request.data.get('guide'),
#             'coguide': request.data.get('coguide'),
#             'dc1': request.data.get('dc1'),
#             'dc2': request.data.get('dc2'),
#             'dc3': request.data.get('dc3')
#         }
#         dc_serializer = DoctoralCommitteeSerializer(data=dc_data)
#         dc_serializer.is_valid(raise_exception=True)
#         dc = dc_serializer.save()

#         # return the combined data as a response
#         student_serializer = StudentSerializer(student)
#         guide_serializer = ProfessorNameSerializer(dc.guide)
#         coguide_serializer = ProfessorNameSerializer(dc.coguide) if dc.coguide else None
#         dc1_serializer = ProfessorNameSerializer(dc.dc1)
#         dc2_serializer = ProfessorNameSerializer(dc.dc2)
#         dc3_serializer = ProfessorNameSerializer(dc.dc3)
#         data = {
#             **student_serializer.data,
#             'personal_details': serializer.data,
#             'guide': guide_serializer.data,
#             'coguide': coguide_serializer.data if coguide_serializer else None,
#             'dc1': dc1_serializer.data,
#             'dc2': dc2_serializer.data,
#             'dc3': dc3_serializer.data,
#         }
       
