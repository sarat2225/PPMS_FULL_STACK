from django.urls import path
from .views import *

urlpatterns = [
    path('all-student-list/', AllStudentList.as_view(), name='student-list'),
     path('all-student-academic-data/', DetailedAllStudentsAcademicData.as_view(), name='academic-data'),
    path('all-student-detailed-data/', DetailedAllStudentsData.as_view(), name='detailed-data'),
    path('all-professors-list',AllProfessorList.as_view(), name='professor-list'),
    path('dc-list/', AllDCList.as_view(), name='student-dc-list'),
    path('dashboard/', Dashboard.as_view(), name='dashboard'),
    path('<str:rollno>/progress/',AcademicProgressByStudent.as_view(), name='academic-progress')

]