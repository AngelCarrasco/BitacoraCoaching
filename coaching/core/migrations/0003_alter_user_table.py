# Generated by Django 3.2.8 on 2021-11-29 20:53

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0002_alter_user_options'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='user',
            table='CORE_USER',
        ),
    ]