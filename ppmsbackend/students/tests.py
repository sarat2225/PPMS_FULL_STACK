from django.test import TestCase
from datetime import date
from .models import Student, StudentPersonalDetails

class StudentModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        Student.objects.create(
            first_name='Arjun',
            last_name='Allu',
            email='arjun.allu@iith.ac.in',
            rollno='cs23resch12345',
            department='Computer Science',
            admission_mode='R',
            joining_date=date.today(),
            phd_status='A',
            is_pmrf='N'
        )
    
    def test_student_creation(self):
        self.assertEqual(Student.objects.count(), 1)
        self.assertEqual(Student.objects.first().first_name, 'Arjun')
        self.assertEqual(Student.objects.first().last_name, 'Allu')

    def test_first_name_label(self):
        student = Student.objects.get(id=1)
        field_label = student._meta.get_field('first_name').verbose_name
        self.assertEquals(field_label, 'first name')

    def test_rollno_max_length(self):
        student = Student.objects.get(id=1)
        max_length = student._meta.get_field('rollno').max_length
        self.assertEquals(max_length, 15)

    # Can Add more test cases for other fields as per requirement

class StudentPersonalDetailsModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.student = Student.objects.create(
            first_name='Arjun',
            last_name='Allu',
            email='arjun.allu@iith.ac.in',
            rollno='cs23resch12345',
            department='Computer Science',
            admission_mode='R',
            joining_date=date.today(),
            phd_status='A',
            is_pmrf='N'
        )
        StudentPersonalDetails.objects.create(
            student=cls.student,
            joining_batch='2023_May',
            gender='M',
            date_of_birth=date(1997, 1, 1),
            category='GE',
            pwd_status='N',
            state='Andhra Pradesh',
            contact_number='9634937890'
        )
    
    def test_student_personal_details_creation(self):
        self.assertEqual(StudentPersonalDetails.objects.count(), 1)
        self.assertEqual(StudentPersonalDetails.objects.first().student, self.student)
        self.assertEqual(StudentPersonalDetails.objects.first().gender, 'M')

    def test_joining_batch_label(self):
        personal_details = StudentPersonalDetails.objects.get(id=1)
        field_label = personal_details._meta.get_field('joining_batch').verbose_name
        self.assertEquals(field_label, 'joining batch')

    def test_category_choices(self):
        personal_details = StudentPersonalDetails.objects.get(id=1)
        category = personal_details.category
        self.assertIn(category, [choice[0] for choice in personal_details.CATEGORY_CHOICES])

    # Can Add more test cases for other fields as per requirement
