program ocho;
const VALOR_ALTO = 32700;
type
    distro = record
        nombre:string[40];
        anio_lanzamiento:integer;
        version_kernel:string[10];
        desarrolladores:integer;
        descripcion:string[100];
    end;
    archivoDistros = file of distro;
procedure leer(var a:archivoDistros; var d:distro);
begin
    if(not eof(a)) then
        read(a,d)
    else
        d.anio_lanzamiento := VALOR_ALTO;
end;
procedure cargarDistros(var a: archivoDistros);
var
    d: distro;
begin
    assign(a, 'linux.dat');
    rewrite(a);

    // Cabecera
    d.nombre := 'HEAD';
    d.anio_lanzamiento := 0;
    d.version_kernel := 'HEAD';
    d.desarrolladores := 0;
    d.descripcion := 'HEAD';
    write(a, d);

    // Distribución 1
    d.nombre := 'Ubuntu';
    d.anio_lanzamiento := 2004;
    d.version_kernel := '5.15';
    d.desarrolladores := 1000;
    d.descripcion := 'Distribución basada en Debian, muy popular entre usuarios nuevos.';
    write(a, d);

    // Distribución 2
    d.nombre := 'Debian';
    d.anio_lanzamiento := 1993;
    d.version_kernel := '5.10';
    d.desarrolladores := 1200;
    d.descripcion := 'Distribución madre de muchas otras. Muy estable.';
    write(a, d);

    // Distribución 3
    d.nombre := 'Arch Linux';
    d.anio_lanzamiento := 2002;
    d.version_kernel := '6.1';
    d.desarrolladores := 500;
    d.descripcion := 'Distribución rolling release dirigida a usuarios avanzados.';
    write(a, d);

    // Distribución 4
    d.nombre := 'Fedora';
    d.anio_lanzamiento := 2003;
    d.version_kernel := '6.2';
    d.desarrolladores := 900;
    d.descripcion := 'Distribución patrocinada por Red Hat, con tecnologías modernas.';
    write(a, d);

    // Distribución 5
    d.nombre := 'Slackware';
    d.anio_lanzamiento := 1993;
    d.version_kernel := '5.4';
    d.desarrolladores := 100;
    d.descripcion := 'Una de las distribuciones más antiguas, con configuración manual.';
    write(a, d);

    close(a);
end;
function BuscarDistribucion(var a:archivoDistros; nomDistro:string):integer;
var
    d:distro;
    encontre:boolean;
begin
    reset(a);
    leer(a,d);
    encontre := false;
    while(d.anio_lanzamiento <> VALOR_ALTO) and (not encontre) do begin
        while(d.anio_lanzamiento <> VALOR_ALTO) and (d.nombre <> nomDistro) do leer(a,d);
        if(d.anio_lanzamiento <> VALOR_ALTO) then begin
            encontre := true;
            BuscarDistribucion := filepos(a)-1;
        end;
    end;
    if(not encontre) then BuscarDistribucion := -1;
    close(a);
end;
procedure AltaDistribucion(var a:archivoDistros; distroNueva:distro);
var
    head:distro;
begin
    reset(a);
    leer(a,head);
    if(head.desarrolladores = 0) then begin
        seek(a,filesize(a));
        write(a,distroNueva);
    end else begin
        seek(a,(head.desarrolladores * -1));
        leer(a,head);
        seek(a,FilePos(a)-1);
        write(a,distroNueva);
        seek(a,0);
        write(a,head);
    end;
    writeln('Distribucion agregada.');
    close(a);
end;
procedure BajaDistribucion(var a:archivoDistros; posDistro:integer);
var
    head,d:distro;
begin
    reset(a);
    leer(a,head);
    seek(a,posDistro);
    leer(a,d);
    d.desarrolladores := posDistro * -1;
    seek(a,posDistro);
    write(a,head);
    seek(a,0);
    write(a,d);
    close(a);
    writeln('Baja de distribucion ejecutada.'); 
end;
procedure listarDistribuciones(var a: archivoDistros);
var
    d: distro;
begin
    reset(a);
    writeln('LISTADO DE DISTRIBUCIONES DE LINUX');
    writeln('-----------------------------------');
    leer(a, d);
    while not eof(a) do
    begin
        leer(a, d);
        writeln('Nombre: ', d.nombre);
        writeln('Año de lanzamiento: ', d.anio_lanzamiento);
        writeln('Versión del kernel: ', d.version_kernel);
        writeln('Cantidad de desarrolladores: ', d.desarrolladores);
        writeln('Descripción: ', d.descripcion);
        writeln('-----------------------------------');
    end;
    close(a);
end;


var
    a: archivoDistros;
    nomDistro:string[40];
    d:distro;
begin

    cargarDistros(a);
    listarDistribuciones(a);
    writeln('Archivo de distribuciones de Linux cargado correctamente.');

    write('Ingrese el nombre de una distribucion a buscar: '); readln(nomDistro);
    writeln('Posicion de la distro dentro del archivo: ', BuscarDistribucion(a,nomDistro));

    d.nombre := 'openSUSE';
    d.anio_lanzamiento := 2005;
    d.version_kernel := '6.3';
    d.desarrolladores := 700;
    d.descripcion := 'Distribución respaldada por SUSE, enfocada en estabilidad y herramientas gráficas como YaST.';
    if(BuscarDistribucion(a,d.nombre) = -1) then
        AltaDistribucion(a,d)
    else
        writeln('Ya existe la distribucion.');
    listarDistribuciones(a);

    write('Ingrese el nombre de una distribucion a eliminar: '); readln(nomDistro);
    if(BuscarDistribucion(a,nomDistro) <> -1) then
        BajaDistribucion(a,BuscarDistribucion(a,nomDistro))
    else
        writeln('Distribución no existente.');
    listarDistribuciones(a);
end.