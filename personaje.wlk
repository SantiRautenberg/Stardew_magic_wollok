import navegacion.*
import interacciones.*
import plantas.*
import wollok.game.*
import mapa.*
import herramientas.*
import objetos.*
import animacion.*
import recetas.*
import inventario.*
import ciclo.*
import escenarios.*
import energia.*
import mercado.*
import combate.*

class Personaje {
    var property nombre = ""
    var property vida = 100
    var property hambre = 0
    var property dinero = 0
    const property inventario = new Inventario() 
    const sistemaEnergia = new SistemaEnergia()
    const plantas = []
    const parcelas = []

    method energia() = sistemaEnergia.energia()

    method dormir() {
        sistemaEnergia.dormir()
    }

    method recibirDanio(cantidad) {
        vida = 0.max(vida - cantidad)
    }

    method recuperarEnergia(cantidad) {
        sistemaEnergia.recuperar(cantidad)
    }
    
    method gastarEnergia(cantidad) {
        sistemaEnergia.gastar(cantidad)
    }

    method estaCansado() {
        return sistemaEnergia.estaCansado()
    }
    
    method comer(alimento) {
        hambre = 0.max(hambre - alimento.calorias())
        sistemaEnergia.recuperar(alimento.energiaQueAporta())
    }
    
    method agarrar(elemento) {
        inventario.add(elemento)
        if (game.hasVisual(elemento)) {
            game.removeVisual(elemento)
        }
    }

    method vender(elemento, precio) {
        if (inventario.contains(elemento)) {
            inventario.remove(elemento)
            dinero = dinero + precio
        } else {
            self.error("El personaje no tiene ese item en su inventario.")
        }
    }

    method comprar(elemento, precio) {
        if (dinero >= precio) {
            dinero = dinero - precio
            inventario.add(elemento)
        } else {
            self.error("No tenes suficiente dinero.")
        }
    }

    method siHayEnergiaHacer(accion) {
        if (self.estaCansado()) {
            game.say(self, "¡Estoy demasiado cansado, necesito descansar!")
        } else {
            accion.apply()
        }
    }

   
}

object principal inherits Personaje {
    var property casa = null
    var property obs = []

    var property position = game.at(11, 7)      
    var mirando = "abajo"

    // --- combate ---
    const danioDelBaston = 1
    const energiaPorAtaque = 2                  
    const tiempoDeInvulnerabilidad = 1000       
    var ultimoDanioRecibido = -10000

    const animador = new Animador()

    method objetoEnMiPosicion() {
    return game.getObjectsIn(position).find({ objeto => objeto != self })} 

    method quedaobjeto(planta) = inventario.tieneUnidad(planta.nombreSemilla()) 
    

    // ---------- animacion ----------
    method image() = animador.imagen(mirando)

    method iniciarAnimacion() {
        animador.iniciar()
    }

    // ---------- herramientas ----------
    method herramienta() = animador.herramienta()

    method equipar(unaHerramienta) {
        animador.equipar(unaHerramienta)
    }

    method guardarHerramienta() {
        animador.equipar(sinHerramienta)
    }

    method interactuar() {
        interaccionesMercado.interactuar(self)
    }

    method usarHerramienta() {
        if (animador.puedeUsarHerramienta()) {
            animador.empezarAUsarHerramienta()
            self.herramienta().usar(self)
        }
    }

    // ---------- movimiento ----------
    method destino(dir) =
        if (dir == "derecha") position.right(1)
        else if (dir == "izquierda") position.left(1)
        else if (dir == "arriba") position.up(1)
        else position.down(1)

    method mover(dir) {
        if (animador.puedeDarUnPaso()) {
            const proximaPosicion = self.destino(dir)
            mirando = dir
            if (!self.hayObstaculoEn(proximaPosicion)) {
                self.irA(proximaPosicion)
                self.ingresarAcasa(proximaPosicion)
                animador.darUnPaso()
            }
        }
    }

    method hayObstaculoEn(posicion) = obs.any({ obstaculo => obstaculo.ocupa(posicion) })

    method irA(nuevaPosicion) {
        if (mapa.estaLibre(nuevaPosicion)) {
            position = nuevaPosicion
            self.revisarSalida()
        }
    }

    method revisarSalida() {
        navegacion.revisarSalida(self)
    }

    method minar() {
        const enfrente = self.destino(mirando)

        if (mapa.hayMineralEn(enfrente)) {
            mapa.mineralEn(enfrente).serMinadoPor(self)
        } else {
            game.say(self, "No hay ningún mineral enfrente")
        }
    }

