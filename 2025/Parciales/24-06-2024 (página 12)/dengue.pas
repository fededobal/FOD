program dengue;
const
    VALOR_ALTO = 32700;
    DIMF = 30;
type
    regMae = record
        code:integer;
        nom:string[50];
        cantPos:integer;
    end;
    aMaestro = file of regMae;

    regDet = record
        code:integer;
        cantPos:integer;
    end;
    aDetalle = file of regDet;
    vDetalles = array[1..DIMF] of aDetalle;
    vRegDet = array[1..DIMF] of regDet;

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
procedure minimo(var vD:vDetalles; var vR:vRegDet; var min:regDet);
var
    i:integer;
    pop:integer;
begin
    min.code := VALOR_ALTO;
    for i := 1 to DIMF do begin
        if(vR[i].code < min.code) then begin
            pop := i;
            min := vR[i];
        end;
    end;
    if(min.code <> VALOR_ALTO) then
        leerDetalle(vD[pop],vR[pop]);
end;
procedure actualizarMaestro(var aM:aMaestro; var vD:vDetalles);
var
    vR:vRegDet;
    min:regDet;
    rM:regMae;
    positivos:integer;
    i:integer;
begin
    reset(aM);
    for i := 1 to DIMF do begin
        reset(vD[i]);
        leerDetalle(vD[i],vR[i]);
    end;

    minimo(vD,vR,min);
    while(min.code <> VALOR_ALTO) do begin
        leerMaestro(aM,rM);
        while(rM.code <> min.code) do
            leerMaestro(aM,rM);
        positivos := 0;
        while(rM.code = min.code) do begin
            positivos := positivos + min.cantPos;
            minimo(vD,vR,min);
        end;
        rM.cantPos := rM.cantPos + positivos;
        seek(aM,filepos(aM)-1);
        write(aM,rM);
        if(rM.cantPos > 15) then
            writeln('- MUNICIPIO CON MAS DE 15 POSITIVOS: Codigo: ',rM.code, ', Nombre: ',rM.nom);
    end;

    for i := 1 to DIMF do
        close(vD[i]);
    close(aM);
end;
var
    vD:vDetalles;
    nomMae:string[20];
    aM:aMaestro;
begin
    // recibirDetalles(vD); se dispone; crea y carga los detalles.
    readln(nomMae);
    assign(aM,nomMae);
    // primeraCargaMaestro(aM); se dispone; crea y carga el maestro.
    actualizarMaestro(aM,vD);
end.