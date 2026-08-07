{ Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
    1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
    2. Idem anterior para los recuperados.
    3. Los casos activos se actualizan con el valor recibido en el detalle.
    4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas). }

program seis;
const
    VALOR_ALTO = 32000;
    DIMF = 10;
type
    registroDetalle = record
        codeLoc:integer;
        codeCepa:integer;
        cantCasosActivos:integer;
        cantCasosNuevos:integer;
        cantCasosRecuperados:integer;
        cantCasosFallecidos:integer;
    end;
    registroMaestro = record
        codeLoc:integer;
        nombreLoc:string[30];
        codeCepa:integer;
        nombreCepa:string[30];
        cantCasosActivos:integer;
        cantCasosNuevos:integer;
        cantCasosRecuperados:integer;
        cantCasosFallecidos:integer;
    end;

    archivoDetalle = file of registroDetalle;
    archivoMaestro = file of registroMaestro;

    vDetalles = Array[1..DIMF] of archivoDetalle;
    vRegDet = Array[1..DIMF] of registroDetalle;

procedure leerDetalle(var a:archivoDetalle; var r:registroDetalle);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.codeLoc := VALOR_ALTO;
end;
procedure cargarDetalle(var a:archivoDetalle);
var
    i:integer;
    r:registroDetalle;
    randomPropio:integer;
begin
    reset(a);
    randomPropio := Random(10000) + 1;
    for i := 1 to Random(20)+1 do begin
        r.codeLoc := i + randomPropio;
        r.codeCepa := i;
        r.cantCasosActivos := Random(150);
        r.cantCasosNuevos := r.cantCasosActivos DIV 3;
        r.cantCasosRecuperados := Random(500);
        r.cantCasosFallecidos := Random(500);
        write(a,r);
    end;
    close(a);
end;
procedure recibirDetalles(var v:vDetalles);
var
    i:smallint;
    iString:string[2];
begin
    for i := 1 to DIMF do begin
        Str(i,iString);
        assign(v[i], Concat('archivoDetalle_',iString));
        rewrite(v[i]);
        cargarDetalle(v[i]);
    end;
end;
procedure imprimirDetalles(var v:vDetalles);
var
    i:smallint;
    r:registroDetalle;
begin
    for i := 1 to DIMF do begin
        reset(v[i]);
        writeln('---------- ARCHIVO DETALLE #', i, ' ----------');
        leerDetalle(v[i], r);
        while(r.codeLoc < VALOR_ALTO) do begin
            with r do begin
                writeln('|| Codigo de localidad: ', codeLoc, '; Codigo de cepa: ', codeCepa, ' ||');
                writeln('      Recuento de casos...');
                writeln('         Nuevos: ', cantCasosNuevos);
                writeln('         Activos: ', cantCasosActivos);
                writeln('         Recuperados: ', cantCasosRecuperados);
                writeln('         Fallecidos: ', cantCasosFallecidos);
            end;
            writeln('----------------------------------------------------------');
            leerDetalle(v[i], r);
        end;
        close(v[i]);
    end;
end;
procedure minimo(var vD:vDetalles; var vRD:vRegDet; var minReg:registroDetalle);
var
    i:smallint;
    minLoc:integer;
    popMin:smallint;
    minCepa:integer;
begin
    minLoc := VALOR_ALTO;
    minCepa := VALOR_ALTO;

    for i := 1 to DIMF do begin
        if(vRD[i].codeLoc < minLoc) then begin
            minReg := vRD[i];
            popMin:=i;
        end else
        if(vRD[i].codeCepa <= minCepa) then begin
            minReg := vRD[i];
            popMin := i;
        end;
    end;

    leerDetalle(vD[popMin],vRD[popMin]);
end;
procedure cargarMaestro(var vD:vDetalles; var aM:archivoMaestro);
var
    i:smallint;
    vRD:vRegDet;
    regDet:registroDetalle;
    regMae:registroMaestro;
