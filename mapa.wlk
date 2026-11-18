import wollok.game.*
import ciclo.*
import objetos.*
import personaje.*

object mapa {
    var property solidos = []

    //====== metodo de consulta para talar =========
    method hayArbolEn(posicion) = solidos.any({ solido => solido.ocupa(posicion) && solido.esTalable()})    //devuelve true si hay un solido talable en la posicion
    method arbolEn(posicion) = solidos.find({ solido => solido.ocupa(posicion) && solido.esTalable() })     //devuelve el solido que hay en la posicion

    // metodo para saber si hay un mineral (esto debe ir en un mapa específico de la mina)
    method hayMineralEn(posicion) = solidos.any({ solido => solido.ocupa(posicion) && solido.esMinable() })
    method mineralEn(posicion) = solidos.find({ solido => solido.ocupa(posicion) && solido.esMinable() })

    method contiene(posicion) =
        posicion.x() >= 0 && posicion.x() < game.width() &&
        posicion.y() >= 0 && posicion.y() < game.height()

    method registrar(elemento) {
        solidos.add(elemento)
    }

    method quitar(elemento) {
        solidos.remove(elemento)
        if (game.hasVisual(elemento)) {
            game.removeVisual(elemento)
        }
    }

    method estaLibre(posicion) =
        self.contiene(posicion) && !solidos.any({ solido => solido.ocupa(posicion) })
}

class Casa {
    const ancho = 5
    const alto = 4

    method EsSolido() = false
    method esTalable() = false
    method esMinable() = false
    

    method image() =
        if(ciclo.esDia()) 'casa.png'
        else 'casanoche.gif'

        
    method position() = game.at(8, 8)

    method ocupa(posicion) =
        posicion.x().between(self.position().x(), self.position().x() + ancho - 1) &&
        posicion.y().between(self.position().y(), self.position().y() + alto - 1)
}
