# Generated by Django 4.2 on 2023-04-28 09:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('siteadmin', '0002_rename_viva_date_academicprogress_vivavoce_date_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='academicprogress',
            name='convocation_date',
            field=models.DateField(blank=True, null=True),
        ),
    ]
