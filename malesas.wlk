import wollok.game.*
// Aca van las malezas (todavia sin implementar).
// las piedras se levantan y los arboles dan palos al talarlos
// las malesas nada

class obstaculos {
    var property position  
    var property cantidadDeRecursos = 1


    //method image() 
    //method SePuedeQuitar() 
    //method loot()  
}


class piedra inherits obstaculos {
    method image() = 'piedra.png'
}

class tronco inherits obstaculos {
  method image() = 'tronco.png' 
}

class malesa inherits obstaculos {
    method image() = 'malesa.png'
}

class arbol inherits obstaculos {
  method image() =  'arbol.png'
}
