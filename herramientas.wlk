import personaje.*
import mercado.*

class Herramienta {
    const property nombre

    method imagenQuieto(direccion) = nombre + "_idle_" + direccion + ".png"
    method imagenCaminando(direccion, frame) = nombre + "_caminar_" + direccion + "_" + frame + ".png"
    method imagenUsando(direccion, frame) = nombre + "_usar_" + direccion + "_" + frame + ".png"
    method icono() = nombre + ".png"
    method sePuedeUsar() = true
    method usar(personaje) {}
}

object hacha inherits Herramienta(nombre = "hacha") {
    var property mejorada = false

    method mejorar() {
        mejorada = true
    }
        override method usar(personaje) {          
        personaje.intentarTalar()                  
    }
 }

object pico inherits Herramienta(nombre = "pico") {
    var property mejorado = false

    override method usar(personaje) {
        personaje.minar()
    }

    method mejorar() {
        mejorado = true
    }

    method costoMinar(costoEnergia) =
        if (mejorado) costoEnergia * 0.75
        else costoEnergia
}
object azada inherits Herramienta(nombre = "azada") {
    var property mejorada = false

    method mejorar() {
        mejorada = true
    }
    override method usar(personaje) {   
        personaje.ponerParcela()        
    }
 }

object sinHerramienta {
    method imagenQuieto(direccion) = "caminar_" + direccion + "_1.png"
    method imagenCaminando(direccion, frame) = "caminar_" + direccion + "_" + frame + ".png"
    method imagenUsando(direccion, frame) = self.imagenQuieto(direccion)
    method sePuedeUsar() = true
    method usar(personaje) {
        personaje.atacar() 
    }
}
