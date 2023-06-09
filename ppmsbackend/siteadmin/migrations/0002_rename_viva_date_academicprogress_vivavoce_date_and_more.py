# Generated by Django 4.2 on 2023-04-27 19:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('siteadmin', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='academicprogress',
            old_name='viva_date',
            new_name='vivavoce_date',
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_CE_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_JSC_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_OC_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_RPS_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_VivaVoce_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc1_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc2_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc3_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc4_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc5_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc6_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
        migrations.AddField(
            model_name='academicprogress',
            name='is_dc7_done',
            field=models.CharField(choices=[('Y', 'Yes'), ('N', 'No')], default='N', max_length=1),
        ),
    ]
