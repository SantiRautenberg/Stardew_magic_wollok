import wollok.game.*
import mapa.*

class Obstaculos {
    var property position
    var property cantidadDeRecursos = 1
   
    method inicializar() {
        mapa.registrar(self)
    }

    method talar () {}
    method admiteDobleRecurso() = false
    method esTalable() = false
    method esMinable() = false

    method ocupa(posicion) = posicion == position
}

class Recursos {
    var property nombre      = ''
    var property cantidad    = 0
    var property position = game.at(0,0)

    method sumRecurso(unidades) {
        cantidad += unidades
    }

    method muestra() {
        return nombre + ": " + cantidad
    }
    
    method image(){
        return nombre + ".png"
    }
}

class Piedra inherits Obstaculos {
    method image() = 'piedra.png'
    method recurso() = new Recursos(nombre = 'piedra',cantidad = 1)
}


class Tronco inherits Obstaculos {
    override method esTalable() = true
    method recurso() = new Recursos(nombre = "palo", cantidad = 1)
    method image() = 'tronco.png'

    override method ocupa(posicion) = posicion == position || posicion == position.right(1)
}

class Malesa inherits Obstaculos {
    method image() = 'malesa.png'
    override method ocupa(posicion) = false
}

class Arbol inherits Obstaculos {
    override method esTalable() = true
    override method admiteDobleRecurso() = true
    method image() = 'arbol.png'
    method recurso() = new Recursos(nombre = 'palo',cantidad = 3)

    override method ocupa(posicion) = posicion == position.right(1)
}
