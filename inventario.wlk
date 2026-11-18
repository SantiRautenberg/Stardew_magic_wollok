import personaje.*
import wollok.game.*

class Inventario {
    var property items = []

    method add(elemento) {
        if (items.any({item => item.nombre() == elemento.nombre()})){
            const existente = items.find({item => item.nombre() == elemento.nombre()})
            existente.sumRecurso(elemento.cantidad())}
        else {
            items.add(elemento)
            }
    }
    method tieneUnidad(nombreRecurso) = 
    items.any({ item =>
        item.nombre() == nombreRecurso && item.cantidad() > 0
    })

    method remove(elemento) {
        items.remove(elemento)}

    method contains(elemento) {
        return items.contains(elemento)}

    method descontar(nombreRecurso, unidades) {
      const recurso = items.findOrDefault({item => item.nombre() == nombreRecurso}, null)
      if (recurso != null) {
        recurso.cantidad(recurso.cantidad() - unidades)
        if(recurso.cantidad() == 0) {
            items.remove(recurso)
        }
      }
    }
}

object fondoInventario {
    method image() = "fondo_inventario.png"
    method position() = game.at(0, 0) 
    method zIndex() = 100 
}

object controladorInventarioVisual {
    var abierto = false
    const columnasPorFila = 20 
    const contadoresVisibles = []
    method alternar() {
        if (abierto) {
            self.cerrar()
        } else {
            self.abrir()
        }
    }

    method calcularFilaItem(indice) = indice.div(columnasPorFila)
    method calcularColumnaItem(indice) = indice % columnasPorFila 
    
    method abrir() {
        abierto = true
        if (!game.hasVisual(fondoInventario)) {
            game.addVisual(fondoInventario)
        }
        const elementosVisuales = principal.inventario().items()
        const xInicial = 0 
        const yInicial = 2
        
        var indice = 0 

        elementosVisuales.forEach({ elementoVisual => 
            self.ubicarItem(elementoVisual, indice, xInicial, yInicial)
            self.gestionarContador(elementoVisual)

            indice = indice + 1
        })
    }

    method ubicarItem(elementoVisual, indice, xInicial, yInicial){
        const columna = self.calcularColumnaItem(indice)
        const fila = self.calcularFilaItem(indice)
        elementoVisual.position(game.at(xInicial + columna, yInicial - fila))
        if (!game.hasVisual(elementoVisual)) {
            game.addVisual(elementoVisual)
        }
    }

    method gestionarContador(elementoVisual){
        if (elementoVisual.cantidad() > 1) {
            const contador = new ContadorVisual(itemAsociado = elementoVisual)
            if (!game.hasVisual(contador)) {
                game.addVisual(contador)
                contadoresVisibles.add(contador)
            }
        }

    }

    method cerrar() {
        abierto = false
        const items = principal.inventario().items()
        items.forEach({ item => 
            if (game.hasVisual(item)) {
                game.removeVisual(item)
            }
        })

        contadoresVisibles.forEach({ contador =>
            if (game.hasVisual(contador)) {
                game.removeVisual(contador)
            }
        })

        contadoresVisibles.clear()

        if (game.hasVisual(fondoInventario)) {
            game.removeVisual(fondoInventario)
        }
    }
}

class ContadorVisual {
    const itemAsociado
    method position() {
        return itemAsociado.position().down(0.5)
    }
    method text() = itemAsociado.cantidad().toString()
    method textColor() = "FFFF00" 
    method zIndex() = 102 
}
object contadorMonedas {
    method position() = game.at(1, 19)

    method text() = "Monedas: " + principal.dinero()

    method textColor() = "FFFF00"

    method zIndex() = 103
}