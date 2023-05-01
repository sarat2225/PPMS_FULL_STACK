from django.test import TestCase
from datetime import date
from students.models import Student
from professors.models import Professor, DoctoralCommittee

class ProfessorModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.professor = Professor.objects.create(
            first_name='Anushka',
            last_name='Shetty',
            department='Computer Science',
            field='Artificial Intelligence',
            email='anushka.shetty@iith.ac.in',
            qualification='PhD'
        )

    def test_professor_str(self):
        professor = Professor.objects.create(first_name='Anushka', last_name='Shetty', department='Computer Science', field='Artificial Intelligence', email='anushka.shetty@iith.ac.in', qualification='PhD')
        self.assertEqual(str(professor), 'Anushka Shetty')

    def test_professor_has_dc(self):
        student = Student.objects.create(
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
        dc = DoctoralCommittee.objects.create(
            student=student,
            guide=self.professor,
            dc1=self.professor,
            dc2=self.professor,
            dc3=self.professor
        )
        self.assertTrue(self.professor.guide.exists())

class DoctoralCommitteeModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.professor = Professor.objects.create(
            first_name='Anushka',
            last_name='Shetty',
            department='Computer Science',
            field='Artificial Intelligence',
            email='anushka.shetty@iith.ac.in',
            qualification='PhD'
        )
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
        cls.dc = DoctoralCommittee.objects.create(
            student=cls.student,
            guide=cls.professor,
            dc1=cls.professor,
            dc2=cls.professor,
            dc3=cls.professor
        )

    def test_dc_str(self):
        expected = f"{self.student.first_name} {self.student.last_name}'s doctoral committee"
        self.assertEqual(str(self.dc), expected)

    def test_dc_has_student(self):
        self.assertEqual(self.dc.student, self.student)

    def test_dc_has_guide(self):
        self.assertEqual(self.dc.guide, self.professor)

    def test_dc_has_coguide(self):
        self.assertIsNone(self.dc.coguide)

    def test_dc_has_dc1(self):
        self.assertEqual(self.dc.dc1, self.professor)

    def test_dc_has_dc2(self):
        self.assertEqual(self.dc.dc2, self.professor)

    def test_dc_has_dc3(self):
        self.assertEqual(self.dc.dc3, self.professor)