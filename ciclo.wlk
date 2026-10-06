import stardew.*
import mapa.*
object ciclo{
    var property esDia = true

    method esDeDia(){
        return esDia
    }

    method cambiarCiclo(){
        esDia = !esDia
        if (esDia ) {
        game.boardGround('MapaDia.png')}
        else {
            game.boardGround('MapaNoche.gif')
        }
    }
}

    object fondo {
    method position() = game.at(0, 0)

    method image() =
        if (ciclo.esDia()) "MapaDia.gif"
        else "MapaNoche.gif"
}