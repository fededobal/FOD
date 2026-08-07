// a y b.
{
    Se organizan de la misma manera que un árbol B, excepto que los nodos terminales
    se conectan de izquierda a derecha entre sí, permitiendo un acceso secuencial
    entre ellos. Además, los nodos terminales poseerán todos los elementos del árbol
    (claves) y los nodos internos guiarán la búsqueda de claves hacia las hojas.
}
// c.
const M;
type
    alumno = record
        nomyap:string[30];
        dni:longint;
        legajo:string[10];
        anioIngreso:int;
    end;
    lista = ^nodo;
    nodo = record
        Hijos : array[1..M] of integer;
        Claves : array[1..M-1] of longint;  // DNIs
        Enlaces : array[1..M-1] of integer;
        Nro_claves: integer;
        sig : lista;
    end;
    archivoDatos = file of alumno;
    archivoIndice = file of nodo;
// d.
{
    A la hora de buscar la clave X en el archivoIndice, se recorrerá el árbol en profundidad
    hasta que, guiado por los nodos internos, encuentre o no el dato EN ALGUNA HOJA.
    Respecto al árbol B, encontramos la diferencia de que si se quiere buscar las claves
    en un rango, por ejemplo, deberíamos hacer backtracking por cada nodo recorrido
    completamente.
}
// e.
{
    Para buscar las claves en el rango 40M - 45M, se deberá buscar en los nodos terminales 
    la clave más cercana a 40M por derecha y, una vez encontrada, simplemente recorrer
    secuencialmente el nivel de los nodos terminales hasta encontrar la clave 45M o excederla.
}