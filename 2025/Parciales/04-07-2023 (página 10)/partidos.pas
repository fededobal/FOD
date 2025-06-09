{
    Suponga que tiene un archivo con información de los partidos de los últimos años de
    los equipos de primera división del fútbol Argentino. Dicho archivo contiene: código de
    equipo, nombre de equipo, año, código de torneo, código de equipo rival, goles a favor,
    goles en contra, puntos obtenidos (0, 1 o 3 dependiendo de si perdió, ganó o empató el
    partido). El archivo está ordenado por los siguientes criterios: año, código de torneo y
    código de equipo.
    Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba
    el archivo y genere un informe por pantalla.
}

program partidos;
const
    VALOR_ALTO = 32700;
type
    sPuntos = 0..3;
    partido = record
        codeEq:longint;
        nom:string[20];
        anio:longint;
        codeTorneo:longint;
        codeEqRival:longint;
        golesAFavor:shortint;
        golesEnContra:shortint;
        puntosObtenidos:sPuntos;
    end;
    arcPartidos = file of partido;
procedure leer(var a:arcPartidos; var p:partido);
begin
    if not eof(a) then
        read(a,p)
    else
        p.anio := VALOR_ALTO;
end;
// procedure cargarArchivo(var a:arcPartidos); // se dispone
procedure generarInforme(var aP:arcPartidos);
var
    p:partido;
    anioAct:longint;
    torneoAct:longint;
    equipoAct:longint;
    nomAct:string[20];
    totalGolesFav,totalGolesContra,totalDifGoles:shortint;
    cantPGanados,cantPPerdidos,cantPEmpatados,totalPuntos:integer;
    maxPuntos:integer;
    eqGanador:string[20];
begin
    reset(aP);
    leer(aP,p);
    write('Informe resumen por equipo del fútbol Argentino');
    while(p.anio < VALOR_ALTO) do begin
        anioAct := p.anio;
        writeln('Anio ', anioAct);
        while((p.anio < VALOR_ALTO) and (p.anio = anioAct)) do begin
            torneoAct := p.codeTorneo;
            writeln('   Cod_torneo ', torneoAct);
            maxPuntos := -1;
            eqGanador := '';
            while((p.anio < VALOR_ALTO) and (p.anio = anioAct) and (p.codeTorneo = torneoAct)) do begin
                equipoAct := p.codeEq;
                nomAct := p.nom;
                writeln('       Cod_equipo ', equipoAct, ' nombre equipo ', nomAct);
                totalGolesFav := 0;
                totalGolesContra := 0;
                totalDifGoles := 0;
                cantPGanados := 0;
                cantPPerdidos := 0;
                cantPEmpatados := 0;
                totalPuntos := 0;
                while((p.anio < VALOR_ALTO) and (p.anio = anioAct) and (p.codeTorneo = torneoAct) and (p.codeEq = equipoAct)) do begin
                    totalGolesFav := totalGolesFav + p.golesAFavor;
                    totalGolesContra := totalGolesContra + p.golesEnContra;
                    totalDifGoles := totalDifGoles + (p.golesAFavor - p.golesEnContra);
                    if(p.golesAFavor > p.golesEnContra) then
                        cantPGanados := cantPGanados + 1
                    else if(p.golesAFavor = p.golesEnContra) then
                        cantPEmpatados := cantPEmpatados + 1
                    else
                        cantPPerdidos := cantPPerdidos + 1;
                    totalPuntos := totalPuntos + p.puntosObtenidos;
                    leer(aP,p);
                end;
                writeln('           cantidad total de goles a favor equipo ', equipoAct, ': ', totalGolesFav);
                writeln('           cantidad total de goles en contra equipo ', equipoAct, ': ', totalGolesContra);
                writeln('           diferencia de gol: ', totalDifGoles);
                writeln('           cantidad de partidos ganados equipo ', equipoAct, ': ', cantPGanados);
                writeln('           cantidad de partidos perdidos equipo ', equipoAct, ': ', cantPPerdidos);
                writeln('           cantidad de partidos empatados equipo ', equipoAct, ': ', cantPEmpatados);
                writeln('           cantidad de puntos en el torneo equipo ', equipoAct, ': ', totalPuntos);
                writeln('----------------------------------------------');
                if(totalPuntos > maxPuntos) then begin
                    maxPuntos := totalPuntos;
                    eqGanador := nomAct;
                end;
            end;
            writeln('El equipo ', eqGanador, ' fue campeon del torneo codigo de torneo ', torneoAct, ' del año ', anioAct);
        end;
    end;
    close(aP);
end;

var
    aP:arcPartidos;
begin
    assign(aP,'archivoPartidos');
    // cargarArchivo(aP); // se dispone
    generarInforme(aP);
end.