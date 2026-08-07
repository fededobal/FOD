program ocho;
const
    VALOR_ALTO = 32700;
    DIMF = 16;
type
    registroMaestro = record
        codeP:integer;
        nomP:string[30];
        cantH:longint;
        cantKHistorico:real;
    end;
    registroRelev = record
        codeP:integer;
        cantK:real;
    end;

    archivoMaestro = file of registroMaestro;
    archivoRelevamiento = file of registroRelev;

    vRelevamientos = Array[1..DIMF] of archivoRelevamiento;
    vRegDet = Array[1..DIMF] of registroRelev;

procedure recibirRelevamientos(var v:vRelevamientos); // se dispone
procedure leer(var arc:archivoRelevamiento; var r:regDet);
begin
    if(not eof(arc)) then
        read(arc,r)
    else
        r.codeP := VALOR_ALTO;
end;
procedure leerMaestro(var arc:archivoMaestro; var r:registroMaestro);
begin
    if(not eof(arc)) then
        read(arc,r)
    else
        r.codeP := VALOR_ALTO;
end;
end;
procedure minimo(var vR:vRelevamientos; var vRegDetalles:vRegDet; var min:registroRelev);
var
    minCode:integer;
    pop:integer;
begin
    minCode = VALOR_ALTO;
    for i:= 1 to DIMF do begin
        leer(vR[i],vRegDetalles[i]);
        if(vRegDetalles[i].codeP < minCode) then begin
            min := vRegDetalles[i];
            pop := i;
        end;
    end;
    leer(vR[pop],vRegDetalles[pop]);
end;
procedure actualizarMaestro(var aM:archivoMaestro; var vR:vRelevamientos);
var
    vRegDetalles:vRegDet;
    min:registroRelev;
    aux:registroMaestro;
    i:integer;
    totalK:real;
begin
    reset(aM);
    for i:= 1 to DIMF do
        reset(vR[i]);

    minimo(vR,vRegDetalles,min);
    while(min.codeP < VALOR_ALTO) do begin
        leerMaestro(aM,aux);
        while(min.codeP <> aux.codeP) do
            leerMaestro(aM,aux);
        totalK := 0;
        while(min.codeP = aux.codeP) do begin
            totalK := totalK + min.cantK;
            minimo(vR,vRegDetalles,min);
        end;
        aux.cantKHistorico := aux.cantKHistorico + totalK;
        write(aM,aux);
    end;

    for i:= 1 to DIMF do
        close(vR[i]);
    close(aM);
end;
procedure informar(var aM:archivoMaestro);
var
    r:registroMaestro;
begin
    reset(aM);
    leerMaestro(aM,r);
    while(r.codeP < VALOR_ALTO) do begin
        if(r.cantKHistorico > 10000) then
            writeln('En ', r.nomP, ' (código de provincia ' , r.codeP, ') se consumieron mas de 10 toneladas de yerba históricamente. Promedio consumido por habitante: ', r.cantKHistorico / r.cantH);
        leerMaestro(aM,r);
    end;
    close(aM);
end;
var
    aM:archivoMaestro;
    vR:vRelevamientos;
begin
    recibirRelevamientos(vR);
    actualizarMaestro(aM,vR);
    informar(aM);
end.