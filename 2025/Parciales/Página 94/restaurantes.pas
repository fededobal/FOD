program restaurantes;
const
    VALOR_ALTO = 32700;
    CANTDET = 3;
type
    regMae = record
        codeP:integer;
        nom:string[20];
        desc:string[50];
        codeB:string;
        cat:string[20];
        stockAct:integer;
        stockMin:integer;
    end;
    aMaestro = file of regMae;

    regDet = record
        codeP:integer;
        cant:integer;
        breveDesc:string[20];
    end;
    aDetalle = file of regDet;
    vDetalles = array[1..CANTDET] of aDetalle;
    vRegDet = array[1..CANTDET] of regDet;

procedure minimo(var vD:vDetalles; var vR:vRegDet; var min:regDet);
var
    i,pop:integer;
begin
    min.codeP := VALOR_ALTO;
    for i := 1 to CANTDET do begin
        if(vR[i].codeP < min.codeP) then begin
            pop := i;
            min := vR[i];
        end;
    end;
    if(min.codeP <> VALOR_ALTO) then
        leerDetalle(vD[pop],vR[pop]);
end;
procedure evaluarInforme(rM:regMae);
begin
    if(rM.stockAct < rM.stockMin) then
        writeln('(!) El producto #',rM.codeP,' de la categoría ',rM.cat,' posee stock actual POR DEBAJO del stock mínimo.');
end;
procedure actualizarMaestro(var aM:aMaestro; var vD:vDetalles);
var
    vR:vRegDet;
    rM:regMae;
begin
    reset(aM);
    for i := 1 to CANTDET do begin
        reset(vD[i]);
        leerDetalle(vD[i],vR[i]);
    end;

    minimo(vD,vR,min);
    while(min.codeP <> VALOR_ALTO) do begin
        leerMaestro(aM,rM);
        while(min.codeP <> rM.codeP) do
            leerMaestro(aM,rM);
        while(min.codeP = rM.codeP) do begin
            if(rM.stockAct - min.cant < 1) then begin
                writeln('(!) El pedido del producto #',min.codeP,' no pudo satisfacerse en su totalidad por falta de stock.');
                writeln('    ~ Diferencia que no pudo ser enviada al restaurante: ', min.cant - rM.stockAct);
                min.cant := min.cant - rM.stockAct;
            end;
            rM.stockAct := rM.stockAct - min.cant;
            minimo(vD,vR,min);
        end;
        seek(aM,filepos(aM)-1);
        write(aM,rM);
        evaluarInforme(rM);
    end;

    close(aM);
    for i := 1 to CANTDET do
        close(vD[i]);
end;
var
    aM:aMaestro;
    vD:vDetalles;
    nomDet:string;
begin
    // se dispone por precondición:
    for i := 1 to CANTDET do begin
        readln(nomDet);
        assign(vD[i],nomDet);
    end;
    cargarDetalles(vD); 
    assign(aM,'maestro');
    cargarMaestro(aM);
    // consigna:
    actualizarMaestro(aM,vD);
end.