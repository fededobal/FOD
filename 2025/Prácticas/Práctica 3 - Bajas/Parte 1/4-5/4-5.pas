program cuatro_cinco;
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;
    tArchFlores = file of reg_flor;

procedure leerFlor(var flor: reg_flor);
begin
    writeln('Ingrese el codigo de flor');
    readln(flor.codigo);
    if(flor.codigo <> -1) then begin
        writeln('Ingrese el nombre de flor');
        readln(flor.nombre);
    end;
end;
procedure cargarArchivo(var a: tArchFlores);
var
    flor: reg_flor;
begin
    assign(a, 'archivoFlores');
    rewrite(a);
    flor.codigo := 0;
    flor.nombre := 'HEAD';
    write(a, flor);
    leerFlor(flor);
    while(flor.codigo <> -1) do begin
        write(a, flor);
        leerFlor(flor);
    end;
    close(a);
end;
{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente}
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    flor,head:reg_flor;
begin
    flor.nombre := nombre;
    flor.codigo := codigo;
    reset(a);
    read(a,head);
    if(head.codigo = 0) then begin
        seek(a,FileSize(a));
        write(a,flor);
    end else begin
        seek(a, head.codigo * -1);
        read(a,head);
        seek(a,FilePos(a)-1);
        write(a,flor);
        seek(a,0);
        write(a,head);
    end;
    writeln('Flor agregada.');
    close(a);
end;

{Abre el archivo y elimina la flor recibida como parámetro 
manteniendo la política descripta anteriormente}
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
    florAct,head:reg_flor;
    encontre:boolean;
begin
    encontre := false;
    reset(a);
    read(a,head);
    while(not eof(a) and not encontre) do begin
        read(a,florAct);
        if(florAct.codigo = flor.codigo) then begin
            encontre := true;
            seek(a,filepos(a)-1);
            write(a,head);
            head.codigo := (filepos(a) - 1) * -1;
            seek(a,0);
            write(a,head);
        end;
    end;
    if(encontre) then writeln('Flor "',flor.nombre,'" borrada exitosamente')
    else writeln('Flor no encontrada');
    close(a);
end;
procedure imprimirArchivo(var a: tArchFlores);
var
    f: reg_flor;
begin
    reset(a);
    while(not eof(a)) do begin
        read(a, f);
        if(f.codigo > 0) then writeln('Codigo=', f.codigo, ' Nombre=', f.nombre);
    end;
    close(a);
end;

var
    a:tArchFlores;
    f:reg_flor;
begin
    cargarArchivo(a);
    agregarFlor(a,'Margarita',1234);
    imprimirArchivo(a);

    f.codigo := 1234;
    f.nombre := 'Margarita';
    eliminarFlor(a,f);
    imprimirArchivo(a);
end.