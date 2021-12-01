from os import name
from django.urls import path
from . import views

urlpatterns = [
    path('', views.users, name="user"),
    #URLS ADMIN
    path('administrador/', views.administrador, name="administrador"),
    path('registro_coach/', views.registro_coach, name="registro_coach"),
    path('registro_coachee/', views.registro_coachee, name="registro_coachee"),
    path('registro_empresa/', views.registro_empresa, name="registro_empresa"),
    path('registro_proceso/', views.registro_proceso, name="registro_proceso"),
    path('detalle_proceso/', views.detalle_proceso, name="detalle_proceso"),
    path('deshabilitar_proceso/', views.deshabilitar_proceso, name="deshabilitar_proceso"),
    path('deshabilitar_coach/', views.deshabilitar_coach, name="deshabilitar_coach"),
    path('deshabilitar_coachee/', views.deshabilitar_coachee, name="deshabilitar_coachee"),
    path('coachee_empresa/', views.coachee_empresa, name="coachee_empresa"),
    path('coach/', views.coach, name="coach"),
    path('contrato/', views.contrato , name="contrato"),
    path('combox/', views.lista_coach_proceso, name="combox"),
    path('preguntas/', views.registro_preguntas, name="preguntas"),
    
    #URLS COACHEE
    path('coachee/', views.coachee, name="coachee"),
    path('descargar/', views.descargar, name="descargar"),
    path('evaluar_proceso/', views.evaluar_proceso_coach, name="evaluar_proceso"),
    path('detalle_coachee/', views.detalle_proceso_coachee, name="detalle_coachee"),
    path('procesos_finalizados/', views.procesos_finalizados, name="procesos_finalizados"),

    #URLS COACH
    path('coach_menu/', views.lista_coach_Sesion, name="coach_menu"),
    path('proceso_empresa/',views.lista_proceso_por_empresa, name="proceso_empresa"),
    path('registro_sesion/', views.registro_sesion, name="registro_sesion"),
    path('detalle_proceso_coach/', views.detalle_proceso_coach, name="detalle_proceso_coach"),
    path('coachee_empresa_filt/', views.empresa_coachee_filt, name="empresa_coachee_filt"),
    path('subir_archivo/', views.subir_archivo, name="subir_archivo"),
    path('proceso_sesion/',views.proceso_por_sesion, name="proceso_sesion"),
    path('detalle_sesion/', views.detalle_sesion, name="detalle_sesion"),
]