import wollok.game.*
import mapa.*

// Aca van los obstaculos del mapa.
// las piedras se levantan y los arboles dan palos al talarlos
// las malesas nada

/**
 * Cosas que hay en el mapa y estorban. Todo obstaculo se registra en el `mapa`
 * al crearse para que el personaje no pueda atravesarlo.
 */
class Obstaculos {
    var property position
    var property cantidadDeRecursos = 1

    //method image()
    //method SePuedeQuitar()
    //method loot()

    
    method inicializar() {
        mapa.registrar(self)
    }

    /** Celdas que bloquean el paso. Por defecto, solo la celda donde esta. */
    method ocupa(posicion) = posicion == position
}

class Recursos {
    var property nombre      = ''
    var property cantidad    = 0

    method sumRecurso(unidades) {
        cantidad += unidades
    }

    method muestra() {
        return nombre + ": " + cantidad
    }
}

class Piedra inherits Obstaculos {
    method image() = 'piedra.png'
    method recurso() = new Recursos(nombre = 'piedra',cantidad = 1)
}

/** El tronco ocupa 2 celdas de ancho. */
class Tronco inherits Obstaculos {
    method image() = 'tronco.png'

    override method ocupa(posicion) = posicion == position || posicion == position.right(1)
}

/** Las malesas se pueden pisar, por eso no bloquean ninguna celda. */
class Malesa inherits Obstaculos {
    method image() = 'malesa.png'
    override method ocupa(posicion) = false
}

/** El arbol mide 3 x 4 celdas, pero solo bloquea su tronco (celda de abajo, al medio). */
class Arbol inherits Obstaculos {
    method image() = 'arbol.png'

    override method ocupa(posicion) = posicion == position.right(1)
}
