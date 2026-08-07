{ Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez. }

program dos;
const
    MAX = 9999;
type
    alumnoMaestro = record
        code:integer;
        apellido:string;
        nombre:string;
        cantCursadas:integer;
        cantFinal:integer;
    end;
    alumnoDetalle = record
        code:integer;
        nota:integer; // final < 6 <= promociona
    end;
    aMaestro = file of alumnoMaestro;
    aDetalle = file of alumnoDetalle;
procedure leerDetalle(var aD:aDetalle; var a:alumnoDetalle);
begin
    if(not EOF(aD)) then
        read(aD,a)
    else
        a.code := MAX;
end;
procedure leerMaestro(var aM:aMaestro; var a:alumnoMaestro);
begin
    if(not EOF(aM)) then
        read(aM,a)
    else
        a.code := MAX;
end;
procedure cargarDetalle(var aD:aDetalle);
var
    a:alumnoDetalle; i:integer;
begin
    rewrite(aD);
    readln(a.code);
    for i := 1 to 20 do begin
        a.nota := Random(11);
        write(aD,a);
        readln(a.code);
    end;
    close(aD);
end;
// procedure cargarMaestro(var aM:aMaestro);
// var
//     a:alumnoMaestro; alumnoD:alumnoDetalle; aD:aDetalle;
// begin
//     rewrite(aM);
//     assign(aD,'archivoDetalle');
//     reset(aD);
//     leerDetalle(aD,alumnoD);
//     while(alumnoD.code < MAX) do begin
//         a.code := alumnoD.code;
//         a.nombre := 'Nombre';
//         a.apellido := 'Apellido';
//         a.cantCursadas := 3;
//         a.cantFinal := 3;
//         while(alumnoD.code < MAX) and (a.code = alumnoD.code) do
//             leerDetalle(aD,alumnoD);
//         write(aM,a);
//     end;
//     close(aD);
//     close(aM);
// end;
procedure actualizarMaestro(var aD:aDetalle; var aM:aMaestro);
var
    regDet:alumnoDetalle;
    regMae:alumnoMaestro;
begin
    reset(aD);
    reset(aM);
    leerDetalle(aD,regDet);
    while(regDet.code < MAX) do begin
        leerMaestro(aM,regMae);
        while(regMae.code <> regDet.code) do
            leerMaestro(aM,regMae);
        while(regMae.code < MAX) and (regMae.code = regDet.code) do begin
            case regDet.nota of
                0..5: begin 
                    regMae.cantFinal := regMae.cantFinal + 1;
                    regMae.cantCursadas := regMae.cantCursadas - 1;
                end;
                6..10: regMae.cantCursadas := regMae.cantCursadas + 1;
            end;
            leerDetalle(aD,regDet);
        end;
        seek(aM, FilePos(aM) - 1);
        write(aM,regMae);
    end;
    close(aD);
    close(aM);
end;
procedure reporteSalida(var aM:aMaestro);
var
    aTXT:text;
    regMae:alumnoMaestro;
begin
    assign(aTXT,'reporteMasFinales.txt');
    rewrite(aTXT);
    reset(aM);
    leerMaestro(aM,regMae);
    while(regMae.code < MAX) do begin
        if(regMae.cantFinal > regMae.cantCursadas) then
            write(aTXT,'|| Codigo: ',regMae.code,'; Apellido: ',regMae.apellido,'; Nombre: ',regMae.nombre,'; Cantidad de cursadas sin final: ',regMae.cantCursadas,'; Cantidad de finales aprobados: ',regMae.cantFinal,'. ');
        leerMaestro(aM,regMae);
    end;
    close(aTXT);
    close(aM);
end;
var
    aM:aMaestro;
    aD:aDetalle;
begin
    Randomize();
    assign(aM,'archivoMaestro');
    assign(aD,'archivoDetalle');
    cargarDetalle(aD);
    // cargarMaestro(aM); auxiliar
    actualizarMaestro(aD,aM);
    reporteSalida(aM);
end.