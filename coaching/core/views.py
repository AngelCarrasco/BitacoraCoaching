from django.shortcuts import render, redirect
from django.db import connection
from django.core.files.storage import FileSystemStorage
from django.contrib.auth.hashers import make_password
from datetime import datetime
from datetime import date
from django.contrib import messages
import cx_Oracle

def users(request):
    rut = request.user.username
    from .models import Coach,Coachee
    
    if Coach.objects.filter(run_coach = rut):
        return redirect (lista_coach_Sesion
        )
    elif Coachee.objects.filter(run_coachee = rut) :
        return redirect (coachee)
    else :
        return redirect (administrador)

#FUNCIONES COACH
def coach(request):

    return render(request, 'core/administrador/coach.html')

def registro_sesion(request):
    p_fil_proceso ='SP_FILTRO_EMPRESA'
    run_coach = '11113'
    data ={
         # el ruun tiene que ser de la persona que tenga la sesion iniciada en el sistema
        'empresas': listar_anidado(p_fil_proceso,request.user.username)
    }
    cursor = connection.cursor()
    fs = FileSystemStorage()
    #try:
    if request.POST:

            fecha_acordada = request.POST.getlist('fecha_a')
            
            fecha_realizada = None
            descripcion = request.POST.getlist('descripcion')
            asignacion_acuerdos = request.POST.getlist('asigyacuerd')
            id_proceso = request.POST.get('proceso')
            estado = 1
            v_sesiones = []
            v_sesiones = fecha_acordada,descripcion,asignacion_acuerdos
            
            for col in range(len(v_sesiones[0])): 
                arreglo = [v_sesiones[0][col], v_sesiones[1][col], v_sesiones[2][col] , id_proceso]  
                #print(arreglo)
                fecha = datetime.strptime(arreglo[0], '%Y-%m-%dT%H:%M')
                salida = agregar_sesion(fecha, fecha_realizada, arreglo[1], estado, arreglo[2], id_proceso,request.user.username)
              
                
            
         #   salida = agregar_sesion(fecha,fecha_realizada,descripcion,estado,asignacion_acuerdos,id_proceso,request.user.username)
            
           # if salida == 1:
           #     messages.success(request,"Sesion Agregado correctamente")
             #   v_id_sesion = cursor.execute("select id_sesion from sesion where ROWNUM <= 1 order by id_sesion desc")

              #  for row in cursor:
                  #  for f in archivo:
                  #      name = fs.save(f.name, f)
                   #     url = fs.url(name)
                        
                        
                       # agregar_documento(url,int(row[0]))
         #   else:
              #  messages.error(request,"Error no se pudo agregar")
       # return render(request, 'core/coach/registro_sesion.html',data)

    #except:
      # messages.error(request,"Error no se pudo agregar")
    return render(request, 'core/coach/registro_sesion.html', data)
        
def lista_coach_Sesion(request):
    #aqui sera el rut del coach en la sesion, obtner mediante una etiqueta
    p_sesion = 'SP_LISTA_SESION'
    p_proceso_coach = 'SP_FILTRO_PROCESOS'
    run_coach = '11113'
   

    data ={
       'sesiones' : listar_anidado(p_sesion,request.user.username),
       'procesos' : listar_anidado(p_proceso_coach,request.user.username)
    }

    return render(request, 'core/coach/coach_menu.html',data)

def lista_proceso_por_empresa(request):
    p_fil_empresa ='SP_LISTA_PROCESO_FILT'
    rut_empresa = request.GET.get('empresa')

    data ={
       'sub_procesos' : combo_proceso_empresa(rut_empresa,request.user.username)

    }

    return render(request, 'core/coach/comboanidado.html',data)

#NUEVOOOOOOOO AGREGAR RAMA MAIN

def proceso_por_sesion(request):
    id_proceso = request.GET.get('empresa')
    v_filtro = 'SP_FILTRO_SESION'
    
    data ={
        'proceso_sesion' : listar_anidado(v_filtro,id_proceso)
      
    }

    return render(request, 'core/coach/anidadoSesion.html',data)

def empresa_coachee_filt(request):
    p_list = 'SP_COACHEE_EMPRESA'
    empresa = request.GET.get('empresa')
    data = {
        'coachees' : listar_anidado(p_list,empresa)
    }
    return render(request, 'core/coach/empresa_coachee.html', data)

