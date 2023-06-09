# Generated by Django 4.2 on 2023-04-29 14:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('siteadmin', '0003_academicprogress_convocation_date'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_CE_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_JSC_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_OC_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_RPS_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_VivaVoce_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc1_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc2_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc3_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc4_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc5_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc6_done',
        ),
        migrations.RemoveField(
            model_name='academicprogress',
            name='is_dc7_done',
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='notes',
            field=models.TextField(blank=True, null=True),
        ),
    ]
