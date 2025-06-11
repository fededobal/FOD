program presentaciones;
const
    VALOR_ALTO = 32700;
type
    presentacion = record
        codeArtista:integer;
        nomArtista:string[30];
        anio:integer;
        codeEvento:integer;
        nomEvento:string[30];
        likes:integer;
        dislikes:integer;
        puntaje:real;
    end;
    archivo = file of presentacion;
procedure leer(var a:archivo; var p:presentacion);
begin
    if(not eof(a)) then
        read(a,p)
    else
        p.anio := VALOR_ALTO;
end;
procedure calcularMenosInfluyente(nom:string; punt:real; dis:integer; var minP:real; var nomMinP:string; var maxD:integer; var nomMaxD:string; var nomArtistaMenosInfluyente:string);
begin
    if((punt = minP) and (dis = maxD)) then
        nomArtistaMenosInfluyente := nom
    else begin
        if((punt = minP) and (dis > maxD)) then begin
            maxD := dis;
            nomMaxD := nom;
        end else if(punt < minP) then begin
            minP := punt;
            nomMinP := nom;
        end;
        nomArtistaMenosInfluyente := nom;
    end;
end;
procedure generarInforme(var a:archivo);
var
    p:presentacion;
    likesAct,cantAnios,cantPresentaciones,cantPresentacionesAct,anioAct,cEventoAct,maxDislikes,cArtistaAct,dislikesAct:integer;
    minPuntaje,puntajeAct,promedioPresentacionesPorAnio:real;
    nEventoAct,nomArtistaMenosInfluyente,nomArtistaMasDislikes,nomArtistaMenosPuntaje,nArtistaAct:string[30];
begin
    reset(a);
    cantAnios := 0;
    cantPresentaciones := 0;
    leer(a,p);
    writeln('Resumen de menor influencia por evento.');
    while(p.anio <> VALOR_ALTO) do begin
        cantAnios := cantAnios + 1;
        cantPresentacionesAct := 0;
        anioAct := p.anio;
        writeln('Año: ', anioAct);
        while(p.anio = anioAct) do begin
            nEventoAct := p.nomEvento;
            cEventoAct := p.codeEvento;
            nomArtistaMenosInfluyente := '';
            nomArtistaMasDislikes := '';
            maxDislikes := VALOR_ALTO;
            nomArtistaMenosPuntaje := '';
            minPuntaje := -1;
            writeln('   Evento: ', nEventoAct, ' (Código: ', cEventoAct, ')');
            while((p.anio = anioAct) and (p.codeEvento = cEventoAct)) do begin
                nArtistaAct := p.nomArtista;
                cArtistaAct := p.codeArtista;
                likesAct := 0;
                dislikesAct := 0;
                puntajeAct := 0;
                writeln('       Artista: ', nArtistaAct, ' (Código: ', cArtistaAct, ')');
                while((p.anio = anioAct) and (p.codeEvento = cEventoAct) and (p.codeArtista = cArtistaAct)) do begin
                    likesAct := likesAct + p.likes;
                    dislikesAct := dislikesAct + p.dislikes;
                    puntajeAct := puntajeAct + p.puntaje;
                    cantPresentacionesAct := cantPresentacionesAct + 1;
                    leer(a,p);
                end;
                writeln('           Likes totales: ', likesAct);
                writeln('           Dislikes totales: ', dislikesAct);
                writeln('           Diferencia: ', likesAct - dislikesAct);
                writeln('           Puntaje total del jurado: ', puntajeAct);
                calcularMenosInfluyente(nArtistaAct,puntajeAct,dislikesAct,minPuntaje,nomArtistaMenosPuntaje,maxDislikes,nomArtistaMasDislikes,nomArtistaMenosInfluyente);
            end;
            writeln('   El artista ', nomArtistaMenosInfluyente, ' fue el menos influyente de ', nEventoAct, ' del año ', anioAct);
        end;
        writeln('Durante el año ', anioAct, ' se registraron ', cantPresentacionesAct, ' presentaciones de artistas.');
        cantPresentaciones := cantPresentaciones + cantPresentacionesAct;
    end;
    promedioPresentacionesPorAnio := cantPresentaciones / cantAnios;
    writeln('El promedio total de presentaciones por año es de: ', promedioPresentacionesPorAnio, ' presentaciones');
    close(a);
