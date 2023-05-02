from django.db import models
from django.utils.timezone import now

class Student(models.Model):
    id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField()
    rollno = models.CharField(max_length=15)
    department = models.CharField(max_length=255)
    ADMISSION_MODE_CHOICES = [
        ('R', 'Regular'),
        ('E', 'External')
    ]
    admission_mode = models.CharField(
        max_length=1,
        choices=ADMISSION_MODE_CHOICES,
        default='R'
    )
    joining_date = models.DateField()
    PHD_STATUS_CHOICES = [
        ('A', 'Admitted'),
        ('B', 'Coursework Completed'),
        ('C', 'CE Completed'),
        ('D', 'Proposal Submitted'),
        ('E', 'JRF-SRF'),
        ('F', 'OC Completed'),
        ('G','VivaVoce Completed'),
        ('H', 'Degree Awarded'),
        ('W', 'Withdrawn')
    ]
    phd_status = models.CharField(
        max_length=1,
        choices=PHD_STATUS_CHOICES,
        default='A'
    )
    PMRF_CHOICES = [
        ('Y','Yes'),
        ('N','No')
    ]
    is_pmrf = models.CharField(
        max_length=1,
        choices=PMRF_CHOICES,
        default='N'
    )

class StudentPersonalDetails(models.Model):
    student = models.OneToOneField(Student, on_delete=models.CASCADE, related_name='personal_details')
    joining_batch = models.CharField(max_length=10,blank=True,null=True)
    GENDER_CHOICES = [
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other')
    ]
    gender = models.CharField(
        max_length=1,
        choices=GENDER_CHOICES,
        default='M'
    )
    date_of_birth = models.DateField(blank=True,null=True)
    CATEGORY_CHOICES = [
        ('GE', 'General'),
        ('OBC', 'OBC'),
        ('SC', 'SC'),
        ('ST', 'ST'),
        ('EWS', 'EWS')
    ]
    category = models.CharField(
        max_length=3,
        choices=CATEGORY_CHOICES,
        default='GE'
    )
    PWD_CHOICES = [
        ('Y', 'Yes'),
        ('N', 'No')
    ]
    pwd_status = models.CharField(
        max_length=1,
        choices=PWD_CHOICES,
        default='N'
    )
    state = models.CharField(max_length=100,blank=True,null=True)
    # personal_email = models.EmailField(null=True)
    contact_number = models.CharField(max_length=15,blank=True,null=True)