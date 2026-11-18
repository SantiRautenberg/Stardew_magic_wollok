import wollok.game.*
import escenarios.*
import mercado.*
import inventario.*
import ciclo.*

class PuestoDeMercado {
    const ubicacion
    method estaDisponiblePara(personaje) = personaje.position() == ubicacion
    method interactuar(personaje)
}

object puestoMejoras inherits PuestoDeMercado(ubicacion = game.at(13, 6)) {
    override method interactuar(personaje) {
        game.say(personaje, "Puesto de mejoras")
        const mejora = [mejoraPico, mejoraAzada, mejoraHacha].findOrDefault(
            { candidata => candidata.cumpleCondiciones() }, null
        )
        if (mejora != null) {
            mejora.comprar(personaje)
        } else {
            game.say(personaje, "Ya compraste las mejoras disponibles")
        }
    }
}

class PuestoDeVenta inherits PuestoDeMercado {
    const comprador
    const mensaje
    override method interactuar(personaje) {
        game.say(personaje, mensaje)
        controladorInventarioVisual.cerrar()
        comprador.venderTodo(personaje)
    }
}

object puestoCosechas inherits PuestoDeVenta(
    ubicacion = game.at(6, 11),
    comprador = compradorPlantas,
    mensaje = "Puesto de cosechas"
) {}

object puestoMinerales inherits PuestoDeVenta(
    ubicacion = game.at(13, 11),
    comprador = compradorMinerales,
    mensaje = "Puesto de minerales"
) {}

object puestoSemillas inherits PuestoDeMercado(ubicacion = game.at(6, 6)) {
    override method interactuar(personaje) {
        controladorInventarioVisual.cerrar()
        vendedorSemillas.comprar(personaje)
    }
}

object interaccionesMercado {
    const puestos = [puestoMejoras, puestoCosechas, puestoMinerales, puestoSemillas]
    method interactuar(personaje) {
        if (fondo.escenario() == "pueblo") {
            const puesto = puestos.findOrDefault(
                { candidato => candidato.estaDisponiblePara(personaje) }, null
            )
            if (puesto != null) { puesto.interactuar(personaje) }
        }
    }
}