end;
// procedure generarArchivo(var a:archivo); gracias gemini :)
// var
//     p: presentacion;
// begin
//     rewrite(a); // Create/overwrite the file

//     // Data must be written in the desired order:
//     // 1. Year (ascending)
//     // 2. Event Code (ascending)
//     // 3. Artist Code (ascending)

//     // Year 2022
//     // Event 40 (Electro Fest)
//     p.codeArtista := 101; p.nomArtista := 'Artista A'; p.anio := 2022; p.codeEvento := 40; p.nomEvento := 'Electro Fest'; p.likes := 90; p.dislikes := 25; p.puntaje := 7.0; write(a, p);
//     p.codeArtista := 104; p.nomArtista := 'Artista D'; p.anio := 2022; p.codeEvento := 40; p.nomEvento := 'Electro Fest'; p.likes := 280; p.dislikes := 18; p.puntaje := 9.3; write(a, p);
//     p.codeArtista := 104; p.nomArtista := 'Artista D'; p.anio := 2022; p.codeEvento := 40; p.nomEvento := 'Electro Fest'; p.likes := 300; p.dislikes := 30; p.puntaje := 9.5; write(a, p);


//     // Year 2023
//     // Event 10 (Festival Rock)
//     p.codeArtista := 101; p.nomArtista := 'Artista A'; p.anio := 2023; p.codeEvento := 10; p.nomEvento := 'Festival Rock'; p.likes := 80; p.dislikes := 15; p.puntaje := 7.8; write(a, p);
//     p.codeArtista := 101; p.nomArtista := 'Artista A'; p.anio := 2023; p.codeEvento := 10; p.nomEvento := 'Festival Rock'; p.likes := 100; p.dislikes := 10; p.puntaje := 8.5; write(a, p);

//     // Event 30 (Noche Jazz)
//     p.codeArtista := 103; p.nomArtista := 'Artista C'; p.anio := 2023; p.codeEvento := 30; p.nomEvento := 'Noche Jazz'; p.likes := 180; p.dislikes := 12; p.puntaje := 8.7; write(a, p);
//     p.codeArtista := 103; p.nomArtista := 'Artista C'; p.anio := 2023; p.codeEvento := 30; p.nomEvento := 'Noche Jazz'; p.likes := 200; p.dislikes := 20; p.puntaje := 9.0; write(a, p);

//     // Year 2024
//     // Event 10 (Festival Rock)
//     p.codeArtista := 105; p.nomArtista := 'Artista E'; p.anio := 2024; p.codeEvento := 10; p.nomEvento := 'Festival Rock'; p.likes := 250; p.dislikes := 7; p.puntaje := 9.1; write(a, p);

//     // Event 20 (Concierto Pop)
//     p.codeArtista := 102; p.nomArtista := 'Artista B'; p.anio := 2024; p.codeEvento := 20; p.nomEvento := 'Concierto Pop'; p.likes := 120; p.dislikes := 8; p.puntaje := 8.9; write(a, p);
//     p.codeArtista := 102; p.nomArtista := 'Artista B'; p.anio := 2024; p.codeEvento := 20; p.nomEvento := 'Concierto Pop'; p.likes := 150; p.dislikes := 5; p.puntaje := 9.2; write(a, p);

//     close(a);
//     writeln('Archivo "archivo" generado con registros ordenados.');
// end;
var
    a:archivo;
begin
    assign(a,'archivo');
    // generarArchivo(a); // se dispone
    generarInforme(a);
end.