    // ---------- combate (solo con el baston equipado: ver sinHerramienta.usar) ----------
    method pelear(enemigo) {
        enemigo.recibirDanio(danioDelBaston)
    }

    method atacar() {
        self.siHayEnergiaHacer({
            self.gastarEnergia(energiaPorAtaque)
            self.pelear(combate.enemigoEn(self.destino(mirando)))
        })
    }

    method estaInvulnerable() = game.currentTime() - ultimoDanioRecibido < tiempoDeInvulnerabilidad

    override method recibirDanio(cantidad) {
        if (!self.estaInvulnerable()) {
            super(cantidad)
            ultimoDanioRecibido = game.currentTime()
            if (self.vida() > 0) {
                game.say(self, "¡Auch! -" + cantidad)
            } else {
                self.reaparecer()
            }
        }
    }

    method reaparecer() {
        self.vida(100)
        position = combate.entradaDelBosque()
        animador.quedarseQuieto()
        game.say(self, "Te derrotaron. Reapareces en la entrada")
    }

    method intentarTalar (){                  
        const enfrente = self.destino(mirando)  
   
        if (mapa.hayArbolEn(enfrente)) {
        self.talar(mapa.arbolEn(enfrente))
    }
    }

    method talar(objeto) {
        self.siHayEnergiaHacer({ 
            const recurso = objeto.recurso()
            if (hacha.mejorada() && objeto.admiteDobleRecurso() && 0.randomUpTo(1) < 0.5) {
                recurso.cantidad(recurso.cantidad() * 2)
            }
            inventario.add(recurso)
            obs.remove(objeto)              
            mapa.quitar(objeto)             
            granja.retirar(objeto)
            self.gastarEnergia(5)
        })
    }

    method cosechar(planta) {
        self.siHayEnergiaHacer({
            if (planta.sepuedecosechar()) {
                const parcela = parcelas.find({parcela => parcela.position() == planta.position()})
                parcela.planta(sinPlanta)           
                inventario.add(planta.recurso())    
                granja.retirar(planta)
                self.gastarEnergia(5)
            }
        })
    }
    method levantar(objeto) {           
        inventario.add(objeto.recurso())
        granja.retirar(objeto)
    }

    method parcelaActual() {
        if (parcelas.any({ parcela => parcela.position() == self.position() })) {
            return parcelas.find({ parcela => parcela.position() == self.position() })
        } else {
            return sinParcela
        }
    }

    method quitarParcela() {
        const parcela = self.parcelaActual()
        if (parcela != sinParcela) {
            if (parcela.estaLibre()) {
                parcela.desarmar()
                parcelas.remove(parcela)
            }
        }
    }
    //=====resuelve el tema del topo=======
     method visual_glitch(){
      game.removeVisual(self)
      game.addVisual(self)}

    method ponerParcela() {
        if (fondo.escenario() == 'granja'){
            self.siHayEnergiaHacer({
                const parcela = new Parcela (position = self.position())
                parcelas.add(parcela)
                granja.registrar(parcela)
                self.gastarEnergia(10)
                game.addVisual(parcela)
                self.visual_glitch()
            })
        }
    }

method plantar(planta) {
    if (fondo.escenario() == "granja") {
        const parcela = self.parcelaActual()

        if (parcela != sinParcela) { 
            if (parcela.estaLibre() && self.quedaobjeto(planta)) {
                self.siHayEnergiaHacer({
                    parcela.sembrar(planta)
                    inventario.descontar(planta.nombreSemilla(), 1)
                    self.gastarEnergia(5)
                    self.visual_glitch()
                })
            }
        }
    }
}

    method regar() {
      self.parcelaActual().regar()
    }

    method preparar(receta) {
        if (receta.puedePrepararse(inventario)){
            receta.preparar(self)
            game.say(self, "Prepare " + receta.pocion().nombre() + ". Energia: " + self.energia())
        } else {
            game.say(self, "Me faltan ingredientes")
        }
    }

   // ----- DORMIR ----

    method estaEnCasa(nuevaPos) {
       return casa != null && casa.ocupa(nuevaPos)
    }

    method ingresarAcasa(nuevaPos) {
        if (game.hasVisual(casa) && self.estaEnCasa(nuevaPos)) {
            if (game.hasVisual(self)) {
                game.removeVisual(self)
                self.dormir()
            }
        } else {
            if (!game.hasVisual(self)) {
                game.addVisual(self)
            }
        } 
    }

    override method dormir() {
        if (ciclo.esDeDia() && self.estaEnCasa(self.position())) {
            game.say(self, "¡Aún es de día, hay mucho por hacer!")
        }
        if (!ciclo.esDeDia() && self.estaEnCasa(self.position())) {
            super()
        }
    }

}
