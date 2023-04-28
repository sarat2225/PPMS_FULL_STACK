from django.db import models
from students.models import Student

class AcademicProgress(models.Model):
    student = models.OneToOneField(Student, primary_key=True, on_delete=models.CASCADE)
    BOOL_CHOICES = [
        ('Y', 'Yes'),
        ('N', 'No')
    ]
    CE = models.DateField(null=True, blank=True)
    is_CE_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    RPS = models.DateField(null=True, blank=True)
    is_RPS_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    JRF_SRF_CONVERSION = models.DateField(null=True, blank=True)
    is_JSC_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    OC = models.DateField(null=True, blank=True)
    is_OC_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    thesis_submission_date = models.DateField(null=True, blank=True)
    vivavoce_date = models.DateField(null=True, blank=True)
    is_VivaVoce_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet1 = models.DateField(null=True, blank=True)
    is_dc1_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet2 = models.DateField(null=True, blank=True)
    is_dc2_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet3 = models.DateField(null=True, blank=True)
    is_dc3_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet4 = models.DateField(null=True, blank=True)
    is_dc4_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet5 = models.DateField(null=True, blank=True)
    is_dc5_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet6 = models.DateField(null=True, blank=True)
    is_dc6_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    dc_meet7 = models.DateField(null=True, blank=True)
    is_dc7_done = models.CharField(
        max_length=1,
        choices=BOOL_CHOICES,
        default='N'
    )
    withdraw_date = models.DateField(null=True, blank=True)
    withdraw_reason = models.CharField(max_length=255, null=True, blank=True)
    degree_awarded = models.CharField(max_length=255)
    convocation_date = models.DateField(null=True, blank=True)
    convocation_batch = models.CharField(max_length=255, null=True, blank=True)