program nueve;
const
    VALOR_ALTO = 32700;
type
    persona = record
        nombre:string;
        apellido:string;
    end;
    fecha = record
        dia:smallint;
        mes:smallint;
        anio:integer;
    end;
    registroMaestro = record
        codCliente:integer;
        cliente:persona;
        fechaVenta:fecha;
        monto:real;
    end;
    archivoMaestro = file of registroMaestro;
procedure leer(var a:archivoMaestro; var r:registroMaestro);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.codCliente := VALOR_ALTO;
end;
var
    aM: archivoMaestro;
    r: registroMaestro;
    codeAct: integer;
    mesAct: smallint;
    anioAct: integer;
    montoMensualAct: real;
    montoAnual: real;
    montoTotal: real;
begin
    assign(aM, 'maestro.dat');
    reset(aM);

    leer(aM,r);
    montoTotal := 0;
    while(r.codCliente < VALOR_ALTO) do begin
        codeAct := r.codCliente;
        writeln('----- CLIENTE CÓDIGO #', r.codCliente, ' -----');
        writeln('Nombre y apellido: ', r.cliente.nombre, ' ', r.cliente.apellido);
        while(codeAct = r.codCliente) do begin
            anioAct := r.fechaVenta.anio;
            montoAnual := 0;
            while(codeAct = r.codCliente) and (anioAct = r.fechaVenta.anio) do begin
                montoMensualAct := 0;
                mesAct := r.fechaVenta.mes;
                writeln('+ TOTAL ',mesAct,'/',anioAct,':');
                while(codeAct = r.codCliente) and (anioAct = r.fechaVenta.anio) and (mesAct = r.fechaVenta.mes) do begin
                    montoMensualAct := montoMensualAct + r.monto;
                    leer(aM,r);
                end;
                montoAnual := montoAnual + montoMensualAct;
                writeln(montoMensualAct:0:3);
            end;
                writeln('++ TOTAL ',anioAct,':');
                writeln(montoAnual:0:3);
                montoTotal := montoTotal + montoAnual;
        end;
    end;
    writeln('Total obtenido por la empresa: $',montoTotal:0:3);
    close(aM);
end.