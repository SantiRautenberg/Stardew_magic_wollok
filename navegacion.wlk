import wollok.game.*
import escenarios.*
import mapa.*
import combate.*
import ciclo.*

class Salida {
    const escenarioOrigen
    const posicionSalida
    const escenarioDestino
    const posicionEntrada

    method corresponde(personaje) =
        fondo.escenario() == escenarioOrigen.nombre() &&
        personaje.position() == posicionSalida

    method atravesar(personaje) {
        escenarioOrigen.salir()
        navegacion.entrarEn(escenarioDestino, personaje)
        personaje.position(posicionEntrada)
        personaje.visual_glitch()
    }
}

class EscenarioNavegable {
    const property nombre
    method salir()
    method entrar(personaje)
}

object rutaGranja inherits EscenarioNavegable(nombre = "granja") {
    override method salir() {
        granja.guardarColisiones()
        granja.ocultarObjetos()
    }
    override method entrar(personaje) {
        mapa.solidos(granja.solidos())
        personaje.obs(granja.obstaculos())
        granja.mostrarObjetos()
    }
}

object rutaPueblo inherits EscenarioNavegable(nombre = "pueblo") {
    override method salir() {}
    override method entrar(personaje) {}
}

object rutaMina inherits EscenarioNavegable(nombre = "mina") {
    override method salir() { mina.ocultarMinerales() }
    override method entrar(personaje) {
        mapa.solidos(mina.solidos())
        mina.mostrarMinerales()
    }
}

object rutaBosque inherits EscenarioNavegable(nombre = "bosque") {
    override method salir() { combate.retirarEnemigos() }
    override method entrar(personaje) { combate.aparecerEnemigos() }
}

object navegacion {
    const salidas = [
        new Salida(
            escenarioOrigen = rutaGranja, posicionSalida = game.at(18, 19),
            escenarioDestino = rutaPueblo, posicionEntrada = game.at(10, 1)
        ),
        new Salida(
            escenarioOrigen = rutaPueblo, posicionSalida = game.at(10, 0),
            escenarioDestino = rutaGranja, posicionEntrada = game.at(18, 18)
        ),
        new Salida(
            escenarioOrigen = rutaGranja, posicionSalida = game.at(1, 19),
            escenarioDestino = rutaMina, posicionEntrada = game.at(10, 1)
        ),
        new Salida(
            escenarioOrigen = rutaMina, posicionSalida = game.at(10, 0),
            escenarioDestino = rutaGranja, posicionEntrada = game.at(1, 18)
        ),
        new Salida(
            escenarioOrigen = rutaGranja, posicionSalida = game.at(2, 0),
            escenarioDestino = rutaBosque, posicionEntrada = game.at(10, 18)
        ),
        new Salida(
            escenarioOrigen = rutaBosque, posicionSalida = game.at(10, 19),
            escenarioDestino = rutaGranja, posicionEntrada = game.at(2, 1)
        )
    ]

    method revisarSalida(personaje) {
        const salida = salidas.findOrDefault(
            { candidata => candidata.corresponde(personaje) }, null
        )
        if (salida != null) { salida.atravesar(personaje) }
    }

    method entrarEn(escenario, personaje) {
        mapa.solidos([])
        personaje.obs([])
        fondo.escenario(escenario.nombre())
        escenario.entrar(personaje)
    }
}