def detalle_proceso_coach(request):
    id_proceso = request.GET.get('proceso')
    run_coach = '11113'
    
    data ={
        'procesos_coach' : lista_proceso_coach(request.user.username,id_proceso)
        
    }

    return render(request, 'core/coach/detalle_proceso_coach.html', data)

def subir_archivo(request):
    run_sesion ='SP_RUN_SESION'
    
 
    data ={
         # el ruun tiene que ser de la persona que tenga la sesion iniciada en el sistema
        'run_sesion': listar_anidado(run_sesion,request.user.username)
    }
    cursor = connection.cursor()
    fs = FileSystemStorage()    
    if request.POST:
        v_sesion = request.POST.get('sesion')
        archivo = request.FILES.getlist('archivo')
   
        for f in archivo:
            name = fs.save(f.name, f)
            url = fs.url(name)
            salida = agregar_documento(url,v_sesion)

    return render(request, 'core/coach/archivo_coach.html', data)


#FUNCIONES COACHEE
def coachee(request):
    data = {}
    p_detalle = 'SP_DETALLE_PROCESO_COACHEE'
    p_sesion = 'SP_LISTA_SESION_COACHEE'
    data = {
        'detalles' : listar_anidado(p_detalle,request.user.username),
        'sesiones' : listar_anidado(p_sesion,request.user.username)
    }
    return render(request, 'core/coachee/coachee.html', data)


#FUNCIONES ADMINISTRADOR
def administrador(request):
    p_coach = 'SP_LISTA_COACH'
    p_coachee = 'SP_LISTA_COACHEE'
    p_empresa = 'SP_LISTA_EMPRESA'
    p_proceso = 'SP_LISTA_PROCESO'
    data ={
        'coaches' : listar(p_coach),
        'coachees': listar(p_coachee),
        'empresas': listar(p_empresa),
        'procesos': listar(p_proceso)
    }
 
    return render(request, 'core/administrador/administrador.html',data)

def registro_coachee(request):
    p_empresa = 'SP_LISTA_EMPRESA'
    p_coachee = 'SP_LISTA_COACHEE'
    data= {
        'empresas': listar(p_empresa),
        'coachees' : listar(p_coachee)
    }
    try:
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
                messages.success(request,"Coachee agregado correctamente")
                data['coachees'] = listar(p_coachee)
            else:
                messages.error(request,"Error no se pudo agregar")
        
        return render(request, 'core/administrador/registro_coachee.html', data)
    except:
        messages.error(request,"Error no se pudo agregar")
    return render(request, 'core/administrador/registro_coachee.html', data)

def registro_coach(request):
    p_coach = 'SP_LISTA_COACH'
    data ={
    'coachs' : listar(p_coach)
    }
    try:
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
                messages.success(request,"Coach agregado correctamente")
                data['coachs'] = listar(p_coach)
            else:
                messages.error(request,"Error no se pudo agregar")
        return render(request, 'core/administrador/registro_coach.html', data)

    except:
        messages.error(request,"Error no se pudo agregar")
    return render(request, 'core/administrador/registro_coach.html', data)

def registro_empresa(request):
    p_empresa = 'SP_LISTA_EMPRESA'
    data={
        'empresas' : listar(p_empresa)
    }
    try:
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
                messages.success(request,"Empresa agregado correctamente")
                data['empresas'] = listar(p_empresa)
            else:
                messages.error(request,"Error no se pudo agregar")

        return render(request, 'core/administrador/registro_empresa.html', data)
    except:
        messages.error(request,"Error no se pudo agregar")
    return render(request, 'core/administrador/registro_empresa.html', data)

