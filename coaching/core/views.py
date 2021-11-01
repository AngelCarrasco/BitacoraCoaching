from django.shortcuts import render, redirect
from django.db import connection
from django.core.files.storage import FileSystemStorage
from django.contrib.auth.hashers import make_password
from datetime import datetime
import cx_Oracle

def users(request):
    rut = request.user.username
    from .models import Coach,Coachee
    
    if Coach.objects.filter(run_coach = rut):
        return redirect (coach)
    elif Coachee.objects.filter(run_coachee = rut) :
        return redirect (coachee)
    else :
        return redirect (administrador)

#FUNCIONES COACH
def coach(request):

    return render(request, 'core/coach.html')

def coachee(request):
    return render(request, 'core/coachee.html')

#FUNCIONES ADMINISTRADOR 
def administrador(request):
    p_coach = 'SP_LISTA_COACH'
    p_coachee = 'SP_LISTA_COACHEE'
    p_proceso = 'SP_LISTA_PROCESO'
    p_empresa = 'SP_LISTA_EMPRESA'
    p_proceso = 'SP_LISTA_PROCESO'
    data ={
        'coaches' : listar(p_coach),
        'coachees': listar(p_coachee),
        'empresas': listar(p_empresa),
        'procesos': listar(p_proceso)
    }
 
    return render(request, 'core/administrador.html',data)

def contrato(request):
    pass

#COMBOBOX 
def lista_coach_proceso(request):
    p_list = 'SP_LIST_PROCESO_COACH'
    id_proceso = request.GET.get('proceso')

    data ={
        'coachs' : listar_anidado(p_list,id_proceso)
    }

    return render(request, 'core/combox_coach.html', data)

def registro_empresa(request):
    p_empresa = 'SP_LISTA_EMPRESA'
    data={
        'empresas' : listar(p_empresa)
    }

    if request.POST:
         rut = request.POST.get('rut')
         direccion = request.POST.get('direccion')
         telefono = request.POST.get('telefono')
         nombre = request.POST.get('nombre')
         correo = request.POST.get('correo')
         jefe_n = request.POST.get('jefe_nombre')
         jefe_c = request.POST.get('jefe_correo')
         jefe_t = request.POST.get('jefe_telefono')
         contrato = '1'

         salida = agregar_empresa(rut,direccion,telefono,nombre,correo,contrato,jefe_n,jefe_c,jefe_t)

         if salida ==1:
             data['mensaje']='Agregado con exito'
             data['empresas'] = listar(p_empresa)
         else:
             data['mensaje'] = 'no se ha podido agregar'

    return render(request, 'core/registro_empresa.html', data)

def registro_proceso(request):
    p_coach = 'SP_LISTA_COACH'
    p_empresa = 'SP_LISTA_EMPRESA'
    p_proceso = 'SP_LISTA_PROCESO'
    data = {
        'coachs' : listar(p_coach),
        'empresas' : listar(p_empresa),
        'procesos' : listar(p_proceso)
    }

    if request.POST:
        archivo = request.FILES['archivo']
        fs = FileSystemStorage()
        name = fs.save(archivo.name, archivo)
        url = fs.url(name)


        nombre = request.POST.get('nom_proceso')
        modalidad = request.POST.get('modalidad')
        fecha_acordada = request.POST.get('fecha_acordada')
        fecha = datetime.strptime(fecha_acordada, '%d-%m-%YT%H:%M')
        run_coach = request.POST.get('coach')
        empresa = request.POST.get('empresa')
        status = '1'

        salida = agregar_proceso(nombre,modalidad,status,fecha,url,run_coach,empresa)

        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
            data['procesos'] = listar(p_proceso)
        else:
            data['mensaje'] = 'no se ha agregado'

    return render(request, 'core/registro_proceso.html',data)

def detalle_proceso(request):
    p_detalle = 'SP_DETALLE_PROCESO'
    id_proceso = request.GET.get('proceso')

    data ={
        'procesos' : listar_anidado(p_detalle,id_proceso)
    }

    return render(request, 'core/detalle_proceso.html', data)

def registro_coach(request):
    p_coach = 'SP_LISTA_COACH'
    data ={
        'coachs' : listar(p_coach)
    }

    if request.POST:
        run = request.POST.get('run')
        nombre = request.POST.get('nombre')
        ap_paterno = request.POST.get('a_paterno')
        ap_materno = request.POST.get('a_materno')
        telefono = request.POST.get('telefono')
        correo = request.POST.get('correo')
        
        contra = make_password(run[:4])
        
        contrato = '1'
        salida = agregar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contra,contrato)
        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
            data['coachs'] = listar(p_coach)
        else:
            data['mensaje'] = 'no se ha podido agregar'

    return render(request, 'core/registro_coach.html', data)

def registro_coachee(request):
    p_empresa = 'SP_LISTA_EMPRESA'
    p_coachee = 'SP_LISTA_COACHEE'
    data= {
        'empresas': listar(p_empresa),
        'coachees' : listar(p_coachee)
    }

    if request.POST:
        run = request.POST.get('run')
        amaterno = request.POST.get('a_materno')
        nombre = request.POST.get('nombre')
        cargo = request.POST.get('cargo')
        apaterno = request.POST.get('a_paterno')
        correo = request.POST.get('correo')
        empresa = request.POST.get('empresa')
        
        contrasena = make_password(run[:4])
        contrato = '1'
       

        salida = agregar_coachee(run,amaterno,nombre,cargo,apaterno,correo,empresa,contrasena,contrato)

        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
            data['coachees'] = listar(p_coachee)
        else:
            data['mensaje'] = 'no se ha agregado'
       
    return render(request, 'core/registro_coachee.html', data)


#PROCEDIMIENTOS ALMACENADOS
def agregar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_COACH',[run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato,salida])

    return salida.getvalue()

def agregar_coachee(run,amaterno,nombre,cargo,apaterno,correo,rut_empresa,contrasena,contrato):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_COACHEE',[run,amaterno,nombre,cargo,apaterno,correo,rut_empresa,contrasena,contrato,salida])

    return salida.getvalue()

def agregar_empresa(rut,direccion,telefono,nombre,correo,contrato,nombre_jefe,correo_jefe,telefono_jefe):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_EMPRESA',[rut,direccion,telefono,nombre,correo,contrato,nombre_jefe,correo_jefe,telefono_jefe,salida])

    return salida.getvalue()

def agregar_proceso(nombre,modalidad,status,fecha,clausula,run_coach,empresa):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_PROCESO',[nombre,modalidad,status,fecha,clausula,run_coach,empresa,salida])

    return salida.getvalue()

def agregar_contrato(fecha,clausula,proceso,run_coach,run_coachee):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_CONTRATO',[fecha,clausula,proceso,run_coach,run_coachee,salida])

    return salida.getvalue()

def listar(procedimiento):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()

    cursor.callproc(procedimiento,[out_cur])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista

def listar_anidado(procedimiento,filtro):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()

    cursor.callproc(procedimiento,[out_cur, filtro])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista

def deshabilitar(procedimiento, filtro):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc(procedimiento,[filtro,salida])

    return salida.getvalue()
