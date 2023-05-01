from django.db import models
from students.models import Student

class Professor(models.Model):
    id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    department = models.CharField(max_length=255)
    field = models.CharField(max_length=255)
    email = models.EmailField()
    qualification = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class DoctoralCommittee(models.Model):
    student = models.OneToOneField(Student, primary_key=True, on_delete=models.CASCADE)
    guide = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='guide')
    coguide = models.ForeignKey(Professor, on_delete=models.CASCADE, null=True, blank=True, related_name='co_guide')
    dc1 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc1')
    dc2 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc2')
    dc3 = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='dc3')

    def __str__(self):
        return f"{self.student.first_name} {self.student.last_name}'s doctoral committee"