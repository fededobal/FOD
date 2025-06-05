{ Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario. }

program tres;
type
    empleado = record
        nro:integer;
        nombre:string;
        apellido:string;
        edad:integer;
        dni:integer;
    end;
    archivoEmpleados = file of empleado;
procedure leer(var e:empleado);
begin
    write('Nro: '); readln(e.nro);
    write('Nombre: '); readln(e.nombre);
    write('Apellido: '); readln(e.apellido);
    if(e.apellido <> 'fin') then begin
        write('Edad: '); readln(e.edad);
        write('DNI: '); readln(e.dni);
    end;
end;
procedure cargarArchivo(var aE:archivoEmpleados);
var
    e:empleado; nomArc: string;
begin
    writeln('----- NUEVO ARCHIVO -----');
    write('Ingrese el nombre del archivo: '); readln(nomArc);
    assign(aE,nomArc);
    rewrite(aE);
    reset(aE);
    leer(e);
    while(e.apellido <> 'fin') do begin
        write(aE,e);
        leer(e);
    end;
    close(aE);
end;
procedure imprimirEmpleado(e:empleado);
begin
    writeln(e.nro,', ',e.nombre,', ',e.apellido,', ',e.edad,', ',e.dni,'.');
end;
procedure listarNomAp(var aE:archivoEmpleados);
var
    nomap:string; e:empleado;
begin
    writeln('Ingrese un nombre o apellido:');
    readln(nomap);
    reset(aE);
    writeln('Empleados con ese nombre o apellido:');
    while(not EOF(aE)) do begin
        read(aE,e);
        if(e.nombre = nomap) or (e.apellido = nomap) then
            imprimirEmpleado(e);
    end;
    close(aE);
end;
procedure listarDeAUno(var aE:archivoEmpleados);
var
    e:empleado;
begin
    reset(aE);
    writeln('Todos los empleados:');
    while(not EOF(aE)) do begin
        read(aE,e);
        imprimirEmpleado(e);
    end;
    close(aE)
end;
procedure listarMayores70(var aE:archivoEmpleados);
var
    e:empleado;
begin
    reset(aE);
    writeln('Empleados mayores de 70:');
    while(not EOF(aE)) do begin
        read(aE,e);
        if(e.edad > 70) then
            imprimirEmpleado(e);
    end;
    close(aE);
end;
function menu1():integer;
var
    opt:integer;
begin
    writeln('----- MENU DE OPCIONES -----');
    writeln('1. Nuevo archivo');
    writeln('2. Abrir archivo');
    readln(opt);
    menu1:= opt;
end;
function menu2():integer;
var
    opt:integer;
begin
    writeln('----- ABRIR ARCHIVO -----');
    writeln('1. Listar empleados con determinado nombre o apellido');
    writeln('2. Listar todos los empleados');
    writeln('3. Listar empleados mayores de 70');
    readln(opt);
    menu2:= opt;
end;
procedure abrirArchivo(var aE:archivoEmpleados);
var
    nomArc:string;
begin
    write('Ingrese el nombre del archivo a abrir (con su extension): '); readln(nomArc);
    assign(aE,nomArc);
    case menu2() of
        1: listarNomAp(aE);
        2: listarDeAUno(aE);
        3: listarMayores70(aE);
    else
        writeln('Opcion incorrecta.');
    end;
end;
procedure menuPrincipal(var aE:archivoEmpleados);
begin
    while(true) do
        case menu1() of
            1: cargarArchivo(aE);
            2: abrirArchivo(aE);
        else
            writeln('Opcion incorrecta.');
        end;
end;
var
    aE:archivoEmpleados;
begin
    menuPrincipal(aE);
end.