begin
    rewrite(aM);
    for i := 1 to DIMF do begin
        reset(vD[i]);
        leerDetalle(vD[i],vRD[i]);
    end;
    minimo(vD,vRD,regDet);
    while(regDet.codeLoc < VALOR_ALTO) do begin
        regMae.codeLoc := regDet.codeLoc;
        regMae.codeCepa := regDet.codeCepa;
        regMae.nombreLoc := 'Localidad';
        regMae.nombreCepa := 'Cepa';
        regMae.cantCasosActivos := regDet.cantCasosActivos;
        regMae.cantCasosFallecidos := regDet.cantCasosFallecidos;
        regMae.cantCasosNuevos := regDet.cantCasosNuevos;
        regMae.cantCasosRecuperados := regDet.cantCasosRecuperados;
        write(aM,regMae);
        minimo(vD,vRD,regDet);
        while(regDet.codeLoc = regMae.codeLoc) and (regDet.codeCepa = regMae.codeCepa) do begin
            regMae.cantCasosActivos := regDet.cantCasosActivos;
            regMae.cantCasosNuevos := regDet.cantCasosNuevos;
            regMae.cantCasosFallecidos := regMae.cantCasosFallecidos + regDet.cantCasosFallecidos;
            regMae.cantCasosRecuperados := regMae.cantCasosRecuperados + regDet.cantCasosRecuperados;
            minimo(vD,vRD,regDet);
        end;
    end;
    for i := 1 to DIMF do
        close(vD[i]);
    close(aM);
end;
procedure actualizarMaestro(var vD:vDetalles; var aM:archivoMaestro);
var
    i:smallint;
    vRD:vRegDet;
    regDet:registroDetalle;
    regMae:registroMaestro;
begin
    reset(aM);
    for i := 1 to DIMF do begin
        reset(vD[i]);
        leerDetalle(vD[i],vRD[i]);
    end;
    minimo(vD,vRD,regDet);
    while(regDet.codeLoc < VALOR_ALTO) do begin
        regMae.codeLoc := regDet.codeLoc;
        regMae.codeCepa := regDet.codeCepa;
        regMae.nombreLoc := 'Localidad';
        regMae.nombreCepa := 'Cepa';
        while(regDet.codeLoc <> regMae.codeLoc) and (regDet.codeCepa <> regMae.codeCepa) do
            minimo(vD,vRD,regDet);
        while(regDet.codeLoc = regMae.codeLoc) and (regDet.codeCepa = regMae.codeCepa) do begin
            regMae.cantCasosActivos := regDet.cantCasosActivos;
            regMae.cantCasosNuevos := regDet.cantCasosNuevos;
            regMae.cantCasosFallecidos := regMae.cantCasosFallecidos + regDet.cantCasosFallecidos;
            regMae.cantCasosRecuperados := regMae.cantCasosRecuperados + regDet.cantCasosRecuperados;
            minimo(vD,vRD,regDet);
        end;
        write(aM,regMae);
    end;
    for i := 1 to DIMF do
        close(vD[i]);
    close(aM);
end;
procedure maestroTXT(var a:archivoMaestro; var cantCA50:integer);
var
    aTXT:text;
    r:registroMaestro;
begin
    assign(aTXT,'archivoMaestro.txt');
    rewrite(aTXT);

    reset(a);
    while(not eof(a)) do begin
        read(a,r);
        with r do begin
            writeln(aTXT, '|| Codigo de localidad: ', codeLoc, '; Nombre de localidad: ', nombreLoc, ' ||');
            writeln(aTXT, '|| Codigo de cepa: ', codeCepa, '; Nombre de cepa: ', nombreCepa, ' ||');
            writeln(aTXT, '      Recuento de casos...');
            writeln(aTXT, '         Nuevos: ', cantCasosNuevos);
            writeln(aTXT, '         Activos: ', cantCasosActivos);
            writeln(aTXT, '         Recuperados: ', cantCasosRecuperados);
            writeln(aTXT, '         Fallecidos: ', cantCasosFallecidos);

            if(cantCasosActivos > 50) then
                cantCA50 := cantCA50 + 1;
        end;
        writeln(aTXT, '----------------------------------------------------------');
    end;
    close(a);
    close(aTXT);
end;

var
    aM:archivoMaestro;
    vD: vDetalles;
    cantCA50:integer;
begin
    Randomize;
    recibirDetalles(vD);
    imprimirDetalles(vD);

    assign(aM,'archivoMaestro');
    // cargarMaestro(vD,aM);
    actualizarMaestro(vD,aM);
    cantCA50 := 0;
    maestroTXT(aM,cantCA50);
    writeln('Cantidad de localidades con mas de 50 casos activos: ', cantCA50);
end.