/**
 * Herramientas que puede llevar el mago en la mano.
 *
 * Cada herramienta sabe cual es la imagen del personaje en cada situacion
 * (quieto, caminando y usandola), asi `principal` no necesita preguntar
 * "que herramienta tengo?" con ifs: le pide la imagen a la que tenga equipada
 * (polimorfismo).                         (icono para el inventario)
 */
class Herramienta {
    const property nombre

    method imagenQuieto(direccion) = nombre + "_idle_" + direccion + ".png"
    method imagenCaminando(direccion, frame) = nombre + "_caminar_" + direccion + "_" + frame + ".png"
    method imagenUsando(direccion, frame) = nombre + "_usar_" + direccion + "_" + frame + ".png"
    method icono() = nombre + ".png"
    method sePuedeUsar() = true
}

object hacha inherits Herramienta(nombre = "hacha") { }

object pala inherits Herramienta(nombre = "pala") { }

object azada inherits Herramienta(nombre = "azada") { }

/** Cuando el mago no lleva nada usa las imagenes "caminar_*" (con su baston). */
object sinHerramienta {
    method imagenQuieto(direccion) = "caminar_" + direccion + "_1.png"
    method imagenCaminando(direccion, frame) = "caminar_" + direccion + "_" + frame + ".png"
    method imagenUsando(direccion, frame) = self.imagenQuieto(direccion)
    method sePuedeUsar() = false
}
