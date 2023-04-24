from django.contrib import admin
from .models import Student, StudentPersonalDetails

admin.site.register(Student)
admin.site.register(StudentPersonalDetails)