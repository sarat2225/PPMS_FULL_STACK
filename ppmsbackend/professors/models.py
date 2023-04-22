from django.db import models
from students.models import Student

class Professor(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    department = models.CharField(max_length=255)
    field = models.CharField(max_length=255)
    email = models.EmailField()
    qualification = models.CharField(max_length=255)

class DoctoralCommittee(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    guide = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='guide')
    co_guide = models.ForeignKey(Professor, on_delete=models.CASCADE, null=True, blank=True, related_name='co_guide')
    dc1 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc1')
    dc2 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc2')
    dc3 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc3')