from django.test import TestCase
from datetime import date
from students.models import Student
from .models import AcademicProgress

class AcademicProgressTestCase(TestCase):
    def setUp(self):
        # Create a Student object to associate with AcademicProgress
        self.student = Student.objects.create(
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

        # Create an AcademicProgress object for the Student
        self.academic_progress = AcademicProgress.objects.create(
            student=self.student,
            CE='2023-05-01',
            RPS='2023-05-01',
            degree_awarded='Masters'
        )

    def test_academic_progress_str(self):
        # Test that the __str__ method of AcademicProgress returns a string
        self.assertIsInstance(str(self.academic_progress), str)

    def test_academic_progress_has_student(self):
        # Test that the AcademicProgress object has a Student object associated with it
        self.assertEqual(self.academic_progress.student, self.student)

    def test_academic_progress_has_ce(self):
        # Test that the AcademicProgress object has a CE date
        self.assertEqual(str(self.academic_progress.CE), '2023-05-01')

    def test_academic_progress_has_rps(self):
        # Test that the AcademicProgress object has an RPS date
        self.assertEqual(str(self.academic_progress.RPS), '2023-05-01')

    def test_academic_progress_has_degree_awarded(self):
        # Test that the AcademicProgress object has a degree awarded
        self.assertEqual(self.academic_progress.degree_awarded, 'Masters')