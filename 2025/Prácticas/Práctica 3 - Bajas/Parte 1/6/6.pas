program seis;
type
    prenda = record
        cod_prenda:integer;
        descripcion:string[40];
        colores:string[40];
        tipo_prenda:string[40];
        stock:integer;
        precio_unitario:double;
    end;
    archivoPrendas = file of prenda;

procedure cargarPrendasMaestro(var a: archivoPrendas);
var
    p: prenda;
begin
    assign(a, 'archivoPrendasMaestro.dat');
    rewrite(a);

    // Prenda 1
    p.cod_prenda := 1001;
    p.descripcion := 'Remera estampada';
    p.colores := 'Rojo, Azul, Verde';
    p.tipo_prenda := 'Remera';
    p.stock := 50;
    p.precio_unitario := 4999.99;
    write(a, p);

    // Prenda 2
    p.cod_prenda := 1002;
    p.descripcion := 'Jean clásico';
    p.colores := 'Azul oscuro';
    p.tipo_prenda := 'Pantalón';
    p.stock := 30;
    p.precio_unitario := 10999.50;
    write(a, p);

    // Prenda 3
    p.cod_prenda := 1003;
    p.descripcion := 'Campera impermeable';
    p.colores := 'Negro, Gris';
    p.tipo_prenda := 'Campera';
    p.stock := 20;
    p.precio_unitario := 18999.00;
    write(a, p);

    close(a);
end;
procedure cargarPrendasDetalle(var a: archivoPrendas);
var
    p: prenda;
begin
    assign(a, 'archivoPrendasDetalle.dat');
    rewrite(a);

    // Prenda obsoleta
    p.cod_prenda := 1001;
    p.descripcion := 'Remera estampada';
    p.colores := 'Rojo, Azul, Verde';
    p.tipo_prenda := 'Remera';
    p.stock := 50;
    p.precio_unitario := 4999.99;
    write(a, p);

    close(a);
end;
procedure bajasLogicas(var aM,aD:archivoPrendas);
var
    pD,pM:prenda;
begin
    reset(aM);
    reset(aD);

    while(not eof(aD)) do begin
        read(aD,pD);
        read(aM,pM);
        while(pM.cod_prenda <> pD.cod_prenda) do
            read(aM,pM);
        seek(aM,filepos(aM)-1);
        pD.stock := pD.stock * -1;
        write(aM,pD);
        seek(aM,0);
    end;

    close(aM);
    close(aD);
end;
procedure bajaFisica(var aM:archivoPrendas);
var
    p:prenda;
    arcNuevo:file of prenda;
begin
    assign(arcNuevo,'arcNuevo.dat');
    rewrite(arcNuevo);
    reset(aM);
    while(not eof(aM)) do begin
        read(aM,p);
        if(p.stock >= 0) then write(arcNuevo,p);
    end;
    close(aM);
    erase(aM);
    close(arcNuevo);
    rename(arcNuevo,'archivoPrendasMaestro.dat');
end;

var
    aMaestro,aDetalle:archivoPrendas;
begin
    cargarPrendasMaestro(aMaestro);
    cargarPrendasDetalle(aDetalle);
    bajasLogicas(aMaestro,aDetalle);
    bajaFisica(aMaestro);
end.