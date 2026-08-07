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
        Claves : array[1..M-1] of longint;  // DNIs
        Enlaces : array[1..M-1] of integer;
        Nro_claves: integer;
    end;
    archivoDatos = file of alumno;
    archivoIndice = file of reg_arbol_b;
// b.
{
    nodo = 512 bytes;
    int = 4 bytes;
    longint = 32 bytes;
    registro = 64 bytes;

    512 = (M - 1) * 32 + (M - 1) * 4 + M * 4 + 4
    512 = 32M - 32 + 4M - 4 + 4M + 4
    512 + 32 = 32M + 8M
    544 = 40M
    13 = M
}
// c.
{
    Implica que se podrán almacenar más claves y punteros que en la solución anterior.
}
// d.
{
    Clave a buscar: 12345678
    En cada nodo se debe encontrar entre qué claves se encuentra 12345678, y avanzar por 
    el puntero correspondiente.
    Si no se encontró, se habrán realizado H lecturas (altura del árbol).
    Si se encontró, la posición del alumno con DNI 12345678 en el archivo de alumnos será
    la que especifique el enlace en la posición [1..M-1] - 1 (pues los registros del archivo
    se cuentan desde 0).
}
// e.
{
    Si se desea buscar un alumno por su legajo, se harían N lecturas (cantidad de nodos).
    No, no tiene sentido desaprovechar el criterio de orden del árbol.
    Como alternativa, armaría otro árbol de índices ordenado por legajos.
}
// f.
{
    El problema es que, suponiendo que dicho rango (40M - 45M) se encuentra a lo largo 
    de un nivel entero horizontalmente, cada vez que se termine de leer uno de estos nodos
    hay que volver al padre, y encontrar como ir los otros nodos que se encontraban
    al mismo nivel mencionado.
}