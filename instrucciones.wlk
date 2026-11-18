import wollok.game.*

object imagenInstrucciones {
  method image() = "instrucciones.png"
  method position() = game.at(1, 0)  
}

object controlarInstrucciones {
  var abierto = false

  method alternar() {
    if (abierto) self.cerrar() else self.abrir()
  }

  method abrir() {
    abierto = true
    if (!game.hasVisual(imagenInstrucciones)){
        game.addVisual(imagenInstrucciones)
    }
  }

  method cerrar() {
    abierto = false
    if (game.hasVisual(imagenInstrucciones)){
        game.removeVisual(imagenInstrucciones)
    }
  }
}
