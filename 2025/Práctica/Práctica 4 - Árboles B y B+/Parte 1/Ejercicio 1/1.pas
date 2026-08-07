// a.
const M;
type
    alumno = record
        nomyap:string[30];
        dni:longint;
        legajo:string[10];
        anioIngreso:int;
    end;
    reg_arbol_b = record
        Hijos : array[1..M] of integer;
        Claves : array[1..M-1] of alumno;
        Nro_claves: integer;
    end;
    archivo = file of reg_arbol_b;
// b.
{
    reg_arbol_b = 512 bytes;
    persona = 64 bytes;
    int = 4 bytes;

    512 = (M - 1) * 64 + M * 4 + 4
    512 = 64M - 64 + 4M + 4
    512 + 64 - 4 = 68M
    572 = 68M
    8 = M

    El orden M es 8. Entrarían 7 registros de persona (M - 1).
}
// c.
{
    Para un M pequeño, el árbol quedará mas alto que ancho. Y viceversa para un M grande.
}
// d.
{
    Si, hay más de una opción. DNI o legajo (DNI preferentemente).
}
// e.
{
    Si se desea encontrar alguna clave (DNI), en cada nodo se debe encontrar entre qué claves
    se encuentra nuestra clave, y avanzar por el puntero correspondiente.
    Se deben realizar entre 1 y H lecturas de nodos, siendo H la altura del árbol.
    Se realizará una sola lectura cuando la clave esté en la raíz, y H lecturas cuando la clave
    se encuentre en algún nodo terminal (hoja);
}
// f.
{
    Se deberían realizar entre 1 y N lecturas, siendo N la cantidad de nodos del árbol.
    En el peor de los casos, el registro buscado se encuentra en el último nodo recorrido
    (N lecturas).
}