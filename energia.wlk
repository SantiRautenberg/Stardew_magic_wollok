import personaje.*
import wollok.game.*
class SistemaEnergia {
    var energiaActual = 100
    const energiaMaxima = 100

    method energia() = energiaActual

    method gastar(cantidad) {
        energiaActual = 0.max(energiaActual - cantidad)
    }

    method recuperar(cantidad) {
        energiaActual = energiaMaxima.min(energiaActual + cantidad)
    }

    method dormir() {
        energiaActual = energiaMaxima
    }

    method estaCansado() {
        return energiaActual <= 0 || energiaActual <= 5
    }

}
object barraEnergia {
    method position() = game.at(16, 0)

    method image() {
        const energia = principal.energia()
        
        if (energia > 70) return "energia_100.png"
        if (energia > 50) return "energia_70.png"
        if (energia > 20) return "energia_50.png"
        if (energia > 5)  return "energia_20.png"
        
        return "energia_5.png" 
    }
}