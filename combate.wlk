import wollok.game.*
import mapa.*
import personaje.*
import enemigos.*


object combate {
    const enemigos = []

    // ---------- configuracion: donde aparecen y donde reaparece el jugador ----------
    const posicionSlimesVerdes = [game.at(3, 14), game.at(7, 15), game.at(14, 15), game.at(17, 13), game.at(4, 9), game.at(16, 9), game.at(8, 10)]
    const posicionSlimesMorados = [game.at(10, 11), game.at(6, 5), game.at(14, 5)]
    const entradaDelBosque = game.at(10, 18)
    const duracionDeUnTick = 250

    method entradaDelBosque() = entradaDelBosque

    method aparecerEnemigos() {
        posicionSlimesVerdes.forEach({ posicion => self.agregar(new SlimeVerde(position = posicion)) })
        posicionSlimesMorados.forEach({ posicion => self.agregar(new SlimeMorado(position = posicion)) })
        game.onTick(duracionDeUnTick, "combate", { self.actualizar() })
    }

    method retirarEnemigos() {
        game.removeTickEvent("combate")
        enemigos.forEach({ enemigo => self.quitarDelJuego(enemigo) })
        enemigos.clear()
    }

    // ---------- enemigos ----------
    method agregar(enemigo) {
        enemigos.add(enemigo)
        mapa.registrar(enemigo)
        game.addVisual(enemigo)
    }

    method retirar(enemigo) {
        enemigos.remove(enemigo)
        self.quitarDelJuego(enemigo)
    }

    method quitarDelJuego(enemigo) {
        mapa.quitar(enemigo)
    }

    method darBotin(enemigo) {
        const botin = enemigo.recurso()
        principal.inventario().add(botin)
        game.say(principal, "Obtuve " + botin.cantidad() + " bola(s) de slime")
    }

    method actualizar() {
        enemigos.forEach({ enemigo => enemigo.actualizar(principal) })
    }

    method enemigoEn(posicion) = enemigos.findOrDefault({ enemigo => enemigo.ocupa(posicion) }, sinEnemigo)

    method celdaLibre(posicion) =
        mapa.estaLibre(posicion) && !principal.hayObstaculoEn(posicion) && posicion != principal.position()
}

object sinEnemigo {
    method recibirDanio(cantidad) { }
}

object barraVida {
    method position() = game.at(5, 0)

    method image() =
        if (principal.vida() > 70) "barravida_100.png"
        else if (principal.vida() > 50) "barravida_70.png"
        else if (principal.vida() > 20) "barravida_50.png"
        else if (principal.vida() > 5) "barravida_20.png"
        else "barravida_5.png"
}
