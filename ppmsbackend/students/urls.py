from django.urls import path
from .views import *

urlpatterns = [
    path('<str:rollno>/', StudentDetail.as_view(), name='student-detail'),
    # path('student-personal-details',AllStudentPersonalDetails.as_view(),name='student-personal-details'),
    path('<str:rollno>/personal-details/',IndividualStudentPersonalDetails.as_view(),name='individual-student-personal-details'),
]