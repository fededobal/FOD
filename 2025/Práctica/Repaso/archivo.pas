program archivo;
type
    libro = record
        ISBN:real;
        autor:string;
        titulo:string;
        fecha:string;
        stock:integer;
        dispo:boolean;
    end;
    
    archLibros = file of libro;

procedure leerLibro(var l:libro);
begin
    readln(l.ISBN);
    if(l.ISBN <> 0) then begin
        readln(l.autor);
        readln(l.titulo);
        readln(l.fecha);
        readln(l.stock);
    end;
    l.dispo := l.stock > 0;
end;
procedure convertirATexto(var a1:archLibros);
var
    a2:text; l:libro;
begin
    assign(a2,'libros.txt');
    reset(a1);
    rewrite(a2); reset(a2);
    while(not eof(a1)) do begin
        read(a1,l);
        writeln(a2,'ISBN: ',l.ISBN,'  Autor: ',l.autor,'  Título: ',l.titulo,'  Fecha de publicación: ',l.fecha,'  Stock: ',l.stock,'  Disponible: ',l.dispo);
    end;
    close(a1); close(a2);
end;

var
    a1:archLibros; l:libro;
begin
    assign(a1,'libros.dat');
    rewrite(a1);
    reset(a1);
    leerLibro(l);
    while(l.ISBN <> 0) do begin
        write(a1,l);
        leerLibro(l);
    end;
    close(a1);
    convertirATexto(a1);
end.