{ Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez. }

program uno;
const
    VALOR_ALTO=9999;
type
    empleado = record
        code:integer;
        nombre:string;
        comision:real;
    end;

    a1 = file of empleado;
procedure leer(var a:a1; var e:empleado);
begin
    if(not EOF(a)) then
        read(a,e)
    else
        e.code := VALOR_ALTO;
end;
// procedure cargarDetalles(var aD:a1);
// var
//     e:empleado;
// begin
//     assign(aD,'archivoDetalle');
//     rewrite(aD);
//     readln(e.code);
//     while(e.code <> -1) do begin
//         readln(e.nombre);
//         readln(e.comision);
//         write(aD,e);

//         readln(e.code);
//     end;
//     close(aD);
// end;
procedure cargarCompacto(var aD,aC:a1);
var
    eDetalle,eCompacto:empleado;
begin
    reset(aD);
    assign(aC,'archivoCompacto');
    rewrite(aC);
    leer(aD,eDetalle);
    while(eDetalle.code <> VALOR_ALTO) do begin
        eCompacto := eDetalle;
        eCompacto.comision := 0;
        while(eDetalle.code <> VALOR_ALTO) and (eCompacto.code = eDetalle.code) do begin
            eCompacto.comision := eCompacto.comision + eDetalle.comision;
            leer(aD,eDetalle);
        end;
        write(aC,eCompacto);
    end;
    close(aD);
    close(aC);
end;

procedure exportarATXT(var a:a1);
var
    aTexto:text; e:empleado;
begin
    assign(aTexto,'archivo.txt');
    rewrite(aTexto);
    reset(a);
    while(not EOF(a)) do begin
        read(a,e);
        writeln(aTexto,'Codigo: ',e.code,', Nombre: ',e.nombre,', Comision: ',e.comision:0:2);
        writeln('Codigo: ',e.code,', Nombre: ',e.nombre,', Comision: ',e.comision:0:2); // debug
    end;
    close(a); close(aTexto);
end;
var
    aDetalle:a1;
    aCompacto:a1;
begin
    // cargarDetalles(aDetalle); se dispone
    cargarCompacto(aDetalle,aCompacto);
end.