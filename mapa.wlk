import wollok.game.*

// Limites del tablero: evita que el personaje se salga de la pantalla
class mapa {
  method contiene(posicion) =
    posicion.x() >= 0 && posicion.x() < game.width() &&
    posicion.y() >= 0 && posicion.y() < game.height()
}

class casa {
  method image() = 'casa.png' 
  method position() = game.at(8,8)
}
