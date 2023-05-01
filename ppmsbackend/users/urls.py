from django.urls import path
from .views import *
# RegisterView, AdminRegisterView, LoginView, LogoutView

app_name='users'

urlpatterns = [
    #path('adminregister/', AdminRegisterView.as_view(), name='adminregister'),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
]