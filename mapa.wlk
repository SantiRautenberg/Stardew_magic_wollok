import wollok.game.*
import ciclo.*


/**
 * Tablero del juego: conoce sus limites y que celdas estan ocupadas.
 * Los elementos que bloquean el paso (casa, piedras, arboles...) se registran
 * solos al crearse, y cada uno responde con `ocupa(posicion)` que celdas pisa.
 */
object mapa {
    const solidos = []

    method contiene(posicion) =
        posicion.x() >= 0 && posicion.x() < game.width() &&
        posicion.y() >= 0 && posicion.y() < game.height()

    method registrar(elemento) {
        solidos.add(elemento)
    }

    /** Lo saca del juego y deja de bloquear (para cuando se tala, se levanta, etc.). */
    method quitar(elemento) {
        solidos.remove(elemento)
        if (game.hasVisual(elemento)) {
            game.removeVisual(elemento)
        }
    }

    /** El personaje solo puede pisar celdas que esten dentro del tablero y sin solidos. */
    method estaLibre(posicion) =
        self.contiene(posicion) && !solidos.any({ solido => solido.ocupa(posicion) })
}

/** La casa mide 6 x 7 celdas (288 x 336 px) y bloquea todo ese rectangulo. */
class Casa {
    const ancho = 6
    const alto = 7

    method inicializar() {
        mapa.registrar(self)
    }

    method image() =
        if(ciclo.esDia()) 'casa.png'
        else 'casanoche.gif'

        
    method position() = game.at(8, 8)

    method ocupa(posicion) =
        posicion.x().between(self.position().x(), self.position().x() + ancho - 1) &&
        posicion.y().between(self.position().y(), self.position().y() + alto - 1)
}
