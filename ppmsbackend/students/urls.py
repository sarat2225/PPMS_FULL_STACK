from django.urls import path
from .views import *

urlpatterns = [
    path('',AllStudents.as_view(),name='Students'),
    path('<str:rollno>/', StudentDetail.as_view(), name='student-detail'),
    path('<str:rollno>/personal-details/',IndividualStudentPersonalDetails.as_view(),name='individual-student-personal-details'),
    path('<str:rollno>/StudentDC-details/',StudentDcView.as_view(),name='StudentDcList'),
]