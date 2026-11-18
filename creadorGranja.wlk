import wollok.game.*
import objetos.*
import mapa.*
import escenarios.*
import configuracion.*

object creadorGranja {
    const posicionPiedras = [
        game.at(2, 6), game.at(14, 3), game.at(15, 12),
        game.at(4, 4), game.at(6, 3), game.at(9, 4),
        game.at(12, 2), game.at(16, 6), game.at(3, 8),
        game.at(5, 12), game.at(7, 15), game.at(16, 16),
        game.at(4, 2), game.at(7, 4),
        game.at(10, 3), game.at(13, 4),
        game.at(2, 12), game.at(6, 14),
        game.at(12, 16), game.at(16, 11)
    ]

    const posicionArboles = [
        game.at(3, 10), game.at(15, 8), game.at(17, 3),
        game.at(3, 5), game.at(6, 9),
        game.at(14, 13), game.at(8, 15),
        game.at(5, 5), game.at(9, 1),
        game.at(2, 14), game.at(14, 4)
    ]

    const posicionTroncos = [
        game.at(7, 6),
        game.at(4, 17),
        game.at(13, 17)
    ]

    const posicionMalesas = [
        game.at(6, 8),
        game.at(12, 5),
        game.at(17, 17),
        game.at(3, 3),
        game.at(13, 15)
    ]

    method colocarObstaculos() {
        const obstaculosQueBloquean = []

        const piedras = posicionPiedras.map({ posicion =>
            new Piedra(position = posicion)
        })
        self.agregarAlJuego(piedras)

        const arboles = posicionArboles.map({ posicion =>
            new Arbol(position = posicion)
        })
        self.agregarAlJuego(arboles)
        arboles.forEach({ arbol => mapa.registrar(arbol) })
        obstaculosQueBloquean.addAll(arboles)

        const troncos = posicionTroncos.map({ posicion =>
            new Tronco(position = posicion)
        })
        self.agregarAlJuego(troncos)
        obstaculosQueBloquean.addAll(troncos)

        const malesas = posicionMalesas.map({ posicion =>
            new Malesa(position = posicion)
        })
        self.agregarAlJuego(malesas)

        return obstaculosQueBloquean
    }

    method agregarAlJuego(elementos) {
        elementos.forEach({ elemento =>
            granja.registrar(elemento)
            game.addVisual(elemento)
        })
    }
    method colocarCasa() {
        const casa = new Casa()
        self.agregarAlJuego([casa])
        return casa
    }
}