//plantas
import wollok.game.*
import ciclo.*
import objetos.*
import escenarios.*
import herramientas.*

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
  method desarmar() {
    
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
            granja.registrar(unaPlanta) 
            game.addVisual(unaPlanta) }
    }

    method regar() {
      planta.regar()
    }

   method desarmar() {
    if (!self.estaLibre()) { 
        game.removeVisual(planta) }
        game.removeVisual(self)
    }

}

class Plantas {
    var property position 
    var nRiegos = 0
    var cosechable = false  //1 para brote, 2 para cosechable
    var valor_mercado = 0

    method regar(){
        nRiegos +=1
        self.crecer()
    }

    method cicloAdecuado() = true

    method riegosNecesarios() = 1
    
    method tieneRiegosSuficientes() = nRiegos >= self.riegosNecesarios()

    method puedeCrecer() = self.tieneRiegosSuficientes() && self.cicloAdecuado()//este metodo marca la condifcion de si cumple con los requisitos para crecer

    method crecer(){
        if(self.puedeCrecer()){
            cosechable = true
        }
    }

    method estaCosechable() = cosechable

    method image(){
        if (self.estaCosechable()){
            return self.imagenCosechada()
        } else {
            return self.imagenBrote()
        }
    }

    method imagenBrote() {
      return }

    method imagenCosechada() {
      return }

    method estaLibre() = false

    method sepuedecosechar () = self.estaCosechable() && self.cicloAdecuado()
}

class Girasol inherits Plantas{
    override method cicloAdecuado() = ciclo.esDeDia()

    override method imagenBrote () = "broteGirasol.png"
    override method imagenCosechada () = "girasol.png"

    method recurso() = new Recursos(nombre = 'girasol',cantidad = 1)
    method nombreSemilla() = "semillaGirasol"
}

class PlantaLunar inherits Plantas{
    override method cicloAdecuado() = !ciclo.esDeDia()

    override method imagenBrote () = "broteLunar.png"
    override method imagenCosechada () = "plantaLunar.png"

    method recurso() = new Recursos(nombre = 'plantalunar',cantidad = 1)

    override method sepuedecosechar() =
    self.estaCosechable() &&
    (self.cicloAdecuado() || azada.mejorada())
    method nombreSemilla() = "semillaLunar"
}

class RosaMagica inherits Plantas {
    override method cicloAdecuado() = !ciclo.esDeDia()

    override method imagenBrote () = "broteRosa.png"
    override method imagenCosechada () = "rosa.png"

    method recurso() = new Recursos(nombre = 'rosa',cantidad = 1)

    override method sepuedecosechar() = 
    self.estaCosechable() &&
    (self.cicloAdecuado() || azada.mejorada())
    method nombreSemilla() = "semillaRosa"
    
}

class Mandragora inherits Plantas {
    override method riegosNecesarios() = if (ciclo.esDeDia()) 2 else 1

    override method imagenBrote () = "broteMandragora.png"
    override method imagenCosechada () = "mandragora.png"

    method recurso() = new Recursos(nombre = 'mandragora',cantidad = 1)
    method nombreSemilla() = "semillaMandragora"
}

class Hongo inherits Plantas {
    override method riegosNecesarios() = 3

    override method imagenBrote () = "broteHongo.png"
    override method imagenCosechada () = "hongo.png"

    method recurso() = new Recursos(nombre = 'hongo',cantidad = 1)
    method nombreSemilla() = "semillaHongo"
}