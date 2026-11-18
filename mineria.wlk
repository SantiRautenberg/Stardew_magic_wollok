import objetos.*
import wollok.game.*
import mapa.*
import escenarios.*
import herramientas.*

class Mineral {
    var property position
    const property costoEnergia = 20 
    method image() {}

    method esMinable() = true
    method esTalable() = false
    method ocupa(posicion) = posicion == position
    
    method serMinadoPor(unPersonaje) {
        const costoFinal = pico.costoMinar(costoEnergia)

        if (unPersonaje.energia() < costoFinal) {
            self.error("No tienes suficiente energía para minar este mineral.")
        }

        unPersonaje.gastarEnergia(costoFinal)
        unPersonaje.agarrar(self.recursoExtraido())
        mapa.quitar(self)
        mina.retirarMinerales(self)
    }
    
    method recursoExtraido()
}

class Cobre inherits Mineral {
    override method image() = "cobre.png"
    override method recursoExtraido() = new Recursos(nombre = "cobre", cantidad = 1)
}

class Hierro inherits Mineral {
    override method image() = "hierro.png"
    override method costoEnergia() = 40
    override method recursoExtraido() = new Recursos(nombre = "hierro", cantidad = 1)
}

class Diamante inherits Mineral {
    override method image() = "diamante.png"
    override method costoEnergia() = 50
    override method recursoExtraido() = new Recursos(nombre = "diamante", cantidad = 1)
}
