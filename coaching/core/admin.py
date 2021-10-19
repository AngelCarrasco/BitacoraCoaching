from django.contrib import admin

from core.views import contrato
from .models import Coach,Coachee,Empresa,Encuesta,Proceso,Documentacion

# Register your models here.

admin.site.register(Coachee)
admin.site.register(Empresa)
admin.site.register(Coach)
admin.site.register(Encuesta)
admin.site.register(Proceso)
admin.site.register(Documentacion)
