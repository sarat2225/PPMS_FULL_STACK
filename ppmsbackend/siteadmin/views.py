from rest_framework import generics, pagination
from rest_framework.response import Response
from django.db.models.functions import ExtractYear
from django.http import JsonResponse
from .models import AcademicProgress
from .serializers import *
from students.models import *
from students.serializers import *
from professors.models import *
from professors.serializers import *
from django.db.models import Count, Case, When
from django.http import JsonResponse

class CustomPagination(pagination.PageNumberPagination):
    page_size = 10  # Number of items to display per page
    page_size_query_param = 'page_size'
    max_page_size = 100

class AllStudentList(generics.ListCreateAPIView):
    serializer_class = StudentSerializer
    pagination_class = CustomPagination

    def get_queryset(self):

        queryset = Student.objects.all()
        
        # Get the ordering parameters from the request URL
        ordering = self.request.query_params.get('ord', 'joining_date')
        ordering_dir = self.request.query_params.get('ord_dir', 'asc')

        if ordering_dir == 'asc':
            ordering_dir = ''
        else:
            ordering_dir = '-'

        # Order the queryset based on the ordering parameters
        queryset = queryset.order_by(f'{ordering_dir}{ordering}')

        #filter by rollno
        roll_no = self.request.query_params.get('rollno', None)
        if roll_no is not None:
            queryset = queryset.filter(rollno=roll_no)
        
        # filter by admission mode
        admission_mode = self.request.query_params.get('admission_mode', None)
        if admission_mode is not None:
            queryset = queryset.filter(admission_mode=admission_mode)

        # filter by phd status
        phd_status = self.request.query_params.get('phd_status', None)
        if phd_status is not None:
            queryset = queryset.filter(phd_status=phd_status)
        
        # filter by date of joining
        year_of_joining = self.request.query_params.get('year_of_joining', None)
        if year_of_joining is not None:
            queryset = queryset.annotate(year=ExtractYear('joining_date')).filter(year=year_of_joining)

        return queryset

class DetailedAllStudentsData(generics.ListCreateAPIView):
    serializer_class = StudentPersonalDetailsSerializer
    # pagination_class = CustomPagination

    def get_queryset(self):
        queryset = StudentPersonalDetails.objects.all()

        #filter by rollno
        roll_no = self.request.query_params.get('rollno', None)
        if roll_no is not None:
            queryset = queryset.filter(student__rollno=roll_no)

        # filter by admission mode
        admission_mode = self.request.query_params.get('admission_mode', None)
        if admission_mode is not None:
            queryset = queryset.filter(student__admission_mode=admission_mode)

        # filter by phd status
        phd_status = self.request.query_params.get('phd_status', None)
        if phd_status is not None:
            queryset = queryset.filter(student__phd_status=phd_status)
        
        # filter by date of joining
        year_of_joining = self.request.query_params.get('year_of_joining', None)
        if year_of_joining is not None:
            queryset = queryset.annotate(year=ExtractYear('student__joining_date')).filter(year=year_of_joining)

        #filter by gender
        gender = self.request.query_params.get('gender', None)
        if gender is not None:
            queryset = queryset.filter(gender=gender)

        # filter by category
        category = self.request.query_params.get('category', None)
        if category is not None:
            queryset = queryset.filter(category=category)

        # filter by pwd
        pwd_status = self.request.query_params.get('pwd_status', None)
        if pwd_status is not None:
            queryset = queryset.filter(pwd_status=pwd_status)

        return queryset

class AcademicProgressByStudent(generics.RetrieveUpdateDestroyAPIView):
    queryset = AcademicProgress.objects.all()
    serializer_class = AcademicProgressSerializer
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


class AllProfessorList(generics.ListCreateAPIView):
    queryset = Professor.objects.all()
    serializer_class = ProfessorSerializer

class AllDCList(generics.ListCreateAPIView):
    queryset = DoctoralCommittee.objects.all()
    serializer_class = DoctoralCommitteeSerializer
    pagination_class = CustomPagination    

class Dashboard(generics.ListCreateAPIView):
    
    def get(self, request, *args, **kwargs):
        # Get the count of students who passed out
        num_students_passed_out = Student.objects.filter(phd_status='H').count()

        # Get the count of students with PMRF_CHOICES=YES
        num_students_with_pmrf = Student.objects.filter(is_pmrf='Y').count()

        A_B = Student.objects.filter(phd_status='A').count()
        B_C = Student.objects.filter(phd_status='B').count()
        C_D = Student.objects.filter(phd_status='C').count()
        D_E = Student.objects.filter(phd_status='D').count()
        E_F = Student.objects.filter(phd_status='E').count()
        F_G = Student.objects.filter(phd_status='G').count()
        G_H = Student.objects.filter(phd_status='H').count()
        Active_Students = A_B + B_C + C_D + D_E + E_F + F_G + G_H

        students_joining_by_year = Student.objects.annotate(year=ExtractYear('joining_date')).values('year').annotate(count=models.Count('id')).order_by('year')
        students_passed_out_by_year = AcademicProgress.objects.annotate(year=ExtractYear('convocation_date')).values('year').annotate(count=models.Count('student__id')).order_by('year')
        summary_data = {
            'num_students_passed_out': num_students_passed_out,
            'num_students_with_pmrf': num_students_with_pmrf,
            'admitted': A_B,
            'coursework_completed': B_C,
            'CE_completed': C_D,
            'RPS_completed': D_E,
            'JRF_SRF': E_F,
            'OC_completed': F_G,
            'VivaVoce_completed': G_H,
            'TotalActiveStudents': Active_Students,
            'YearlyJoiningStudentCount': list(students_joining_by_year),
            'YearlyPassedOutStudentCount': list(students_passed_out_by_year),
        }
        
        return JsonResponse(summary_data)