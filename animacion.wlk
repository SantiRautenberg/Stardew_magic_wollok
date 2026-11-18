import wollok.game.*
import herramientas.*


class Animacion {
    const cantidadDeFrames
    var frame = 1

    method frame() = frame

    method avanzar() {
        frame = if (self.esElUltimoFrame()) 1 else frame + 1
    }

    method reiniciar() {
        frame = 1
    }

    method esElUltimoFrame() = frame == cantidadDeFrames
}

class Animador {
    const esperaEntrePasos = 120      // minimo entre un paso y el siguiente
    const tiempoParaFrenar = 220      // sin pasos durante este tiempo => vuelve a quieto
    const duracionDeUnTick = 100      // cada cuanto se actualiza la animacion
    var ultimoPaso = 0                // momento del ultimo paso

    var estado = quieto               
    const caminata = new Animacion(cantidadDeFrames = 4)
    const uso = new Animacion(cantidadDeFrames = 6)

    var property herramienta = sinHerramienta

    // ---------- imagen ----------
    method imagen(direccion) = estado.imagen(self, direccion)

    method imagenQuieto(direccion) = herramienta.imagenQuieto(direccion)
    method imagenCaminando(direccion) = herramienta.imagenCaminando(direccion, caminata.frame())
    method imagenUsando(direccion) = herramienta.imagenUsando(direccion, uso.frame())

    // ---------- reloj ----------
    method iniciar() {
        game.onTick(duracionDeUnTick, "personajeQuieto", { self.actualizar() })
    }

    method actualizar() {
        estado.actualizar(self)
    }

    // ---------- cambios de estado ----------
    method quedarseQuieto() {
        estado = quieto
        caminata.reiniciar()
        uso.reiniciar()
    }

    method darUnPaso() {
        estado = caminando
        caminata.avanzar()
        ultimoPaso = game.currentTime()
    }

    method empezarAUsarHerramienta() {
        estado = usandoHerramienta
        uso.reiniciar()
    }

    // ---------- preguntas ----------
    method tiempoDesdeElUltimoPaso() = game.currentTime() - ultimoPaso
    method puedeDarUnPaso() = estado.puedeMoverse() && self.tiempoDesdeElUltimoPaso() >= esperaEntrePasos
    method dejoDeCaminar() = self.tiempoDesdeElUltimoPaso() > tiempoParaFrenar
    method terminoElUso() = uso.esElUltimoFrame()
    method avanzarUso() { uso.avanzar() }

    // ---------- herramienta ----------
    method equipar(unaHerramienta) {
        if (estado.puedeCambiarDeHerramienta()) {
            herramienta = unaHerramienta
            self.quedarseQuieto()
        }
    }

    method puedeUsarHerramienta() = herramienta.sePuedeUsar() && estado.puedeUsarHerramienta()
}

object quieto {
    method imagen(animador, direccion) = animador.imagenQuieto(direccion)
    method actualizar(animador) { }
    method puedeMoverse() = true
    method puedeCambiarDeHerramienta() = true
    method puedeUsarHerramienta() = true
}

object caminando {
    method imagen(animador, direccion) = animador.imagenCaminando(direccion)
    method actualizar(animador) {
        if (animador.dejoDeCaminar()) {
            animador.quedarseQuieto()
        }
    }
    method puedeMoverse() = true
    method puedeCambiarDeHerramienta() = true
    method puedeUsarHerramienta() = true
}

object usandoHerramienta {
    method imagen(animador, direccion) = animador.imagenUsando(direccion)
    method actualizar(animador) {
        if (animador.terminoElUso()) {
            animador.quedarseQuieto()
        } else {
            animador.avanzarUso()
        }
    }
    method puedeMoverse() = false
    method puedeCambiarDeHerramienta() = false
    method puedeUsarHerramienta() = false
}
