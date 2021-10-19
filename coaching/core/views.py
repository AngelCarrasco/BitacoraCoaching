from django.shortcuts import render
from django.db import connection
import cx_Oracle

# Create your views here.

def login(request):
    return render(request, 'core/login.html')

def administrador(request):
    p_coach = 'SP_LISTA_COACH'
    p_coachee = 'SP_LISTA_COACHEE'
    p_proceso = 'SP_LISTA_PROCESO'
    p_empresa = 'SP_LISTA_EMPRESA'
    data ={
        'coaches' : listar(p_coach),
        'coachees': listar(p_coachee),
        'empresas': listar(p_empresa),
    }
    return render(request, 'core/administrador.html',data)

def registro_empresa(request):
    data={}

    if request.POST:
         rut = request.POST.get('rut')
         direccion = request.POST.get('direccion')
         telefono = request.POST.get('telefono')
         nombre = request.POST.get('nombre')
         correo = request.POST.get('correo')
         contrato = '1'

         salida = agregar_empresa(rut,direccion,telefono,nombre,correo,contrato)

         if salida ==1:
             data['mensaje']='Agregado con exito'
         else:
             data['mensaje'] = 'no se ha podido agregar'

    return render(request, 'core/registro_empresa.html', data)

def registro_proceso(request):
    data={}

    return render(request, 'core/registro_proceso.html')


def registro_coach(request):
    data ={}

    if request.POST:
        run = request.POST.get('run')
        nombre = request.POST.get('nombre')
        ap_paterno = request.POST.get('a_paterno')
        ap_materno = request.POST.get('a_materno')
        telefono = request.POST.get('telefono')
        correo = request.POST.get('correo')
        contrasena = run[:4]
        contrato = '1'
        salida = agregar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato)
        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
        else:
            data['mensaje'] = 'no se ha podido agregar'

    return render(request, 'core/registro_coach.html', data)


def registro_coachee(request):
    p_empresa = 'SP_LISTA_EMPRESA'
    data= {
        'empresas': listar(p_empresa),
    }

    if request.POST:
        run = request.POST.get('run')
        amaterno = request.POST.get('a_materno')
        nombre = request.POST.get('nombre')
        cargo = request.POST.get('cargo')
        apaterno = request.POST.get('a_paterno')
        correo = request.POST.get('correo')
        empresa = request.POST.get('empresa')
        rut_empresa = empresa
        contrasena = run[:4]
        contrato = '1'

        salida = agregar_coachee(run,amaterno,nombre,cargo,apaterno,correo,rut_empresa,contrasena,contrato)

        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
        else:
            data['mensaje'] = 'no se ha agregado'
       
    return render(request, 'core/registro_coachee.html', data)


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

def agregar_empresa(rut,direccion,telefono,nombre,correo,contrato):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_EMPRESA',[rut,direccion,telefono,nombre,correo,contrato,salida])

    return salida.getvalue()

def agregar_proceso(nombre,modalidad,status,run_coach):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_PROCESO',[nombre,modalidad,status,run_coach,salida])

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
