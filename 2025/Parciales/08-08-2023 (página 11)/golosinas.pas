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
procedure actualizarMaestro(var aM:aMaestro; var aD:aDetalle);
var

begin
    
end;

var
    aM:aMaestro;
    aD:aDetalle;
begin
    assign(aM,'maestro');
    // crearMaestro(aM); // se dispone
    assign(aD,'detalle');
    // recibirDetalles(aD); // se dispone
    actualizarMaestro(aM,aD);
end.