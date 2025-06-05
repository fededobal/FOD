procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var clave_encontrada: boolean;
begin
    if (nodo = nil)
        resultado := false; {clave no encontrada}
    else begin
        posicionarYLeerNodo(A, nodo, NRR);
        claveEncontrada(A, nodo, clave, pos, clave_encontrada);
        if (clave_encontrada) then begin
            NRR_encontrado := NRR; { NRR actual }
            pos_encontrada := pos; { posicion dentro del array }
            resultado := true;
        end else
            buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);
end;

// a.
{
    posicionarYLeerNodo() es responsable de acceder a un nodo específico del árbol 
    almacenado en un archivo en disco. Dado un Número de Registro Relativo (NRR), que 
    actúa como un puntero o dirección del nodo en el archivo, la función se posiciona 
    en esa ubicación y lee el contenido completo del nodo, cargándolo en una variable en 
    memoria para procesarlo después.
    A y nodo se pasan por referencia. NRR por valor.
}
procedure posicionarYLeerNodo(var A: file of reg_nodo; var nodo: reg_nodo; NRR: integer);
begin
    seek(A, NRR);
    read(A, nodo);
end;

// b.
{
    claveEncontrada() busca una clave específica dentro del arreglo de claves de un nodo 
    ya cargado en memoria. Determina si la clave existe en el nodo y, si no, cuál sería 
    la posición correcta para insertar la clave o qué puntero de hijo seguir para continuar 
    la búsqueda.
    A no es necesaria. nodo se puede pasar por valor ya que solo hay que leer su contenido.
    clave se pasa por valor. pos y clave_encontrada se pasan por referencia. 
}
procedure claveEncontrada(nodo: reg_nodo; clave: integer; var pos: integer; var clave_encontrada: boolean);
var
    i: integer;
begin
    i := 1;
    while (i <= nodo.cantClaves) and (clave > nodo.claves[i]) do
        i := i + 1;
    pos := i;
    if (i <= nodo.cantClaves) and (clave = nodo.claves[i]) then
        clave_encontrada := true
    else
        clave_encontrada := false;
end;

// c. Código corregido:
procedure buscar(var A: arbol; NRR, clave: integer; var NRR_encontrado, pos_encontrada: integer; var resultado: boolean)
var 
    clave_encontrada: boolean;
    nodo : array[1..M] of integer;
begin
    if (nodo = nil)
        resultado := false; {clave no encontrada}
    else begin
        posicionarYLeerNodo(A, nodo, NRR);
        claveEncontrada(A, nodo, clave, pos, clave_encontrada);
        if (clave_encontrada) then begin
            NRR_encontrado := NRR; { NRR actual }
            pos_encontrada := pos; { posicion dentro del array }
            resultado := true;
        end else
            buscar(A, nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);
end;

// d.
procedure buscar_Bplus(NRR: integer; clave: info; var NRR_encontrado: integer; var pos_encontrada: integer; var resultado: boolean);
var
    nodo: TRegistroNodo_Bplus;
    pos: integer;
    clave_encontrada_local: boolean;
begin
    if (NRR = nil) then
        resultado := false
    else
    begin
        posicionarYLeerNodo(A, nodo, NRR);
        ubicarPuntero(nodo, clave, pos);
        if (nodo.esHoja) then // Si estamos en un nodo hoja
        begin
            claveEncontradaEnHoja(nodo, clave, pos, clave_encontrada_local);
            if (clave_encontrada_local) then
            begin
                NRR_encontrado := NRR;
                pos_encontrada := pos;
                resultado := true;
            end
            else
            begin
                resultado := false;
            end;
        end
        else
            buscar_Bplus(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);
    end;
end;