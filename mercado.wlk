import objetos.*
import herramientas.*

class Mejora {
    const precio
    const ingredientes
    const herramienta
    method cumpleCondiciones()
    method puedeComprarse(personaje) = self.cumpleCondiciones() &&
        personaje.dinero() >= precio && ingredientes.all({ ingrediente =>
            personaje.inventario().items().any({ item =>
                item.nombre() == ingrediente.nombre() && item.cantidad() >= ingrediente.cantidad()
            })
        })
    method comprar(personaje) {
        if (self.puedeComprarse(personaje)) {
            ingredientes.forEach({ ingrediente =>
                personaje.inventario().descontar(ingrediente.nombre(), ingrediente.cantidad())
            })
            personaje.dinero(personaje.dinero() - precio)
            herramienta.mejorar()
        }
    }
}

object mejoraPico inherits Mejora(
    precio = 40, herramienta = pico,
    ingredientes = [
        new Recursos(nombre = "piedra", cantidad = 2),
        new Recursos(nombre = "palo", cantidad = 6)
    ]
) {
    override method cumpleCondiciones() = !pico.mejorado()
}

object mejoraAzada inherits Mejora(
    precio = 60, herramienta = azada,
    ingredientes = [
        new Recursos(nombre = "piedra", cantidad = 4),
        new Recursos(nombre = "palo", cantidad = 12)
    ]
) {
    override method cumpleCondiciones() = pico.mejorado() && !azada.mejorada()
}

object mejoraHacha inherits Mejora(
    precio = 100, herramienta = hacha,
    ingredientes = [
        new Recursos(nombre = "piedra", cantidad = 20),
        new Recursos(nombre = "palo", cantidad = 18)
    ]
) {
    override method cumpleCondiciones() = pico.mejorado() && azada.mejorada() && !hacha.mejorada()
}

object categoriaPlantas {}
object categoriaMinerales {}

class Cotizacion {
    const property nombre
    const property categoria
    const property precio
    method correspondeA(recurso) = nombre == recurso.nombre()
    method importePara(recurso) = precio * recurso.cantidad()
}

object catalogoMercado {
    const cotizaciones = [
        new Cotizacion(nombre = "girasol", categoria = categoriaPlantas, precio = 5),
        new Cotizacion(nombre = "mandragora", categoria = categoriaPlantas, precio = 15),
        new Cotizacion(nombre = "rosa", categoria = categoriaPlantas, precio = 20),
        new Cotizacion(nombre = "plantalunar", categoria = categoriaPlantas, precio = 25),
        new Cotizacion(nombre = "hongo", categoria = categoriaPlantas, precio = 10),
        new Cotizacion(nombre = "cobre", categoria = categoriaMinerales, precio = 3),
        new Cotizacion(nombre = "hierro", categoria = categoriaMinerales, precio = 8),
        new Cotizacion(nombre = "diamante", categoria = categoriaMinerales, precio = 15)
    ]
    method cotizacionDe(recurso) = cotizaciones.findOrDefault(
        { cotizacion => cotizacion.correspondeA(recurso) }, null
    )
}

class Comprador {
    const categoriaAceptada
    method acepta(recurso) {
        const cotizacion = catalogoMercado.cotizacionDe(recurso)
        return cotizacion != null && cotizacion.categoria() == categoriaAceptada
    }
    method precioUnitario(recurso) {
        const cotizacion = catalogoMercado.cotizacionDe(recurso)
        if (cotizacion != null && cotizacion.categoria() == categoriaAceptada) {
            return cotizacion.precio()
        } else {
            return 0
        }
    }
    method valorDe(recurso) = self.precioUnitario(recurso) * recurso.cantidad()
    method venderTodo(personaje) {
        const recursosAceptados = personaje.inventario().items().filter({ recurso => self.acepta(recurso) })
        recursosAceptados.forEach({ recurso =>
            personaje.dinero(personaje.dinero() + self.valorDe(recurso))
            personaje.inventario().descontar(recurso.nombre(), recurso.cantidad())
        })
    }
}

object compradorPlantas inherits Comprador(categoriaAceptada = categoriaPlantas) {}
object compradorMinerales inherits Comprador(categoriaAceptada = categoriaMinerales) {}

object vendedorSemillas {
    const precio = 20
    const semillas = [
        new Recursos(nombre = "semillaGirasol", cantidad = 4),
        new Recursos(nombre = "semillaMandragora", cantidad = 2),
        new Recursos(nombre = "semillaLunar", cantidad = 1),
        new Recursos(nombre = "semillaRosa", cantidad = 2),
        new Recursos(nombre = "semillaHongo", cantidad = 1)
    ]
    method puedeComprar(personaje) = personaje.dinero() >= precio
    method comprar(personaje) {
        if (self.puedeComprar(personaje)) {
            personaje.dinero(personaje.dinero() - precio)
            semillas.forEach({ semilla =>
                personaje.inventario().add(new Recursos(
                    nombre = semilla.nombre(), cantidad = semilla.cantidad()
                ))
            })
        }
    }
}
