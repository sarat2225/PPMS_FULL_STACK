from django.urls import path
from .views import *

urlpatterns = [
    path('', AllStudentList.as_view(), name='student-list'),
    path('<str:rollno>/', StudentDetail.as_view(), name='student-detail'),
    path('personal-details',AllStudentPersonalDetails.as_view(),name='student-personal-details'),
    path('<str:rollno>/personal-details/',IndividualStudentPersonalDetails.as_view(),name='individual-student-personal-details'),
    path('detailed-data',DetailedStudentsData.as_view(),name='detailed-data')
]
