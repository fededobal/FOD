{ Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto. }

program tres;
const
    VALOR_ALTO = 32700;
type
    registro_maestro = record
        code:integer;
        nombre:string[30];
        descripcion:string;
        stockDisponible:integer;
        stockMinimo:integer;
        precio:real;
    end;
    registro_detalle = record
        code:integer;
        cantVendida:integer;
    end;

    archivo_maestro = file of registro_maestro;
    archivo_detalle = file of registro_detalle;

procedure leerMaestro(var a:archivo_maestro; var r:registro_maestro);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.code := VALOR_ALTO;
end;
procedure leerDetalle(var a:archivo_detalle; var r:registro_detalle);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.code := VALOR_ALTO;
end;
procedure TXTaBinarios(var aM:archivo_maestro; var aD:archivo_detalle);
    procedure cargarMaestro(var a:archivo_maestro; var txt:text);
    var
        r:registro_maestro;
    begin
        rewrite(a);
        reset(txt);
        while(not eof(txt)) do begin
            with r do begin
                readln(txt,code,stockDisponible,stockMinimo,precio,nombre);
                readln(txt,descripcion);
            end;
            write(a,r);
        end;
        close(a);
        close(txt);
    end;
    procedure cargarDetalle(var a:archivo_detalle; var txt:text);
    var
        r:registro_detalle;
    begin
        rewrite(a);
        reset(txt);
        while(not eof(txt)) do begin
            with r do readln(txt,code,cantVendida);
            write(a,r);
        end;
        close(a);
        close(txt);
    end;
var
    txt:text;
begin
    assign(aM,'archivoMaestro.bin');
    assign(txt,'archivoMaestro.txt');
    cargarMaestro(aM,txt);

    assign(aD,'archivoDetalle.bin');
    assign(txt,'archivoDetalle.txt');
    cargarDetalle(aD,txt);
end;
procedure actualizarMaestro(var aM:archivo_maestro; var aD:archivo_detalle);
var
    regMae:registro_maestro;
    regDet:registro_detalle;
begin
    reset(aD);
    reset(aM);
    leerDetalle(aD,regDet);
    while(regDet.code < VALOR_ALTO) do begin
        leerMaestro(aM,regMae);
        while(regMae.code <> regDet.code) do
            leerMaestro(aM,regMae);
        while(regMae.code = regDet.code) do begin
            regMae.stockDisponible := regMae.stockDisponible - regDet.cantVendida;
            { Este algoritmo no se hace cargo del stock negativo.
            El archivo maestro debe reflejar la realidad de las ventas. }
            leerDetalle(aD,regdet);
        end;
        seek(aM,filepos(aM)-1);
        write(aM,regMae);
    end;
    close(aD);
    close(aM);
end;
procedure informarTXT(var aM:archivo_maestro);
var
    r:registro_maestro;
    txt:text;
begin
    assign(txt,'ProductosConStockMinimo.txt');
    rewrite(txt);
    writeln(txt,'----- PRODUCTOS CON STOCK MENOR AL STOCK MÍNIMO -----');
    reset(aM);
    leerMaestro(aM,r);
    while(r.code < VALOR_ALTO) do begin
        if(r.stockDisponible < r.stockMinimo) then
            with r do begin
                writeln(txt,nombre);
                writeln(txt,descripcion);
                writeln(txt,'Stock disponible: ',stockDisponible,'; Precio: ',precio:0:2);
            end;
        writeln(txt,'---------------------------------------------');
        leerMaestro(aM,r);
    end;
    close(txt);
    close(aM);
end;

var
    aM:archivo_maestro;
    aD:archivo_detalle;
begin
    TXTaBinarios(aM,aD);
    writeln('Archivos cargados desde plantillas .txt.');
    actualizarMaestro(aM,aD);
    writeln('Archivo maestro actualizado.');
    informarTXT(aM);
    writeln('Reporte creado exitosamente.');
end.