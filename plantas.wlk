//plantas
import wollok.game.*
import ciclo.*

object sinPlanta{
    method regar() {
      
    }
    method crecer() {
      
    }
    method estaLibre() = true
}

object sinParcela {
  method sembrar(unaPlanta) {
    
  }
  method regar() {
    
  }
}
class Parcela {
    var property position
    var property planta = sinPlanta

    method image() = "parcelaTierra.png"

    method estaLibre() = planta.estaLibre()

    method sembrar(unaPlanta){
        if(self.estaLibre()){
            planta = unaPlanta
            game.addVisual(unaPlanta) }
    }

    method regar() {
      planta.regar()
    }
}
/**
 * Planta que se siembra, se riega y crece cuando cumple sus condiciones.
 * Cada tipo de planta redefine `puedeCrecer()` y sus imagenes.
 */
class Plantas {
    var property position 
    var nRiegos = 0
    var etapa = 1  //1 para brote, 2 para cosechable

    method regar(){
        nRiegos +=1
        self.crecer()
    }

    method puedeCrecer(){//este metodo marca la condifcion de si cumple con los requisitos para crecer
        return false
    }

    method crecer(){
        if(self.puedeCrecer()){
            etapa =2
        }
    }

    method image(){
        if (etapa == 2){
            return self.imagenCosechada()
        } else {
            return self.imagenBrote()
        }
    }

    method imagenBrote() {
      return ""
    }

    method imagenCosechada() {
      return ""
    }

    method estaLibre() = false
}

class Girasol inherits Plantas{ //solo crece si es de dia, debe ser regado al menos una vez
    override method puedeCrecer() {
        return nRiegos >= 1 && ciclo.esDeDia()
    }

    override method imagenBrote () = "broteGirasol.png"
    override method imagenCosechada () = "girasol.png"
}

class PlantaLunar inherits Plantas{//solo crece si es de noche, debe ser regado al menos una vez
    override method puedeCrecer() {
        return nRiegos >= 1 && !ciclo.esDeDia()
    }

    override method imagenBrote () = "broteLunar.png"
    override method imagenCosechada () = "plantaLunar.png"
}

class RosaMagica inherits Plantas {//hay que regarla solo una vez y crece de noche
    override method puedeCrecer(){
        return nRiegos >= 1 && !ciclo.esDeDia()
    }

    override method imagenBrote () = "broteRosa.png"
    override method imagenCosechada () = "rosa.png"
    
}

class Mandragora inherits Plantas {//hay que regarla una vez a la noche y 2 en el dia
    override method puedeCrecer(){
        return (!ciclo.esDeDia() && nRiegos >= 1) || (ciclo.esDeDia() && nRiegos >= 2)
    }

    override method imagenBrote () = "broteMandragora.png"
    override method imagenCosechada () = "mandragora.png"
}

class Hongo inherits Plantas {//hay que regarla 3 veces
    override method puedeCrecer(){
        return nRiegos >= 3
    }

    override method imagenBrote () = "broteHongo.png"
    override method imagenCosechada () = "hongo.png"
}