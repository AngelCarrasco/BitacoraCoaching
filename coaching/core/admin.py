from django.contrib import admin
from .models import Coachee,Empresa,Coach,Encuesta

# Register your models here.

admin.site.register(Coachee)
admin.site.register(Empresa)
admin.site.register(Coach)
admin.site.register(Encuesta)