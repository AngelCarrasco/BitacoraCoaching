# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Coach(models.Model):
    run_coach = models.CharField(primary_key=True, max_length=13)
    nombre = models.CharField(max_length=50)
    apellido_p = models.CharField(max_length=50)
    apellido_m = models.CharField(max_length=50)
    telefono = models.IntegerField()
    correo = models.CharField(max_length=50)
    contrasena = models.CharField(max_length=200)
    contrato = models.FloatField()

    class Meta:
        managed = False
        db_table = 'coach'


class Coachee(models.Model):
    run_coachee = models.CharField(primary_key=True, max_length=13)
    apellido_m = models.CharField(max_length=50)
    nombre = models.CharField(max_length=50)
    cargo = models.CharField(max_length=20)
    apellido_p = models.CharField(max_length=50)
    correo = models.CharField(max_length=50)
    contrasena = models.CharField(max_length=200)
    contrato = models.FloatField()
    rut_empresa = models.ForeignKey('Empresa', models.DO_NOTHING, db_column='rut_empresa')

    class Meta:
        managed = False
        db_table = 'coachee'


class Documentacion(models.Model):
    id_doc = models.FloatField(primary_key=True)
    archivo = models.TextField()
    fecha_subida = models.DateField()
    fecha_vista = models.DateField(blank=True, null=True)
    id_sesion = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='id_sesion', related_name="doc_id_sesion")

    class Meta:
        managed = False
        db_table = 'documentacion'


class Empresa(models.Model):
    rut_empresa = models.CharField(primary_key=True, max_length=13)
    direccion = models.CharField(max_length=30)
    telefono = models.IntegerField()
    nombre = models.CharField(max_length=30)
    correo = models.CharField(max_length=50)
    contrato = models.FloatField()
    nombre_jefe = models.CharField(max_length=50)
    correo_jefe = models.CharField(max_length=60)
    telefono_jefe = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'empresa'


class Encuesta(models.Model):
    id_pregunta = models.FloatField(primary_key=True)
    pregunta = models.CharField(max_length=20)
    nota = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'encuesta'


class Evaluacion(models.Model):
    id_encuesta = models.FloatField()
    fecha = models.DateField()
    comentario = models.CharField(max_length=100, blank=True, null=True)
    promedio = models.FloatField(blank=True, null=True)
    id_proceso = models.OneToOneField('Proceso', models.DO_NOTHING, db_column='id_proceso', primary_key=True, related_name="eva_proceso")
    run_coach = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='run_coach',  related_name="eva_coach")
    id_pregunta = models.ForeignKey(Encuesta, models.DO_NOTHING, db_column='id_pregunta', related_name="eva_encuesta")

    class Meta:
        managed = False
        db_table = 'evaluacion'
        unique_together = (('id_proceso', 'run_coach', 'id_encuesta'),)


class PlanAccion(models.Model):
    id_plan = models.FloatField(primary_key=True)
    fecha = models.DateField()
    tema = models.CharField(max_length=50)
    accion = models.CharField(max_length=150)
    id_proceso = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='id_proceso', related_name="plan_proceso")
    run_coach = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='run_coach',related_name="plan_coach")

    class Meta:
        managed = False
        db_table = 'plan_accion'


class Proceso(models.Model):
    id_proceso = models.FloatField(primary_key=True)
    nombre = models.CharField(max_length=50)
    modalidad = models.CharField(max_length=15)
    status = models.CharField(max_length=50)
    fecha_contrato = models.DateField()
    clausula = models.TextField()
    indicador_exito = models.CharField(max_length=200)
    objetivo = models.CharField(max_length=200)
    run_coach = models.ForeignKey(Coach, models.DO_NOTHING, db_column='run_coach', related_name="pro_coach")
    rut_empresa = models.ForeignKey(Empresa, models.DO_NOTHING, db_column='rut_empresa', related_name="pro_empresa")
    run_coachee = models.ForeignKey(Coachee, models.DO_NOTHING, db_column='run_coachee', related_name="pro_coachee")

    class Meta:
        managed = False
        db_table = 'proceso'
        unique_together = (('id_proceso', 'run_coach'),)


class Reunion(models.Model):
    id_reunion = models.FloatField(primary_key=True)
    fecha = models.DateField()
    participante = models.TextField()
    tipo_reunion = models.CharField(max_length=15)
    observacion = models.CharField(max_length=200, blank=True, null=True)
    antecedente_coachee = models.TextField(blank=True, null=True)
    id_proceso = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='id_proceso', related_name="reu_proceso")
    run_coach = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='run_coach', related_name="reu_coach")

    class Meta:
        managed = False
        db_table = 'reunion'


class Sesion(models.Model):
    id_sesion = models.IntegerField(primary_key=True)
    fecha_acordada = models.DateField()
    fecha_realizada = models.DateField(blank=True, null=True)
    descripcion = models.CharField(max_length=200)
    estado = models.FloatField()
    asignacion_acuerdos = models.TextField()
    id_proceso = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='id_proceso', related_name="ses_proceso")
    run_coach = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='run_coach', related_name="ses_coach")

    class Meta:
        managed = False
        db_table = 'sesion'