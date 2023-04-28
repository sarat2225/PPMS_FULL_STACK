from django.urls import path
from .views import *

urlpatterns = [
    path('all-student-list/', AllStudentList.as_view(), name='student-list'),
    path('all-student-detailed-data/', DetailedStudentsData.as_view(), name='detailed-data'),
    path('all-professors-list',AllProfessorList.as_view(), name='professor-list'),
    path('dc-list/', AllDCList.as_view(), name='student-dc-list'),
    path('dashboard/', Dashboard.as_view(), name='dashboard'),
]