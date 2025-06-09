{
    Una empresa dedicada a la venta de golosinas posee un archivo que contiene Información
    sobre los productos que tiene a la venta. De cada producto se registran los siguientes datos:
    código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
    La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada una de
    las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada sucursal. De
    cada venta se registra código de producto y cantidad vendida. Se debe realizar un
    procedimiento que actualice el stock en el archivo maestro con la información disponible en los
    archivos detalles y que además informe en un archivo de texto aquellos productos cuyo monto
    total vendido en el día supere los $10.000. En el archivo de texto a exportar, por cada producto
    incluido, se deben informar todos sus datos. Los datos de un producto se deben organizar en el
    archivo de texto para facilitar el uso eventual del mismo como un archivo de carga.
    El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos
    y módulos usados en el mismo.

    Notas:
        • Todos los archivos se encuentran ordenados por código de producto.
        • En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.
        • Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
        • Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la
        actualización del archivo maestro con los archivos detalles, así como la generación del
        archivo de texto solicitado.
}

program golosinas;
const
    VALOR_ALTO = 32700;
    cantDetalles = 20;
type
    producto = record
        code:integer;
        nom:string[30];
        pVenta:real;
        stockAct:integer;
        stockMin:integer;
    end;
    venta = record
        codeP:integer;
        cant:integer;
    end;

    aMaestro = file of producto;
    aDetalle = file of venta;
    vDetalles = array[1..cantDetalles] of aDetalle;
    vVentas = array[1..cantDetalles] of venta;

procedure leerMaestro(var a:aMaestro, var r:producto);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.code = VALOR_ALTO;
end;
procedure leerDetalle(var a:aDetalle, var r:producto);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.code = VALOR_ALTO;
end;
procedure minimo(var vD:vDetalles; var vV:vVentas; var min:venta);
var
    i:integer;
    pop:integer;
begin
    min.codeP := VALOR_ALTO;
    for i := 1 to cantDetalles do begin
        leerDetalle(vD[i],vV[i]);
        if(vV[i].codeP < min.codeP) then begin
            min := vV[i];
            pop := i;
        end;
    end;
    if(min.codeP <> VALOR_ALTO) then
        leerDetalle(vD[pop],vV[pop]);
end;
procedure actualizarMaestro(var aM:aMaestro; var vD:vDetalles);
var
    i:smallint;
    vV:vVentas;
    min:venta;
    stockAct:integer;
begin
    rewrite(aTXT);
    reset(aM);
    for i := 1 to cantDetalles do
        reset(vD[i]);
        
    minimo(vD,vV,min);
    while(min.code < VALOR_ALTO) do begin
        leerMaestro(aM,p);
        while(p.code <> min.codeP) do
            leerMaestro(aM,p);
        stockAct := 0;
        while(p.code = min.codeP) do begin
            stockAct := stockAct + 1;
            minimo(vD,vV,min);
        end;
        p.stockAct := p.stockAct + stockAct;
        write(aM,p);
        if(stockAct * p.pVenta > 10000) then begin
            writeln(aTXT,code);
            writeln(aTXT,nom);
            writeln(aTXT,pVenta);
            writeln(aTXT,stockAct);
            writeln(aTXT,stockMin);
        end;
    end;

    for i := 1 to cantDetalles do
        close(vD[i]);
    close(aM);
    close(aTXT);
end;

var
    i:smallint;
    iString:string[2];
    aM:aMaestro;
    vD:vDetalles;
    aTXT:text;
begin
    assign(aM,'maestro');
    // crearMaestro(aM); // se dispone
    for i := 1 to cantDetalles do begin
        Str(i,iString);
        assign(v[i], Concat('archivoDetalle_',iString));
    end;
    // recibirDetalles(vD); // se dispone
    actualizarMaestro(aM,vD,aTXT);
end.