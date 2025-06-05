program diez;
const
    VALOR_ALTO = 32700;
type
    registroVoto = record
        codProvincia: integer;
        codLocalidad: integer;
        nroMesa: integer;
        votos: integer;
    end;

    archivoVotos = file of registroVoto;

// procedure crearArchivoVotos;
// var
    // aV: archivoVotos;
    // r: registroVoto;
// begin
    // assign(aV, 'votos.dat');
    // rewrite(aV);

    // { Provincia 1, Localidad 1 }
    // r.codProvincia := 1;
    // r.codLocalidad := 1;

    // r.nroMesa := 1001; r.votos := 250; write(aV, r);
    // r.nroMesa := 1002; r.votos := 310; write(aV, r);

    // { Provincia 1, Localidad 2 }
    // r.codLocalidad := 2;

    // r.nroMesa := 2001; r.votos := 180; write(aV, r);
    // r.nroMesa := 2002; r.votos := 220; write(aV, r);
    // r.nroMesa := 2003; r.votos := 199; write(aV, r);

    // { Provincia 2, Localidad 1 }
    // r.codProvincia := 2;
    // r.codLocalidad := 1;

    // r.nroMesa := 3001; r.votos := 400; write(aV, r);

    // { Provincia 2, Localidad 2 }
    // r.codLocalidad := 2;

    // r.nroMesa := 4001; r.votos := 145; write(aV, r);
    // r.nroMesa := 4002; r.votos := 155; write(aV, r);

    // { Provincia 3, Localidad 1 - un solo registro }
    // r.codProvincia := 3;
    // r.codLocalidad := 1;

    // r.nroMesa := 5001; r.votos := 98; write(aV, r);

    // { Provincia 3, Localidad 2 }
    // r.codLocalidad := 2;

    // r.nroMesa := 6001; r.votos := 123; write(aV, r);
    // r.nroMesa := 6002; r.votos := 134; write(aV, r);
    // r.nroMesa := 6003; r.votos := 142; write(aV, r);

    // close(aV);
// end;
procedure leer(var a:archivoVotos; var r:registroVoto);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.codProvincia := VALOR_ALTO;
end;
var
    aV:archivoVotos;
    rV:registroVoto;
    totalGeneral:integer;
    provAct,locAct:integer;
    cantVotos:integer;
    cantVotosProvincia:integer;
begin
    assign(aV,'votos.dat');
    totalGeneral := 0;
    reset(aV);
    leer(aV,rV);
    while(rV.codProvincia < VALOR_ALTO) do begin
        provAct := rV.codProvincia;
        cantVotosProvincia := 0;
        writeln('Codigo de Provincia: ', provAct);
        while(rV.codProvincia = provAct) do begin
            locAct := rV.codLocalidad;
            cantVotos := 0;
            write('Codigo de Localidad: ', locAct, '        ');
            while(rV.codProvincia = provAct) and (rV.codLocalidad = locAct) do begin
                cantVotos := cantVotos + rV.votos;
                leer(aV,rV);
            end;
            writeln('Total de Votos: ', cantVotos);
            cantVotosProvincia := cantVotosProvincia + cantVotos;
        end;
        writeln('Total de Votos Provincia: ', cantVotosProvincia);
        totalGeneral := totalGeneral + cantVotosProvincia;
    end;
    writeln('Total General de Votos: ', totalGeneral);
    close(aV);
end.
