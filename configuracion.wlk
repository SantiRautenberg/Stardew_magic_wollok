import wollok.game.*
import personaje.*
import plantas.*
import ciclo.*
import herramientas.*
import recetas.*
import inventario.*
import energia.*
import instrucciones.*
import combate.*
import caratula.*
import creadorGranja.*

object configuracion {
    const duracionDelDia = 15000

    method iniciarMusica() {
        const musica = game.sound("musicafondo.mp3")
        musica.volume(0.3)
        musica.shouldLoop(true)
        musica.play()
    }

    method iniciar() {
        game.addVisual(caratula)
        keyboard.enter().onPressDo({ self.empezar() })
        self.iniciarMusica()
        game.start()
    }

    method empezar() {
        if (game.hasVisual(caratula)) {
            game.removeVisual(caratula)

            game.schedule(100, {
            principal.obs(creadorGranja.colocarObstaculos())
            principal.casa(creadorGranja.colocarCasa())
            self.colocarPersonaje()
            self.cambiosEnergia()
            self.configurarTeclas()
            self.configurarCiclo()
            })
        }
    }

    // ---------- personaje ----------

    method colocarPersonaje() {
        game.addVisual(principal)
        game.addVisual(barraVida)
        principal.iniciarAnimacion()
        game.addVisual(contadorMonedas)
    }

    // ---------- teclas ----------

    method configurarTeclas() {
        self.teclasDeMovimiento()
        self.teclasDeObjetos()
        self.teclasDeHerramientas()
        self.teclasDeCultivo()
        self.teclasDeMinar()
    }

    method teclasDeMovimiento() {
        keyboard.w().onPressDo { principal.mover("arriba") }
        keyboard.a().onPressDo { principal.mover("izquierda") }
        keyboard.s().onPressDo { principal.mover("abajo") }
        keyboard.d().onPressDo { principal.mover("derecha") }
    }

    method teclasDeObjetos() {
        keyboard.q().onPressDo {
            const objeto = principal.objetoEnMiPosicion()
            principal.levantar(objeto)
        }

        keyboard.i().onPressDo {
            controladorInventarioVisual.alternar()
        }

        keyboard.f().onPressDo {
            principal.interactuar()
        }

        keyboard.enter().onPressDo {
            controlarInstrucciones.alternar()
        }
    }

    method teclasDeHerramientas() {
        keyboard.num1().onPressDo { principal.equipar(hacha) }
        keyboard.num2().onPressDo { principal.equipar(pico) }
        keyboard.num3().onPressDo { principal.equipar(azada) }
        keyboard.num0().onPressDo { principal.guardarHerramienta() }
        keyboard.e().onPressDo { principal.usarHerramienta() }
    }

    method teclasDeCultivo() {
        keyboard.l().onPressDo {
            principal.plantar(
                new PlantaLunar(position = principal.position())
            )
        }

        keyboard.g().onPressDo {
            principal.plantar(
                new Girasol(position = principal.position())
            )
        }

        keyboard.r().onPressDo {
            principal.plantar(
                new RosaMagica(position = principal.position())
            )
        }

        keyboard.h().onPressDo {
            principal.plantar(
                new Hongo(position = principal.position())
            )
        }

        keyboard.m().onPressDo {
            principal.plantar(
                new Mandragora(position = principal.position())
            )
        }

        keyboard.c().onPressDo {
            principal.cosechar(principal.parcelaActual().planta())
        }

        keyboard.z().onPressDo { principal.regar() }
        keyboard.b().onPressDo { principal.quitarParcela() }

        keyboard.p().onPressDo {
            principal.preparar(recetario.pocionPequena())
        }

        keyboard.o().onPressDo {
            principal.preparar(recetario.pocionMediana())
        }

        keyboard.u().onPressDo {
            principal.preparar(recetario.pocionMaxima())
        }
    }

    method teclasDeMinar() {
        keyboard.space().onPressDo {
            principal.minar()
        }
    }

    method cambiosEnergia() {
        game.addVisual(barraEnergia)
    }

    method configurarCiclo() {
        game.onTick(
            duracionDelDia,
            "ciclo",
            { ciclo.cambiarCiclo() }
        )
    }
}