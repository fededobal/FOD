program multinacional;
const
    VALOR_ALTO = 32700;
type
    empleado = record
        dni:integer;
        nom,ap:string[20];
        edad:integer;
        domicilio:string[50];
        fechaN:string[10];
    end;
    archivo = file of empleado;

function existeEmpleado(var a:archivo; dni:integer):boolean; // se dispone
procedure leer(var a:archivo; var e:empleado);
begin
    if(not eof(a)) then
        read(a,e)
    else
        e.dni := VALOR_ALTO;
end;
procedure leerEmpleado(var e:empleado);
begin
    readln(e.dni);
    readln(e.nom);
    readln(e.ap);
    readln(e.domicilio);
    readln(e.fechaN);
end;
procedure AgregarEmpleado(var a:archivo);
var
    head,e:empleado;
begin
    reset(a);
    leer(a,head);
    leerEmpleado(e);
    if(not existeEmpleado(a,e.dni)) then begin
        if(head.dni = 0) then begin
            seek(a,filesize(a));
            write(a,e);
        end else begin
            seek(a,head.dni * -1);
            leer(a,head);
            seek(a,filepos(a)-1);
            write(a,e);
            seek(a,0);
            write(a,head);
        end;
    end else writeln('ERROR! El empleado con DNI ',e.dni,' ya existe.');
    close(a);
end;
procedure QuitarEmpleado(var a:archivo);
var
    dni:integer;
    head,e:empleado;
begin
    reset(a);
    leer(a,head);
    readln(dni);
    if(existeEmpleado(a,dni)) then begin
        seek(a,filepos(a)-1);
        leer(a,e);
        seek(a,filepos(a)-1);
        write(a,head);
        e.dni := e.dni * -1;
        seek(a,0);
        write(a,e);
    end else writeln('ERROR! El empleado con DNI ',dni,' NO existe.'); 
    close(a);
end;
var
    a:archivo;
begin
    assign(a,'archivo');
    AgregarEmpleado(a);
    QuitarEmpleado(a);
end.