def registro_proceso(request):
    p_coach = 'SP_LISTA_COACH'
    p_empresa = 'SP_LISTA_EMPRESA'
    p_proceso = 'SP_LISTA_PROCESO'
    data = {
        'coachs' : listar(p_coach),
        'empresas' : listar(p_empresa),
        'procesos' : listar(p_proceso)
    }
    try:
        if request.POST:
            archivo = request.FILES['archivo']
            fs = FileSystemStorage()
            name = fs.save(archivo.name, archivo)
            url = fs.url(name)
            nombre = request.POST.get('nom_proceso')
            modalidad = request.POST.get('modalidad')
            fecha_acordada = request.POST.get('fecha_acordada')
            fecha = datetime.strptime(fecha_acordada, '%d-%m-%Y')
            run_coach = request.POST.get('coach')
            empresa = request.POST.get('empresa')
            objetivo = request.POST.get('objetivo')
            indicador = request.POST.get('indicador')
            coachee = request.POST.get('coachee')
            status = '1'
            salida = agregar_proceso(nombre,modalidad,status,fecha,url,indicador,objetivo,run_coach,empresa,coachee)
            if salida == 1:
                messages.success(request,"Proceso agregado correctamente")
                data['procesos'] = listar(p_proceso)
            else:
                messages.error(request,"Error no se pudo agregar")
        return render(request, 'core/administrador/registro_proceso.html',data)
    except:
        messages.error(request,"Error no se pudo agregar")
    return render(request, 'core/administrador/registro_proceso.html', data)

def detalle_proceso(request):
    p_detalle = 'SP_DETALLE_PROCESO'
    id_proceso = request.GET.get('proceso')

    data ={
        'procesos' : listar_anidado(p_detalle,id_proceso)
    }

    return render(request, 'core/administrador/detalle_proceso.html', data)

def deshabilitar_proceso(request):

    p_deshabilitar = 'SP_DESHABILITAR_PROCESO'
    id_proceso = request.GET.get('proceso')

    data ={
        'procesos' : deshabilitar(p_deshabilitar,id_proceso)
    }

    return render(request, 'core/administrador/deshabilitar_proceso.html', data)

def deshabilitar_coach(request):
    p_deshabilitar_c = 'SP_DESHABILITAR_COACH'
    run_coach = request.GET.get('coach')

    data ={
        'coachs' : deshabilitar(p_deshabilitar_c,run_coach)
    }

    return render(request, 'core/administrador/deshabilitar_coach.html', data)

def deshabilitar_coachee(request):
    p_deshabilitar_ce = 'SP_DESHABILITAR_COACHEE'
    run_coachee = request.GET.get('coachee')

    data ={
        'coachs' : deshabilitar(p_deshabilitar_ce,run_coachee)
    }

    return render(request, 'core/administrador/deshabilitar_coachee.html', data)

#COMBOBOX EMPRESA COACHEE EN EL PROCESO
def coachee_empresa(request):
    p_list = 'SP_COACHEE_EMPRESA'
    empresa = request.GET.get('empresa')
    data = {
        'coachees' : listar_anidado(p_list,empresa)
    }
    return render(request, 'core/administrador/coachee_empresa.html', data)

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

def agregar_proceso(nombre,modalidad,status,fecha,clausula,indicador,objetivo,run_coach,empresa,coachee):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_PROCESO',[nombre,modalidad,status,fecha,clausula,indicador,objetivo,run_coach,empresa,coachee,salida])

    return salida.getvalue()

def agregar_documento(archivo, id_sesion):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_ARCHIVO',[archivo, id_sesion,salida])

    return salida.getvalue()

def agregar_sesion(fecha_acordada,fecha_realizada,descripcion,estado,asignacion_acuerdos,id_proceso,run_coach):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_SESION',[fecha_acordada,fecha_realizada,descripcion,estado,asignacion_acuerdos,id_proceso,run_coach,salida])

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

def lista_proceso_coach(rut_coach,id_proceso):

    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()
    cursor.callproc("SP_DETALLE_PROCESO_COACH",[out_cur, id_proceso,rut_coach])

    lista = []
    for fila in out_cur:
        lista.append(fila)
    return lista

def combo_proceso_empresa(rut_empresa,rut_coach):
    
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    out_cur = django_cursor.connection.cursor()
    cursor.callproc("SP_LISTA_PROCESO_FILT",[out_cur, rut_empresa,rut_coach])

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


#NO SE ESTA UTILIZANDO
def lista_coach_proceso(request):
    pass   

def contrato(request):
    pass

def agregar_contrato(fecha,clausula,proceso,run_coach,run_coachee):
    django_cursor = connection.cursor()
    cursor = django_cursor.connection.cursor()
    salida = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('SP_AGREGAR_CONTRATO',[fecha,clausula,proceso,run_coach,run_coachee,salida])

    return salida.getvalue()
#FIN NO SE ESTA USANDO