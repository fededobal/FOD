program cinco;
const
    DEL = 50;
type
    direccion = record
        calle:string;
        nro:integer;
        piso:integer;
        depto:char;
        ciudad:string;
    end;
    tutorLegal = record
        nom:string[20];
        ap:string[20];
        dni:longint;
    end;

    nacimiento = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[20];
        dir:direccion;
        matriculaMed:string[10];
        madre,padre:tutorLegal;
    end;
    fallecimiento = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[20];
        dni:longint;
        matriculaMed:string[10];
        lugar:direccion;
        fecha:string[10];
        hora:string[5];
    end;

    registroMaestro = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[20];
        dir:direccion;
        matriculaMedNac:string[10];
        madre,padre:tutorLegal;
        fallecido:boolean;
        matriculaMedFac:string[10];
        lugar:direccion;
        fecha:string[10];
        hora:string[5];
    end;

    archivoDetalleNacimiento = file of nacimiento;
    archivoDetalleFallecimiento = file of fallecimiento;
    vectorNacidos = Array[1..DEL] of archivoDetalleNacimiento;
    vectorFallecidos = Array[1..DEL] of archivoDetalleFallecimiento;
    vectorRegistrosN = Array[1..DEL] of nacimiento;
    vectorRegistrosF = Array[1..DEL] of fallecimiento;

    archivoMaestro = file of registroMaestro;
var
    a1:archivoMaestro;
begin
    generarMaestro(a1); // implementar
    listarTXT(a1); // implementar
end;