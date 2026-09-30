import wollok.game.*

// Limites del tablero: evita que el personaje se salga de la pantalla
object mapa {
  method contiene(posicion) =
    posicion.x() >= 0 && posicion.x() < game.width() &&
    posicion.y() >= 0 && posicion.y() < game.height()
}
