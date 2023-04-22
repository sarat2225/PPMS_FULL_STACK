from django.db import models
from django.utils.timezone import now

class Student(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
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
    joining_date = models.DateField(default=now,blank=True)
    PHD_STATUS_CHOICES = [
        ('A', 'Admitted'),
        ('C', 'Coursework Completed'),
        ('P', 'Proposal Submitted'),
        ('T', 'Thesis Submitted'),
        ('D', 'Degree Awarded'),
        ('W', 'Withdrawn')
    ]
    phd_status = models.CharField(
        max_length=1,
        choices=PHD_STATUS_CHOICES,
        default='A'
    )

class StudentPersonalDetails(models.Model):
    student = models.OneToOneField(Student, on_delete=models.CASCADE, related_name='personal_details')
    joining_batch = models.CharField(max_length=10)
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
    date_of_birth = models.DateField()
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
    state = models.CharField(max_length=100)
    personal_email = models.EmailField()
    contact_number = models.CharField(max_length=15)