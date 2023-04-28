from django.urls import path
from .views import *  

urlpatterns = [
    # Define the URL pattern for the professor students view
    path('<str:email>/',ProfessorDetail.as_view(), name='professor-details'),
    path('<str:email>/students-as-guide/', ProfessorStudentGuideListView.as_view(), name='professor-student-guide-list'),
    path('<str:email>/students-as-dc/', ProfessorStudentDCListView.as_view(), name='professor-student-dc-list'),
]