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
        var property escenario = "granja" 
    method position() = game.at(0, 0)

    method image() =
        if (escenario == 'granja'){
            if (ciclo.esDia()) "MapaDia.gif"
            else "MapaNoche.gif"}

        else if (escenario == 'pueblo'){
                if (ciclo.esDia()) {"puebloDia.gif"}
                else "pueblonoche.gif"  

        }
        else if (escenario == 'bosque'){
                if (ciclo.esDia()) {"bosqueDia.gif"}
                else "bosqueNoche.gif"            
        }
        else if( escenario == 'mina'){
                'mina.gif'}
}