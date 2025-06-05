program novelas;
const
    VALOR_ALTO = 32700;
type
    novela = record
        code:integer;
        genero:string;
        nombre:string;
        duracion:double;
        director:string;
        precio:double;
    end;
    archNovelas = file of novela;

procedure leer(var a:archNovelas; var n:novela);
begin
    if(not eof(a)) then
        read(a,n)
    else
        n.code := VALOR_ALTO;
end;
procedure leerReg(var n:novela);
begin
    writeln('----- INGRESAR NOVELA -----');
    write('Codigo: '); readln(n.code);
    if(n.code <> -1) then begin
        write('Genero: '); readln(n.genero);
        write('Nombre: '); readln(n.nombre);
        write('Duracion: '); readln(n.duracion);
        write('Director: '); readln(n.director);
        write('Precio: '); readln(n.precio);
    end;
end;
procedure CargarNovelas(var a:archNovelas);
var
    n:novela;
begin
    rewrite(a);
    n.code := 0;
    n.duracion := 0;
    n.precio := 0;
    n.nombre := '';
    n.genero := '';
    n.director := '';
    write(a,n);
    leerReg(n);
    while(n.code <> -1) do begin
        write(a,n);
        leerReg(n);
    end;
    close(a);
end;
procedure AgregarNovela(var a:archNovelas);
var
    n,head:novela;
begin
    reset(a);
    leer(a,head);
    writeln(head.code);
    if(head.code = 0) then begin
        seek(a,FileSize(a));
        leerReg(n);
        write(a,n);
    end else begin
        seek(a, head.code * (-1));
        leer(a, head);
        seek(a, FilePos(a)-1);
        leerReg(n);
        write(a, n);
        seek(a, 0);
        write(a,head);
    end;
    
    close(a);
end;
procedure ModificarNovela(var a:archNovelas);
var
    nAct,nNue:novela;
    seguir:boolean;
begin
    leerReg(nNue);
    reset(a);
    leer(a,nAct);
    seguir := true;
    while(nAct.code <> VALOR_ALTO) and (seguir) do begin
        if(nAct.code = nNue.code) then begin
            write(a,nNue);
            seguir := false;
        end else
            leer(a,nAct);
    end;
    close(a);
end;
procedure BajaNovela(var a:archNovelas);
var
    nAct,head:novela;
    codeDel:integer;
    seguir:boolean;
begin
    write('Codigo de novela a eliminar: '); readln(codeDel);
    reset(a);
    seguir := true;
    leer(a,head);
    leer(a,nAct);
    while(nAct.code <> VALOR_ALTO) and (seguir) do begin
        if(nAct.code = codeDel) then begin
            seek(a,filepos(a)-1);
            write(a,head);
            nAct.code := nAct.code * -1;
            seguir := false;
        end else
            leer(a,nAct);
    end;
    if(not seguir) then begin
        seek(a,0);
        write(a,nAct);
    end;
    close(a);
end;
procedure exportarTXT(var a: archNovelas);
var
    txt: text;
    n: novela;
begin
    reset(a);
    seek(a, 1);
    assign(txt, 'novelas.txt');
    rewrite(txt);
    while(not eof(a)) do
        begin
            read(a, n);
            if(n.code <= 0) then
                write(txt, 'Novela bajada:');
            write(txt, 'Codigo=', n.code, ' Genero=', n.genero, ' Nombre=', n.nombre, ' Duracion=', n.duracion:0:2, ' Director=', n.director, ' Precio=', n.precio:0:2);
            writeln(txt,'');
        end;
    close(a);
    close(txt);
end;
var
    a:archNovelas;
begin
    assign(a,'archNovelas');
    CargarNovelas(a);
    AgregarNovela(a);
    ModificarNovela(a);
    BajaNovela(a);
    ExportarTXT(a);
end.