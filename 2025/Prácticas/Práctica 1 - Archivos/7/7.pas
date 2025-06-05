{ Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado. }

program siete;
type
    novela = record
        code:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;

    a1 = file of novela;

procedure asignarBin(var a: a1);
var
    aFisico: string;
begin
    write('Ingrese nombre del archivo binario: ');
    readln(aFisico);
    assign(a, aFisico);
end;
procedure crearBinario(var a:a1);
var
    aTXT:text; n:novela;
begin
    writeln('-- NUEVO ARCHIVO BINARIO --');
    asignarBin(a);
    rewrite(a);
    assign(aTXT,'7-novelas.txt');
    reset(aTXT);
    while(not EOF(aTXT)) do begin
        with n do begin
            readln(aTXT,code,precio,genero);
            readln(aTXT,nombre);
        end;
        write(a,n);
    end;
    close(a);
    close(aTXT);
end;
procedure leerNovela(var n:novela);
begin
    write('Codigo: '); readln(n.code);
    write('Nombre: '); readln(n.nombre);
    write('Precio: '); readln(n.precio);
    write('Genero: '); readln(n.genero);
end;
procedure modificarNovela(var a:a1);
var
    n:novela; code:integer; encontre:boolean;
begin
    writeln('-- MODIFICAR NOVELA --');
    write('Ingrese codigo de novela a modificar: '); readln(code);
    encontre:=false;
    reset(a);
    while(not EOF(a)) and (not encontre) do begin
        read(a,n);
        encontre := (n.code = code);
    end;
    if encontre then begin
        leerNovela(n);
        seek(a,filepos(a)-1);
        write(a,n);
    end else
        writeln('(!) Codigo no existente.');
    close(a);
end;
procedure agregarNovela(var a:a1);
var
    n:novela;
begin
    reset(a);
    seek(a,filesize(a));
    leerNovela(n);
    write(a,n);
    close(a);
end;
procedure abrirBinario(var a:a1);
var
    opc:integer;
begin
    repeat
        writeln('1. Modificar novela');
        writeln('2. Agregar novela');
        writeln('99. X SALIR X');
        readln(opc);
        case opc of
            1: modificarNovela(a);
            2: agregarNovela(a);
            99: writeln('Programa finalizado.');
        else
            writeln('(!) ERROR: Opcion incorrecta');
        end;
    until opc = 99;
end;
var
    aN:a1;
begin
    crearBinario(aN);
    abrirBinario(aN);
end.