import wollok.game.*
import ciclo.*
import objetos.*
class Pocion {
  const property nombre = "" 
  const property energiaQueAporta = 0

  method usar(personaje) {
    personaje.recuperarEnergia(energiaQueAporta)
  }
}

class Receta {
  const ingredientes
  const property pocion

    method puedePrepararse(inventario) = 
    ingredientes.all({ingrediente => inventario.items().any({item => item.nombre() == ingrediente.nombre() && item.cantidad() >= ingrediente.cantidad()})})

    method preparar(personaje) {
        ingredientes.forEach({ingrediente => personaje.inventario().descontar(ingrediente.nombre(), ingrediente.cantidad())})
        pocion.usar(personaje)
      
    }
}

object recetario {
  const property pocionPequena = new Receta( ingredientes = [new Recursos(nombre = "mandragora", cantidad = 1)],
  pocion = new Pocion(nombre = "pocion pequena", energiaQueAporta = 20))

  const property pocionMediana = new Receta( ingredientes = [new Recursos(nombre = "mandragora", cantidad = 1), new Recursos(nombre = "rosa", cantidad = 1)],
  pocion = new Pocion(nombre = "pocion mediana", energiaQueAporta = 50))

  const property pocionMaxima = new Receta( ingredientes = [new Recursos(nombre = "girasol", cantidad = 1), new Recursos(nombre = "hongo", cantidad = 1),new Recursos(nombre = "rosa", cantidad = 1)],
  pocion = new Pocion(nombre = "pocion maxima", energiaQueAporta = 100))
}