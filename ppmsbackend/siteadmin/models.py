from django.db import models
from students.models import Student

class AcademicProgress(models.Model):
    student = models.OneToOneField(Student, primary_key=True, on_delete=models.CASCADE)
    CE = models.DateField(null=True, blank=True)
    RPS = models.DateField(null=True, blank=True)
    JRF_SRF_CONVERSION = models.DateField(null=True, blank=True)
    OC = models.DateField(null=True, blank=True)
    thesis_submission_date = models.DateField(null=True, blank=True)
    vivavoce_date = models.DateField(null=True, blank=True)
    dc_meet1 = models.DateField(null=True, blank=True)
    dc_meet2 = models.DateField(null=True, blank=True)
    dc_meet3 = models.DateField(null=True, blank=True)
    dc_meet4 = models.DateField(null=True, blank=True)
    dc_meet5 = models.DateField(null=True, blank=True)
    dc_meet6 = models.DateField(null=True, blank=True)
    dc_meet7 = models.DateField(null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    withdraw_date = models.DateField(null=True, blank=True)
    withdraw_reason = models.CharField(max_length=255, null=True, blank=True)
    degree_awarded = models.CharField(max_length=255,blank=True,null=True)
    convocation_date = models.DateField(null=True, blank=True)
    convocation_batch = models.CharField(max_length=255, null=True, blank=True)