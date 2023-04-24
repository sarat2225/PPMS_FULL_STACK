from rest_framework import generics, pagination
from django.db.models.functions import ExtractYear
from .models import Student, StudentPersonalDetails
from .serializers import StudentSerializer, StudentPersonalDetailsSerializer

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

class StudentDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    lookup_field = 'rollno'
    pagination_class = CustomPagination

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

class DetailedStudentsData(generics.ListCreateAPIView):
    serializer_class = StudentPersonalDetailsSerializer
    pagination_class = CustomPagination

    def get_queryset(self):
        queryset = StudentPersonalDetails.objects.all()

        #filter by rollno
        roll_no = self.request.query_params.get('rollno', None)
        if roll_no is not None:
            queryset = queryset.filter(rollno=roll_no)

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
