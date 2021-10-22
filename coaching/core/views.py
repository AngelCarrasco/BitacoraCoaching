from django.shortcuts import render
from django.db import connection
from django.core.files.storage import FileSystemStorage
import cx_Oracle

# Create your views here.

def login(request):
    return render(request, 'core/login.html')

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
    p_proceso = 'SP_LISTA_PROCESO'
    p_coachee = 'SP_LISTA_COACHEE'

    data ={
        'coachees': listar(p_coachee),
        'procesos': listar(p_proceso)
    }

    if request.POST:
        
        archivo = request.FILES['clausula']
        fs = FileSystemStorage()
        name = fs.save(archivo.name, archivo)
        url = fs.url(name)
        fecha = request.POST.get("fecha")
        id_proceso = request.POST.get("proceso")
        run_coach = request.POST.get("coach")
        run_coachee = request.POST.get("coachee")

        salida = agregar_contrato(fecha,url,id_proceso,run_coach,run_coachee)
        if salida ==1:
             data['mensaje']='Agregado con exito'
        else:
             data['mensaje'] = 'no se ha podido agregar'

    return render(request, 'core/contrato.html', data)

#CRUD empresa
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

#CRUD proceso
def registro_proceso(request):
    p_coach = 'SP_LISTA_COACH'
    data = {
        'coachs' : listar(p_coach)
    }

    if request.POST:
        nombre = request.POST.get('nombre')
        modalidad = request.POST.get('modalidad')
        run_coach = request.POST.get('coach')
        status = '1'

        salida = agregar_proceso(nombre,modalidad,status,run_coach)

        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
        else:
            data['mensaje'] = 'no se ha agregado'

    return render(request, 'core/registro_proceso.html',data)

#CRUD coach
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
        contrasena = run[:4]
        contrato = '1'
        salida = agregar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato)
        if salida == 1:
            data['mensaje'] = 'agregado correctamente'
            data['coachs'] = listar(p_coach)
        else:
            data['mensaje'] = 'no se ha podido agregar'
    return render(request, 'core/registro_coach.html', data)

#CRUD coachee
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


#Vista coach
def coach(request):

    return render(request, 'core/coach.html')


#PROCEDIMIENTOS BD
def agregar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_COACH',[run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato,salida])

    return salida.getvalue()

def actualizar_coach(run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_ACTUALIZAR_COACH',[run,nombre,ap_paterno,ap_materno,telefono,correo,contrasena,contrato,salida])

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


