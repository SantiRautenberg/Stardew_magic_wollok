import plantas.*
import wollok.game.*
import mapa.*
import herramientas.*
import objetos.*


//podemos hacerlo clase o objeto , si lo hacemos clase despues cada personaje va a tener su propio inventario
/** Lista de cosas que lleva un personaje. */
class Inventario {
    var property items = []

    method add(elemento) {
        items.add(elemento)}

    method remove(elemento) {
        items.remove(elemento)}

    method contains(elemento) {
        return items.contains(elemento)}
}


/** Lo que tienen en comun todos los personajes: estadisticas, inventario y acciones basicas. */
class Personaje {
    var property nombre = ""
    var property vida = 100
    var property energia = 100
    var property hambre = 0
    var property dinero = 0
    const property inventario = new Inventario() 
    const plantas = []
    const parcelas = []

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

   
}

/** El mago que maneja el jugador: se mueve con WASD y puede llevar una herramienta. */
object principal inherits Personaje {
 
    var property obs = []

    // --- posicion y direccion (abajo | arriba | izquierda | derecha) ---
    var property position = game.at(11, 7)      // debajo de la puerta de la casa
    var mirando = "abajo"

    // --- animacion de caminata ---
    const esperaEntrePasos = 120                // ms minimos entre un paso y otro
    const framesDeCaminata = 4
    var caminando = false
    var frame = 1
    var ultimoMovimiento = 0

    // --- herramienta en la mano (hacha | pala | azada | sinHerramienta) ---
    const framesDeUso = 6
    var property herramienta = sinHerramienta
    var usando = false
    var frameUso = 1

    method objetoEnMiPosicion() {
    return game.getObjectsIn(position).find({ objeto => objeto != self })}

                                                                        
    method image() =
        if (usando) herramienta.imagenUsando(mirando, frameUso)
        else if (caminando) herramienta.imagenCaminando(mirando, frame)
        else herramienta.imagenQuieto(mirando)

    // ---------- animacion ----------
    method iniciarAnimacion() {
        game.onTick(100, "personajeQuieto", { self.actualizarAnimacion() })
    }

    method actualizarAnimacion() {
        if (usando) {
            self.avanzarUso()
        } else {
            self.frenarSiDejoDeCaminar()
        }
    }

    method avanzarUso() {
        if (frameUso < framesDeUso) {
            frameUso += 1
        } else {
            usando = false
            frameUso = 1
        }
    }

    method frenarSiDejoDeCaminar() {
        if (caminando && game.currentTime() - ultimoMovimiento > 220) {
            caminando = false
            frame = 1
        }
    }

    // ---------- movimiento ----------
    method destino(dir) =
        if (dir == "derecha") position.right(1)
        else if (dir == "izquierda") position.left(1)
        else if (dir == "arriba") position.up(1)
        else position.down(1)

    method puedeMoverse() = !usando && game.currentTime() - ultimoMovimiento >= esperaEntrePasos

    method mover(dir) {
        if (self.puedeMoverse()) {
            const ProximaDireccion = self.destino(dir)
            mirando = dir
            if (!obs.any({obstaculo => obstaculo.position() == ProximaDireccion})){
            self.irA(self.destino(dir))
            caminando = true
            frame = if (frame == framesDeCaminata) 1 else frame + 1
            ultimoMovimiento = game.currentTime()}
        }
    }

    /** Solo avanza si la celda esta dentro del mapa y no la bloquea nada. */
    method irA(nuevaPosicion) {
        if (mapa.estaLibre(nuevaPosicion)) {
            position = nuevaPosicion
        }
    }

    // ---------- herramientas ----------
    method equipar(unaHerramienta) {
        if (!usando) {
            herramienta = unaHerramienta
            caminando = false
            frame = 1
        }
    }

    method guardarHerramienta() {
        self.equipar(sinHerramienta)
    }

    /** Reproduce la animacion de talar / cavar / arar (todavia no modifica el mapa). */
    method usarHerramienta() {
        if (herramienta.sePuedeUsar() && !usando) {
            usando = true
            frameUso = 1
            caminando = false
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
    method levantar(objeto) {
    inventario.add(objeto.recurso())
    game.removeVisual(objeto)
    }

     method parcelaActual() {
      const parcela =  parcelas.find({parcela => parcela.position() == self.position()})

      if(parcela == null) {
        return sinParcela
      } else {
        return parcela
      }
    }

    method ponerParcela() {
      const parcela = new Parcela (position = self.position())
      parcelas.add(parcela)
      game.addVisual(parcela)
    }

    method plantar(planta) {
      self.parcelaActual().sembrar(planta)
    }

    method regar() {
      self.parcelaActual().regar()
    }


}
