{ Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log. }

program cinco;
const
    VALOR_ALTO = 32700;
type
    registro_maestro = record
        code:integer;
        fecha:string;
        tiempo_total_de_sesiones_abiertas:integer;
    end;
    registro_detalle = record
        code:integer;
        fecha:string;
        tiempo_sesion:integer;
    end;

    archivo_maestro = file of registro_maestro;
    archivo_detalle = file of registro_detalle;

procedure leer(var a:archivo_detalle; var r:registro_detalle);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.code := VALOR_ALTO;
end;
procedure TXTaBinario(var txt:text; var a:archivo_detalle);
var
    r:registro_detalle;
begin
    rewrite(a);
    reset(txt);
    while(not eof(txt)) do begin
        with r do begin
            readln(txt,code,fecha);
            readln(txt,tiempo_sesion);
        end;
        write(a,r);
    end;
    close(a);
    close(txt);
end;
procedure minimo(var r1,r2:registro_detalle; var a1,a2:archivo_detalle; var min:registro_detalle);
begin
    if (r1.code <= r2.code) then begin
        min := r1;
        leer(a1,r1);
    end else begin
        min := r2;
        leer(a2,r2);
    end;
end;
procedure generarMaestro(var aD1,aD2:archivo_detalle; var aM:archivo_maestro);
var
    regDet1,regDet2,min:registro_detalle;
    regMae:registro_maestro;
begin
    reset(aD1);
    reset(aD2);
    rewrite(aM);
    leer(aD1,regDet1); leer(aD2,regDet2);
    minimo(regDet1,regDet2,aD1,aD2,min);
    while(min.code < VALOR_ALTO) do begin
        regMae.code := min.code;
        regMae.fecha := min.fecha;
        regMae.tiempo_total_de_sesiones_abiertas := 0;
        while(min.code < VALOR_ALTO) and (regMae.code = min.code) do begin
            regMae.tiempo_total_de_sesiones_abiertas := regMae.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
            minimo(regDet1,regDet2,aD1,aD2,min);
        end;
        write(aM,regMae);
    end;
    close(aD1);
    close(aD2);
    close(aM);
end;
procedure maestroTXT(var a:archivo_maestro);
var
    txt:text;
    r:registro_maestro;
begin
    assign(txt,'var/log/ArchivoMaestro.txt');
    rewrite(txt);
    reset(a);
    while(not eof(a)) do begin
        read(a,r);
        with r do begin
            writeln(txt,'Codigo: ',code,'; Fecha:',fecha,';');
            writeln(txt,'Tiempo conectado: ',tiempo_total_de_sesiones_abiertas,' minuto(s).');
        end;
        writeln(txt,'---------------------------------------------');
    end;
    close(txt);
    close(a);
end;

var
    aM:archivo_maestro;
    aD1:archivo_detalle;
    aD2:archivo_detalle;
    txt1:text;
    txt2:text;
begin
    assign(aD1,'archivoDetalle1.bin');
    assign(aD2,'archivoDetalle2.bin');
    assign(txt1,'archivoDetalle1.txt');
    assign(txt2,'archivoDetalle2.txt');
    TXTaBinario(txt1,aD1);
    TXTaBinario(txt2,aD2);
    writeln('Archivos cargados desde plantillas .txt.');
    assign(aM,'var/log/archivoMaestro.bin');
    generarMaestro(aD1,aD2,aM);
    writeln('Archivo maestro generado.');
    maestroTXT(aM);
    writeln('Archivo maestro exportado a .txt.');
end.