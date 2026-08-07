{ Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. }

program uno;
var
    aE:file of integer;
    nomFisico:string;
    num:integer;
begin
    writeln('Ingrese el nombre del archivo: '); readln(nomFisico);
    assign(aE,nomFisico);
    rewrite(aE); reset(aE);
    writeln('Ingrese numeros (<>30000): ');
    readln(num);
    while(num <> 30000) do begin
        write(aE,num);
        readln(num);
    end;
    close(aE);
end.