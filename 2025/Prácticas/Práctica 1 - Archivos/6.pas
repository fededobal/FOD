{ Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular. }

program seis;
type
    celular = record
        code: integer;
        nombre: string;
        desc: string;
        marca: string;
        precio: real;
        stockMin: integer;
        stockAct: integer;
    end;
    
    a1 = file of celular;

procedure asignarBin(var a: a1);
var
    aFisico: string;
begin
    write('Ingrese nombre del archivo binario: ');
    readln(aFisico);
    assign(a, aFisico);
end;

procedure nuevoArchivo(var a: a1);
var
    aTXT: text;
    c: celular;
    nomBIN, nomTXT: string;
begin
    writeln('-- NUEVO ARCHIVO --');
    write('Archivo .txt para extraer informacion: ');
    readln(nomTXT);
    assign(aTXT, nomTXT);
    
    write('Nombre del nuevo archivo: ');
    readln(nomBIN);
    assign(a, nomBIN);
    
    rewrite(a);
    reset(aTXT);
    
    while not EOF(aTXT) do begin
        with c do begin
            readln(aTXT, code, precio, marca);
            readln(aTXT, stockAct, stockMin, desc);
            readln(aTXT, nombre);
        end;
        write(a, c);
    end;
    
    close(a);
    close(aTXT);
    writeln('(!) Archivo binario creado.');
end;

procedure informarCelular(c: celular);
begin
    writeln('Codigo: ', c.code);
    writeln('Nombre: ', c.nombre);
    writeln('Descripcion: ', c.desc);
    writeln('Marca: ', c.marca);
    writeln('Precio: ', c.precio:0:2);
    writeln('Stock minimo: ', c.stockMin, '; Stock actual: ', c.stockAct);
end;

procedure listarStockMin(var a: a1);
var
    c: celular;
    nomBIN: string;
begin
    writeln('-- LISTADO DE CELULARES CON STOCK MENOR AL MINIMO --');
    write('Nombre del archivo: ');
    readln(nomBIN);
    assign(a, nomBIN);
    reset(a);
    
    while not EOF(a) do begin
        read(a, c);
        if c.stockAct < c.stockMin then
            informarCelular(c);
    end;
end;

procedure listarDesc(var a: a1);
var
    c: celular;
    descr: string;
begin
    writeln('-- LISTADO DE CELULARES CON DESCRIPCION DETERMINADA --');
    asignarBin(a);
    reset(a);
    
    write('Ingrese una descripcion: ');
    readln(descr);
    
    while not EOF(a) do begin
        read(a, c);
        if c.desc = descr then
            informarCelular(c);
    end;
end;

procedure exportarTXT(var a: a1);
var
    nomTXT: string;
    aTXT: text;
    c: celular;
begin
    writeln('-- EXPORTAR A TXT --');
    asignarBin(a);
    reset(a);
    
    write('Nombre del archivo nuevo .txt: ');
    readln(nomTXT);
    assign(aTXT, nomTXT);
    rewrite(aTXT);
    
    while not EOF(a) do begin
        read(a, c);
        with c do begin
            writeln(aTXT, code, ' ', precio:0:2, marca);
            writeln(aTXT, stockAct, ' ', stockMin, desc);
            writeln(aTXT, nombre);
        end;
    end;
    
    close(aTXT);
    close(a);
    writeln('(!) Archivo .txt creado.');
end;

procedure leerCelular(var c: celular);
begin
    write('Codigo: ');
    readln(c.code);
    
    if c.code <> -1 then begin
        write('Nombre: ');
        readln(c.nombre);
        
        write('Descripcion: ');
        readln(c.desc);
        c.desc := ' ' + c.desc;
        
        write('Marca: ');
        readln(c.marca);
        c.marca := ' ' + c.marca;
        
        write('Precio: ');
        readln(c.precio);
        
        write('Stock minimo: ');
        readln(c.stockMin);
        
        write('Stock actual: ');
        readln(c.stockAct);
    end;
end;

procedure agregarAlFinal(var a: a1);
var
    c: celular;
begin
    writeln('-- AÑADIR CELULAR AL FINAL --');
    asignarBin(a);
    reset(a);
    seek(a, filesize(a));
    leerCelular(c);
    while(c.code <> -1) do begin
        write(a, c);
        leerCelular(c);
    end;
    
    close(a);
end;

procedure modificarStock(var a: a1);
var
    code: integer;
    encontre: boolean;
    c: celular;
begin
    writeln('-- MODIFICAR STOCK --');
    asignarBin(a);
    reset(a);
    
    write('Ingrese el codigo del celular a modificar: ');
    readln(code);
    
    encontre := false;
    while not EOF(a) and not encontre do begin
        read(a, c);
        encontre := c.code = code;
    end;
    
    if encontre then begin
        writeln('STOCK ACTUAL: ', c.stockAct);
        write('NUEVO STOCK ACTUAL: ');
        readln(c.stockAct);
        seek(a, filepos(a) - 1);
        write(a, c);
    end else
        writeln('(!) ERROR: Celular no encontrado.');
    
    close(a);
end;

procedure exportarSinStockTXT(var a: a1);
var
    aTXT: text;
    c: celular;
begin
    asignarBin(a);
    reset(a);
    assign(aTXT, 'SinStock.txt');
    rewrite(aTXT);
    
    while not EOF(a) do begin
        read(a, c);
        if c.stockAct = 0 then
            with c do begin
                writeln(aTXT, code, ' ', precio:0:2, marca);
                writeln(aTXT, stockAct, ' ', stockMin, desc);
                writeln(aTXT, nombre);
            end;
    end;
    
    close(a);
    close(aTXT);
end;

procedure menuPrincipal(var aC: a1);
var
    opc: integer;
begin
    writeln('----- MENU DE OPCIONES -----');
    repeat
        writeln('1. Nuevo archivo a partir de .txt existente');
        writeln('2. Listar celulares con stock menor al minimo');
        writeln('3. Listar celulares con descripcion determinada');
        writeln('4. Exportar archivo a .txt');
        writeln('5. Añadir celulares al final del archivo');
        writeln('6. Modificar stock de un celular');
        writeln('7. Exportar celulares sin stock a .txt');
        writeln('99. X SALIR X');
        readln(opc);
        case opc of
            1: nuevoArchivo(aC);
            2: listarStockMin(aC);
            3: listarDesc(aC);
            4: exportarTXT(aC);
            5: agregarAlFinal(aC);
            6: modificarStock(aC);
            7: exportarSinStockTXT(aC);
            99: writeln('Programa finalizado.');
        else
            writeln('(!) ERROR: Opcion incorrecta');
        end;
    until opc = 99;
end;

var
    aC: a1;
begin

    menuPrincipal(aC);
end.
