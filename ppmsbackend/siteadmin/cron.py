from django.utils import timezone
from datetime import timedelta
from django.core.mail import send_mail
from django.db.models import Q
from .models import AcademicProgress

def daily_job():
    now = timezone.now()
    one_month_from_now = now + timedelta(days=30)

    fields = []

    events = AcademicProgress.objects.filter(
        # Filter all events whose date is exactly 1 month from now
        Q(CE__date=one_month_from_now) | 
        Q(RPS__date=one_month_from_now) | 
        Q(JRF_SRF_CONVERSION__date=one_month_from_now) | 
        Q(OC__date=one_month_from_now) | 
        Q(thesis_submission_date__date=one_month_from_now) | 
        Q(viva_date__date=one_month_from_now) | 
        Q(dc_meet1__date=one_month_from_now) | 
        Q(dc_meet2__date=one_month_from_now) | 
        Q(dc_meet3__date=one_month_from_now) | 
        Q(dc_meet4__date=one_month_from_now) | 
        Q(dc_meet5__date=one_month_from_now) | 
        Q(dc_meet6__date=one_month_from_now) | 
        Q(dc_meet7__date=one_month_from_now)
    )

    for event in events:

        if event.CE == one_month_from_now:
            fields.append(('Comprehensive Exam', event.CE))
        if event.RPS == one_month_from_now:
            fields.append(('Research Proposal Seminar', event.RPS))
        if event.JRF_SRF_CONVERSION == one_month_from_now:
            fields.append(('JRF to SRF CONVERSION', event.JRF_SRF_CONVERSION))
        if event.OC == one_month_from_now:
            fields.append(('Open Colloquium', event.OC))
        if event.thesis_submission_date == one_month_from_now:
            fields.append(('Thesis Submission', event.thesis_submission_date))
        if event.viva_date == one_month_from_now:
            fields.append(('Viva', event.viva_date))
        if event.dc_meet1 == one_month_from_now:
            fields.append(('DC meet 1', event.dc_meet1))
        if event.dc_meet2 == one_month_from_now:
            fields.append(('DC meet 2', event.dc_meet2))
        if event.dc_meet3 == one_month_from_now:
            fields.append(('DC meet 3', event.dc_meet3))
        if event.dc_meet4 == one_month_from_now:
            fields.append(('DC meet 4', event.dc_meet4))
        if event.dc_meet5 == one_month_from_now:
            fields.append(('DC meet 5', event.dc_meet5))
        if event.dc_meet6 == one_month_from_now:
            fields.append(('DC meet 6', event.dc_meet6))
        if event.dc_meet7 == one_month_from_now:
            fields.append(('DC meet 7', event.dc_meet7))
        
        upcoming_events = ', '.join(fields)

        student_email = event.student.email
        subject = 'Reminder: Upcoming Academic Event'
        message = f'Hello {event.student.name},\n\nThis is a reminder that you have upcoming {upcoming_events} event scheduled on {one_month_from_now.strftime("%B %d, %Y")}. Please make sure to prepare accordingly.\n\nThank you,\nThe Academic Progress Management System'
        recipient_list = [student_email]
        send_mail(subject, message, recipient_list)