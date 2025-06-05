program siete;
type
    ave = record
        codigo: integer;
        nombre: string[40];
        familia: string[40];
        descripcion: string[100];
        zona_geografica: string[40];
    end;

    archivoAves = file of ave;

procedure cargarAves(var a: archivoAves);
var
    p: ave;
begin
    assign(a, 'aves.dat');
    rewrite(a);

    // Ave 1
    p.codigo := 1;
    p.nombre := 'Cóndor Andino';
    p.familia := 'Cathartidae';
    p.descripcion := 'Ave carroñera que habita los Andes';
    p.zona_geografica := 'Cordillera de los Andes';
    write(a, p);

    // Ave 2
    p.codigo := 2;
    p.nombre := 'Águila Arpía';
    p.familia := 'Accipitridae';
    p.descripcion := 'Ave rapaz tropical muy poderosa';
    p.zona_geografica := 'Selva Amazónica';
    write(a, p);

    // Ave 3
    p.codigo := 3;
    p.nombre := 'Macá Tobiano';
    p.familia := 'Podicipedidae';
    p.descripcion := 'Ave acuática de la Patagonia';
    p.zona_geografica := 'Santa Cruz, Argentina';
    write(a, p);

    close(a);
end;
procedure marcarExtinta(var a:archivoAves; code:integer);
var
    encontre:boolean;
    av:ave;
begin
    reset(a);
    encontre := false;
    while(not eof(a) and not encontre) do begin
        read(a,av);
        if(av.codigo = code) then begin
            encontre := true;
            av.descripcion := 'EXTINTA';
            seek(a,filepos(a)-1);
            write(a,av);
        end;
    end;
    if(encontre) then writeln('Ave extinguida correctamente.')
    else writeln('Ave no encontrada.');
    close(a);
end;
procedure compactarArchivo(var a:archivoAves);
var
    avAct,avFinal:ave;
    posAct:integer;
    marcaBaja:string[100];
    posTruncate:integer;
begin
    reset(a);
    posTruncate := filesize(a);
    marcaBaja := 'EXTINTA';
    while(not eof(a)) do begin
        read(a,avAct);
        while(not eof(a)) and (avAct.descripcion <> marcaBaja) do
            read(a,avAct);
        if(avAct.descripcion = marcaBaja) then begin
            posAct := filepos(a)-1;

            seek(a,filesize(a)-1);
            read(a,avFinal);
            while(avFinal.descripcion = marcaBaja) do begin
                seek(a,filepos(a)-2);
                read(a,avFinal);
            end;
            posTruncate := filepos(a)-1;
            seek(a,posAct);
            write(a,avFinal);
        end;
    end;
    seek(a,posTruncate);
    truncate(a);
    close(a);
end;
procedure listarAves(var a: archivoAves);
var
    av: ave;
begin
    reset(a);
    writeln('LISTADO DE AVES');
    writeln('-------------------------------');
    while not eof(a) do
    begin
        read(a, av);
        writeln('Código: ', av.codigo);
        writeln('Nombre: ', av.nombre);
        writeln('Familia: ', av.familia);
        writeln('Descripción: ', av.descripcion);
        writeln('Zona Geográfica: ', av.zona_geografica);
        writeln('-------------------------------');
    end;
    close(a);
end;

var
    a:archivoAves;
    codeAveExtint:integer;
begin
    cargarAves(a);
    listarAves(a);
    write('Ingrese codigo de ave a extinguir: '); readln(codeAveExtint);
    marcarExtinta(a,codeAveExtint);
    listarAves(a);
    compactarArchivo(a);
    listarAves(a);
end.