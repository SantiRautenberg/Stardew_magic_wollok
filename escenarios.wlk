import wollok.game.*
import mapa.*
import personaje.*
import mineria.*




object granja {
    var property solidos = []
    var property obstaculos = []
    const objetos = []

    method registrar(elemento) {
        objetos.add(elemento)
    }
    method guardarColisiones() {
        solidos = mapa.solidos()
        obstaculos = principal.obs()
    }

    method ocultarObjetos() {
        objetos.forEach({objeto => if (game.hasVisual(objeto)){ 
            game.removeVisual(objeto)}})
      
    }
    method mostrarObjetos() {
    objetos.forEach({ objeto =>
        if (!game.hasVisual(objeto)) {
            game.addVisual(objeto)
            }
        })
    }

    method retirar(elemento) {
        objetos.remove(elemento)
        if (game.hasVisual(elemento)) {
            game.removeVisual(elemento)
        }
    }
    }
    class ZonaSolida {                 
    const property position
    const property ancho
    const property alto

    method esTalable() = false
    method esMinable() = false

    method ocupa(posicion) =
        posicion.x().between(position.x(), position.x() + ancho - 1) &&
        posicion.y().between(position.y(), position.y() + alto - 1)


}

object mina {
const property solidos = [ 
    // ===== BORDES LATERALES =====

    // Borde izquierdo completo.
    new ZonaSolida(
        position = game.at(0, 0),
        ancho = 1,
        alto = 20
    ),

    // Borde derecho completo.
    new ZonaSolida(
        position = game.at(19, 0),
        ancho = 1,
        alto = 20
    ),

    // ===== BORDE SUPERIOR =====
    // Deja libre el acceso central: columnas 9, 10 y 11.

    // Sector superior izquierdo.
    new ZonaSolida(
        position = game.at(1, 17),
        ancho = 8,
        alto = 3
    ),

    // Sector superior derecho.
    new ZonaSolida(
        position = game.at(12, 17),
        ancho = 7,
        alto = 3
    ),

    // ===== SALIENTES DE LA MITAD SUPERIOR =====

    // Pared izquierda hacia el pasillo central.
    new ZonaSolida(
        position = game.at(1, 12),
        ancho = 6,
        alto = 2
    ),

    // Pared derecha hacia el pasillo central.
    new ZonaSolida(
        position = game.at(13, 12),
        ancho = 6,
        alto = 2
    ),

    // ===== SALIENTES DE LA MITAD INFERIOR =====

    // Pared inferior izquierda.
    new ZonaSolida(
        position = game.at(1, 6),
        ancho = 4,
        alto = 2
    ),

    // Pared inferior derecha.
    new ZonaSolida(
        position = game.at(15, 5),
        ancho = 4,
        alto = 4
    ),

    // ===== BORDE INFERIOR =====
    // Deja libre la entrada y salida: columnas 9, 10 y 11.

    // Sector inferior izquierdo.
    new ZonaSolida(
        position = game.at(1, 0),
        ancho = 8,
        alto = 3
    ),

    // Sector inferior derecho.
    new ZonaSolida(
        position = game.at(12, 0),
        ancho = 7,
        alto = 3
    )
]

    const property minerales = [
        new Cobre (position = game.at(5,10)),
        new Cobre(position = game.at(13,15)),
        new Cobre(position = game.at(3,9)),
        new Cobre(position = game.at(16,15)),
        new Hierro(position = game.at(8,4)),
        new Hierro(position = game.at(14,10)),
        new Hierro(position = game.at(6,15)),
        new Hierro(position = game.at(12,7)),
        new Diamante(position = game.at(17,10)),
        new Diamante(position = game.at(2,10)),
        new Diamante(position = game.at(17,14)),
        new Diamante(position = game.at(4,4))
    ]

    method mostrarMinerales() {
      minerales.forEach({mineral => if (!mapa.solidos().contains(mineral))
      {mapa.registrar(mineral)}
      if (!game.hasVisual(mineral)) {game.addVisual(mineral)}})
    }

    method ocultarMinerales() {
      minerales.forEach({mineral => if (game.hasVisual(mineral)){game.removeVisual(mineral)}})
    }

    method retirarMinerales(mineral) {
      minerales.remove(mineral)
    }
}