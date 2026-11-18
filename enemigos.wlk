import wollok.game.*
import combate.*
import objetos.*


class Enemigo {
    var property position
    const vidaMaxima
    const danio
    const imagen                              
    const botin                               

    const esperaEntrePasos = 700
    const esperaEntreAtaques = 1200
    const radioDeVision = 5                  
    const duracionDeLaDerrota = 800

    var danioRecibido = 0
    var ultimoPaso = 0
    var ultimoAtaque = -10000
    var ultimoDanioRecibido = -10000

    // ---------- vida ----------
    method vida() = 0.max(vidaMaxima - danioRecibido)
    method estaVivo() = self.vida() > 0

    method recibirDanio(cantidad) {
        if (self.estaVivo()) {
            danioRecibido += cantidad
            ultimoDanioRecibido = game.currentTime()
            if (self.estaVivo()) {
                game.say(self, "Vida: " + self.vida() + "/" + vidaMaxima)
            } else {
                game.say(self, "¡Derrotado!")
                combate.darBotin(self)
                game.schedule(duracionDeLaDerrota, { combate.retirar(self) })
            }
        }
    }

    // ---------- imagen: cambia unos instantes al recibir daño o atacar ----------
    method image() =
        if (!self.estaVivo()) imagen + "_derrotado.png"
        else if (self.ocurrioHace(ultimoDanioRecibido, 250)) imagen + "_dano.png"
        else if (self.ocurrioHace(ultimoAtaque, 300)) imagen + "_ataque.png"
        else imagen + ".png"

    method recurso() = new Recursos(nombre = 'bolaslime', cantidad = botin)

    method ocurrioHace(momento, duracion) = game.currentTime() - momento < duracion

    // ---------- colision (mismo protocolo que los demas solidos del mapa) ----------
    method ocupa(posicion) = self.estaVivo() && posicion == position
    method esTalable() = false
    method esMinable() = false

    // ---------- comportamiento (lo llama `combate` cada tick) ----------
    method actualizar(objetivo) {
        if (self.estaVivo()) {
            const distancia = self.distanciaA(objetivo.position())
            if (distancia <= 1) {
                self.atacar(objetivo)
            } else if (distancia <= radioDeVision) {
                self.acercarseA(objetivo)
            }
        }
    }

    method atacar(objetivo) {
        if (!self.ocurrioHace(ultimoAtaque, esperaEntreAtaques)) {
            ultimoAtaque = game.currentTime()
            objetivo.recibirDanio(danio)
        }
    }

    method acercarseA(objetivo) {
        if (!self.ocurrioHace(ultimoPaso, esperaEntrePasos)) {
            position = self.pasosHacia(objetivo.position()).findOrDefault({ paso => combate.celdaLibre(paso) }, position)
            ultimoPaso = game.currentTime()
        }
    }

    method pasosHacia(meta) {
        const dx = meta.x() - position.x()
        const dy = meta.y() - position.y()
        const horizontal = if (dx > 0) position.right(1) else position.left(1)
        const vertical = if (dy > 0) position.up(1) else position.down(1)
        const pasos = if (dx.abs() >= dy.abs()) [horizontal, vertical] else [vertical, horizontal]
        return pasos.filter({ paso => paso.distance(meta) < position.distance(meta) })
    }

    method distanciaA(otraPosicion) =
        (position.x() - otraPosicion.x()).abs() + (position.y() - otraPosicion.y()).abs()
}

// ---------- tipos de enemigos: aca se cambia la vida y el daño ----------
class SlimeVerde inherits Enemigo(vidaMaxima = 3, danio = 10, imagen = "slime_verde", botin = 1) { }

class SlimeMorado inherits Enemigo(vidaMaxima = 5, danio = 15, imagen = "slime_morado", botin = 2) { }
