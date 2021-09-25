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
    contrasena = models.CharField(max_length=16)
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
    rut_empresa = models.ForeignKey('Empresa', models.DO_NOTHING, db_column='rut_empresa')
    contrasena = models.CharField(max_length=16)
    contrato = models.FloatField()

    class Meta:
        managed = False
        db_table = 'coachee'


class Contrato(models.Model):
    id_contrato = models.AutoField(primary_key=True)
    fecha_cantro = models.DateField()
    clausula = models.TextField()
    id_proceso = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='id_proceso', related_name="con_id_proceso")
    run_coach = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='run_coach', related_name="con_run_coach")
    run_coachee = models.ForeignKey(Coachee, models.DO_NOTHING, db_column='run_coachee', related_name="con_run_coachee")

    class Meta:
        managed = False
        db_table = 'contrato'


class Documentacion(models.Model):
    archivo = models.FileField(upload_to='folder',blank=True,null=True)
    fecha_subida = models.DateField()
    run_coachee = models.ForeignKey(Coachee, models.DO_NOTHING, db_column='run_coachee')
    run_coach = models.OneToOneField(Coach, models.DO_NOTHING, db_column='run_coach', primary_key=True)
    fecha_vista = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'documentacion'
        unique_together = (('run_coach', 'run_coachee'),)


class Empresa(models.Model):
    rut_empresa = models.CharField(primary_key=True, max_length=13)
    direccion = models.CharField(max_length=30)
    telefono = models.IntegerField()
    nombre = models.CharField(max_length=30)
    correo = models.CharField(max_length=50)
    contrato = models.FloatField()

    class Meta:
        managed = False
        db_table = 'empresa'


class Encuesta(models.Model):
    id_pregunta = models.AutoField(primary_key=True)
    pregunta = models.CharField(max_length=20)
    nota = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'encuesta'


class Evaluacion(models.Model):
    id_encuesta = models.AutoField(primary_key=True)
    fecha = models.DateField()
    comentario = models.CharField(max_length=100, blank=True, null=True)
    promedio = models.FloatField(blank=True, null=True)
    id_proceso = models.OneToOneField('Proceso', models.DO_NOTHING, db_column='id_proceso')
    run_coach = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='run_coach', related_name="eva_run_coach")
    id_pregunta = models.ForeignKey(Encuesta, models.DO_NOTHING, db_column='id_pregunta', related_name="eva")

    class Meta:
        managed = False
        db_table = 'evaluacion'
        unique_together = (('id_proceso', 'run_coach', 'id_encuesta'),)


class Indicador(models.Model):
    id_incador = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50)
    valor_meta = models.FloatField()
    descripcion = models.CharField(max_length=150)
    id_objetivo = models.ForeignKey('Objetivo', models.DO_NOTHING, db_column='id_objetivo')

    class Meta:
        managed = False
        db_table = 'indicador'


class Objetivo(models.Model):
    id_objetivo = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=150)
    id_proceso = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='id_proceso',related_name="ob_id_proceso")
    run_coach = models.ForeignKey('Proceso', models.DO_NOTHING, db_column='run_coach',related_name="ob_run_cocach")
    id_reunion = models.ForeignKey('ReunionIni', models.DO_NOTHING, db_column='id_reunion',related_name="ob_id_reunion")

    class Meta:
        managed = False
        db_table = 'objetivo'


class PlanAccion(models.Model):
    id_plan = models.AutoField(primary_key=True)
    fecha = models.DateField()
    tema = models.CharField(max_length=50)
    accion = models.CharField(max_length=150)
    id_sesion = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='id_sesion',related_name="pa_id_sesion")
    id_proceso = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='id_proceso',related_name="pa_id_proceso")
    run_coach = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='run_coach',related_name="pa_run_coach")
    run_coachee = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='run_coachee',related_name="pa_run_coachee")

    class Meta:
        managed = False
        db_table = 'plan_accion'


class Proceso(models.Model):
    id_proceso = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50)
    modalidad = models.CharField(max_length=15)
    status = models.CharField(max_length=50)
    run_coach = models.ForeignKey(Coach, models.DO_NOTHING, db_column='run_coach', related_name="pro_run_coach")

    class Meta:
        managed = False
        db_table = 'proceso'
        unique_together = (('id_proceso', 'run_coach'),)


class ReunionAvance(models.Model):
    id_avance = models.AutoField(primary_key=True)
    fecha = models.DateField()
    observacion = models.CharField(max_length=250)
    id_sesion = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='id_sesion',related_name="ra_id_sesion")
    id_proceso = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='id_proceso',related_name="ra_id_proceso")
    run_coach = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='run_coach',related_name="ra_run_coach")
    run_coachee = models.ForeignKey('Sesion', models.DO_NOTHING, db_column='run_coachee',related_name="ra_run_coachee")

    class Meta:
        managed = False
        db_table = 'reunion_avance'


class ReunionIni(models.Model):
    id_reunion = models.AutoField(primary_key=True)
    fecha = models.DateField()
    antecedente_coachee = models.TextField()
    objetivo_proceso = models.TextField()
    indicador_exito = models.TextField()
    participante = models.TextField()

    class Meta:
        managed = False
        db_table = 'reunion_ini'


class Sesion(models.Model):
    id_sesion = models.IntegerField(primary_key=True)
    fecha_acordada = models.DateField()
    fecha_realizada = models.DateField(blank=True, null=True)
    estado = models.FloatField()
    asignacion_acuerdos = models.TextField()
    id_proceso = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='id_proceso',related_name="se_id_proceso")
    run_coach = models.ForeignKey(Proceso, models.DO_NOTHING, db_column='run_coach',related_name="se_run_coach")
    run_coachee = models.ForeignKey(Coachee, models.DO_NOTHING, db_column='run_coachee',related_name="se_run_coachee")

    class Meta:
        managed = False
        db_table = 'sesion'
        unique_together = (('id_sesion', 'id_proceso', 'run_coach', 'run_coachee'),)
