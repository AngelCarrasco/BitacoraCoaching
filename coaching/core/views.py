from django.shortcuts import render
from django.db import connection
import cx_Oracle

# Create your views here.

def login(request):
    return render(request, 'core/login.html')

def administrador(request):
    data ={
        'coaches' : listar_coach(),
        'coachees': listar_coachee(),
    }
    return render(request, 'core/administrador.html',data)


def registro_coach(request):
    data ={}

    if request.method == 'POST':
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
    data= {
        'empresas': listar_empresa(),
    }

    #agregar_coachee('896754','soto','carlos','vendedor','guzman','algo@algo.com','1423','kaka','1')      
    if request.method == 'POST':
        run = request.POST.get('run')
        amaterno = request.POST.get('a_materno')
        nombre = request.POST.get('nombre')
        cargo = request.POST.get('cargo')
        apaterno = request.POST.get('a_paterno')
        correo = request.POST.get('correo')
        empresa = request.POST.get('empresa')
        rut_empresa = str(empresa)
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


def listar_empresa():
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()

    cursor.callproc('SP_LISTAR_EMPRESA',[out_cur])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista

def listar_coach():
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()

    cursor.callproc('SP_LISTA_COACH',[out_cur])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista

def listar_coachee():
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()

    cursor.callproc('SP_LISTA_COACHEE',[out_cur])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista