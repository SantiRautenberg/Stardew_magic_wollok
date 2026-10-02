import wollok.game.*
// Aca van las malezas (todavia sin implementar).
// las piedras se levantan y los arboles dan palos al talarlos
// las malesas nada

class Obstaculos {
    var property position  
    var property cantidadDeRecursos = 1


    //method image() 
    //method SePuedeQuitar() 
    //method loot()  
}


class piedra inherits Obstaculos {
    method image() = 'piedra.png'
}

class tronco inherits Obstaculos {
  method image() = 'tronco.png' 
}

class malesa inherits Obstaculos {
    method image() = 'malesa.png'
}

class arbol inherits Obstaculos {
  method image() =  'arbol.png'
}
