program uno;
type
    producto = record
        code:integer;
        nom:string[50];
        pVenta:real;
        stockAct:integer;
        stockMin:integer;
    end;
    aMaestro = file of producto;

    venta = record
        codeP:integer;
        cant:integer;
    end;
    aDetalle = file of venta;

var

begin
    
end.