import wollok.game.*
import mapa.*


//podemos hacerlo clase o objeto , si lo hacemos clase despues cada personaje va a tener su propio inventario
class Inventario {
    const items = []
    method add(elemento) {
        items.add(elemento)
    }
    method remove(elemento) {
        items.remove(elemento)
    }
    method contains(elemento) {
        return items.contains(elemento)
    }
    method items() {
        return items
    }
}


class Personaje {
    var property nombre = ""
    var property vida = 100
    var property energia = 100
    var property hambre = 0
    var property dinero = 0
    const property inventario = new Inventario() 
    const plantas = []

    method dormir() {
        energia = 100
    }
    
    //este lo puse asi pensando en que depende de que coma, es cuanta energia repone o cuanta hambre le saca
    //obvio lo podemos cambiar a que no importe que coma , siempre repone lo mismo
    method comer(alimento) {
        hambre = 0.max(hambre - alimento.calorias())
        energia = 100.min(energia + alimento.energiaQueAporta())
    }
    
    method agarrar(elemento) {
        inventario.add(elemento)
        if (game.hasVisual(elemento)) {
            game.removeVisual(elemento)
        }
    }

    //tendriamos que pasarle el precio por parametro o en dinero poner dinero += elemento.precio() y listo , total hay que hacer un objeto/clase elemento
    method vender(elemento, precio) {
        if (inventario.contains(elemento)) {
            inventario.remove(elemento)
            dinero = dinero + precio
        } else {
            self.error("El personaje no tiene ese item en su inventario.")
        }
    }

    //lo mismo qu vender 
    method comprar(elemento, precio) {
        if (dinero >= precio) {
            dinero = dinero - precio
            inventario.add(elemento)
        } else {
            self.error("No tenes suficiente dinero.")
        }
    }

    method plantar(planta) {
      plantas.add(planta)
      game.addVisual(planta)
    }
}

object principal inherits Personaje {
    
    var property position = game.at(10, 10)
    var mirando = "abajo"          // abajo | arriba | izquierda | derecha
    var caminando = false
    var frame = 1
    var ultimoMovimiento = 0

    method image() =
        if (caminando) "caminar_" + mirando + "_" + frame + ".png"
        else "caminar_" + mirando + "_1.png"

    method iniciarAnimacion() {
        game.onTick(100, "personajeQuieto", {
            if (caminando && game.currentTime() - ultimoMovimiento > 220) {
                caminando = false
                frame = 1
            }
        })
    }

    method destino(dir) =
        if (dir == "derecha") position.right(1)
        else if (dir == "izquierda") position.left(1)
        else if (dir == "arriba") position.up(1)
        else position.down(1)

    method mover(dir) {
        if (game.currentTime() - ultimoMovimiento >= 120) {
            mirando = dir
            const nuevaPosicion = self.destino(dir)
            if (mapa.contiene(nuevaPosicion)) {
                position = nuevaPosicion
            }
            caminando = true
            frame = if (frame == 4) 1 else frame + 1
            ultimoMovimiento = game.currentTime()
        }
    }

    method minar(objeto) {
        //por parametro el objeto a minar y ver cuanto de energia se le puede bajar
    }

    method pelear(enemigo) {
        // depende del enemigo es cuanta vida le va a sacar
    }

    method cosechar(planta) {
        //por paraemtro la planta a cosechar , un vez que la coseche se la guarda en el inventario?
    }
}
