from django.contrib import admin

from core.views import contrato
from .models import *

# Register your models here.

admin.site.register(Coachee)
admin.site.register(Empresa)
admin.site.register(Coach)
#admin.site.register(Encuesta)
admin.site.register(Proceso)
#admin.site.register(Documentacion)
