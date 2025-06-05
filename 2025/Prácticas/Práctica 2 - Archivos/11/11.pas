program generarArchivoHorasExtras;
const
    VALOR_ALTO = 32700;
    DIMF_CAT = 15;
type
    registroHoras = record
        departamento: integer;
        division: integer;
        nroEmpleado: integer;
        categoria: integer;
        horasExtras: integer;
    end;

    archivoHoras = file of registroHoras;

    vHorasExtras = Array[1..DIMF_CAT] of real;

//  procedure crearArchivoHorasExtras(var aH:archivoHoras);
//  var
//      r: registroHoras;
//      dep, divi, emp: integer;
//  begin
//      rewrite(aH);
//     // Crear 5 departamentos
//      for dep := 1 to 5 do
//      begin
//          // Cada departamento tiene 3 divisiones
//          for divi := 1 to 3 do
//          begin
//              // Cada división tiene 15 empleados
//              for emp := 1 to 15 do
//              begin
//                  r.departamento := dep;
//                  r.division := divi;
//                  r.nroEmpleado := emp + (divi * 100) + (dep * 1000); // Asegura orden
//                  r.categoria := 1 + random(15); // categoría entre 1 y 3
//                  r.horasExtras := 1 + random(15); // entre 1 y 15 horas extras
//                  write(aH, r);
//              end;
//          end;
//      end;

//      close(aH);
//  end;
procedure cargarHorasExtras(var v:vHorasExtras);
var
    i:integer;
    a:text;
    monto:real;
    nCat:integer;
begin
    assign(a,'horasExtras.txt');
    reset(a);
    for i := 1 to DIMF_CAT do begin
        readln(a,nCat,monto);
        v[nCat] := monto;
    end;
    close(a);
end;
procedure leer(var a:archivoHoras; var r:registroHoras);
begin
    if(not eof(a)) then
        read(a,r)
    else
        r.departamento := VALOR_ALTO;
end;
var
    aH:archivoHoras; rH:registroHoras;
    vH:vHorasExtras;
    deptoAct,divAct:integer;
    totalHorasDiv:integer; totalMontoDiv:real;
    totalHorasDepto:integer; totalMontoDepto:real;
begin
    Randomize;
    assign(aH,'horasExtras.dat');
    // crearArchivoHorasExtras(aH);
    cargarHorasExtras(vH);
    // impresión del listado:
    reset(aH);
    leer(aH,rH);
    while(rH.departamento < VALOR_ALTO) do begin
        deptoAct := rH.departamento;
        totalHorasDepto := 0;
        totalMontoDepto := 0;
        writeln('++ DEPARTAMENTO ', deptoAct);
        while(rH.departamento = deptoAct) do begin
            divAct := rH.division;
            totalHorasDiv := 0;
            totalMontoDiv := 0;
            writeln('+ Division ', divAct);
            writeln('/------------------------------------------------------\');
            writeln('| Numero de Empleado | Total de Hs. | Importe a cobrar |');
            writeln('| ------------------ | ------------ | ---------------- |');
            while(rH.departamento = deptoAct) and (rH.division = divAct) do begin
                writeln('| #',rH.nroEmpleado:17, ' |', rH.horasExtras:9, ' Hs. | $', (vH[rH.categoria] * rH.horasExtras):15:3, ' |');
                totalHorasDiv := totalHorasDiv + rH.horasExtras;
                totalMontoDiv := totalMontoDiv + vH[rH.categoria] * rH.horasExtras;
                leer(aH,rH);
            end;
            writeln('\------------------------------------------------------/');
            writeln('Total de horas de la division ', divAct,': ',totalHorasDiv);
            writeln('Monto total de la division ', divAct,': ',totalMontoDiv:0:3);
            writeln('--------------------------------------------------------');
            totalHorasDepto := totalHorasDepto + totalHorasDiv;
            totalMontoDepto := totalMontoDepto + totalMontoDiv;
        end;
        writeln('Total de horas del departamento ', deptoAct,': ',totalHorasDepto);
        writeln('Monto total del departamento ', deptoAct,': ',totalMontoDepto:0:3);
        writeln('~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-');
    end;
    close(aH);
end.
