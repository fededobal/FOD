program dos;
type
    asistente = record
        nro:integer;
        apellido:string;
        nombre:string;
        email:string;
        tel:string;
        dni:longint;
    end;

    archivoAsistentes = file of asistente;

procedure asignarBin(var a: archivoAsistentes);
var
    aFisico: string;
begin
    write('Ingrese nombre del archivo binario: ');
    readln(aFisico);
    assign(a, aFisico);
end;
procedure crearBinario(var arc: archivoAsistentes);
var
    a:asistente;
    i:integer;
begin
    writeln('-- NUEVO ARCHIVO BINARIO --');
    asignarBin(arc);
    rewrite(arc);
    for i:= 1 to 5 do begin
        with a do begin
            readln(nro);
            readln(apellido);
            readln(nombre);
            readln(email);
            readln(tel);
            readln(dni);
        end;
        write(arc,a);
    end;
    close(arc);
end;
procedure realizarBajas(var arc:archivoAsistentes);
var
    a:asistente;
begin
    reset(arc);
    while(not eof(arc)) do begin
        read(arc,a);
        if(a.nro < 1000) then begin
            a.nombre := '~' + a.nombre;
            seek(arc, filepos(arc)-1);
            write(arc, a);
        end;
    end;
    close(arc);
end;

var
    a:archivoAsistentes;
begin
    // crearBinario(a);
    realizarBajas(a);
end.