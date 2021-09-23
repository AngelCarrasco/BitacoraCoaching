from django.urls import path
from . import views

urlpatterns = [
    
    path('', views.administrador, name="administrador"),
    path('/registro_coach', views.registro_coach, name="registro_coach"),
    path('/registro_coachee', views.registro_coachee, name="registro_coachee"),
    path('/registro_empresa', views.registro_empresa, name="registro_empresa"),
    path('/registro_proceso', views.registro_proceso, name="registro_proceso"),
    path('/coach', views.coach, name="coach"),
    path('/login', views.login, name="login"),
]