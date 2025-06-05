// Overflow
{
    Se produce al insertar un elemento en un nodo que ya alcanzó su máxima capacidad. 
    Esto viola las reglas del árbol, que limitan el número de claves por nodo. Para 
    solucionarlo, el nodo se divide en dos, y la clave mediana se promociona al nodo padre. 
    Este proceso garantiza que el árbol crezca de manera balanceada hacia arriba.
}
// Underflow
{
    Ocurre cuando la eliminación de una clave deja a un nodo con menos elementos que el 
    mínimo requerido. Esta situación compromete el equilibrio y la eficiencia de la estructura 
    del árbol. Para resolverlo, el árbol debe reorganizarse mediante una redistribución o una 
    fusión de nodos. Esto asegura que todos los nodos (excepto la raíz) mantengan una ocupación 
    mínima.
}
// Redistribución
{
    Es la primera técnica para corregir un underflow, aplicable si un nodo hermano adyacente 
    tiene claves de sobra. Consiste en "tomar prestada" una clave de ese hermano, pasándola a 
    través del nodo padre. Esta operación es eficiente porque rebalancea los nodos sin alterar 
    la cantidad total de nodos del árbol. Se prefiere sobre la fusión siempre que sea posible.
}
// Fusión o concatenación
{
    Es la solución para el underflow cuando la redistribución no es viable por falta de claves 
    en los hermanos. El nodo en underflow se une con un hermano adyacente y la clave que los 
    separaba en el padre baja. El resultado es un único nodo combinado y la eliminación de un 
    puntero en el padre, lo que puede propagar el underflow.
}