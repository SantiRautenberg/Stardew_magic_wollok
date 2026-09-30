import wollok.game.*
import mapa.*

object personaje {
  var property position = game.at(10, 10)
  var mirando = "abajo"          // abajo | arriba | izquierda | derecha
  var caminando = false
  var frame = 1
  var ultimoMovimiento = 0

  // quieto: assets/idle_<direccion>.png
  // caminando: assets/caminar_<direccion>_<1..4>.png
  method image() =
    if (caminando) "caminar_" + mirando + "_" + frame + ".png"
    else "idle_" + mirando + ".png"

  method iniciar() {
    // si dejo de apretar teclas, vuelve a la pose quieta
    game.onTick(100, "personajeQuieto", {
      if (caminando && game.currentTime() - ultimoMovimiento > 220) {
        caminando = false
        frame = 1
      }
    })
  }

  method destino(dir) =
    if (dir == "derecha") position.right(1)
    else if (dir == "izquierda") position.left(1)
    else if (dir == "arriba") position.up(1)
    else position.down(1)

  method mover(dir) {
    if (game.currentTime() - ultimoMovimiento >= 120) {
      mirando = dir
      const nuevaPosicion = self.destino(dir)
      if (mapa.contiene(nuevaPosicion)) {
        position = nuevaPosicion
      }
      caminando = true
      frame = if (frame == 4) 1 else frame + 1
      ultimoMovimiento = game.currentTime()
    }
  }
}
