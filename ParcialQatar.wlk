class Plato {
	const baseCalorias = 100
	const cocinero // necesario para el torneo
	
	method cocinero() = cocinero	
	
	method cantidadAzucar()
	
	// Punto de entrada punto 1
	method cantidadCalorias() = 3 * self.cantidadAzucar() + baseCalorias
}

class Entrada inherits Plato {
	method esBonito() = true
	override method cantidadAzucar() = 0
}

class Principal inherits Plato {
	const esBonito
	const cantidadAzucar
	
	method esBonito() = esBonito
	override method cantidadAzucar() = cantidadAzucar
}

class Postre inherits Plato {
	const cantColores
	
	method esBonito() = cantColores > 3 
	override method cantidadAzucar() = 120
}

class Cocinero {
	var especialidad
	
	// Punto de entrada punto 2.
	method calificacionPara(plato) = especialidad.catar(plato)
	
	// Punto de entrada punto 3.
	method cambiarEspecialidad(nuevaEspecialidad){
		especialidad = nuevaEspecialidad
	}
	
	// Punto de entrada punto 5.
	method cocinar() = especialidad.cocinar(self)
}

class EspecialidadPastelero {
	var dulzorDeseado
	
	method catar(plato) = (5 * plato.cantidadAzucar() / dulzorDeseado).min(10)
	
	method cocinar(elCocinero) = new Postre(cocinero = elCocinero, cantColores = dulzorDeseado / 50)
}

class EspecialidadChef {
	var cantidadCaloriasDeseadas
	
	method platoCumpleExpectativa(plato) = plato.esBonito() and plato.cantidadCalorias() <= cantidadCaloriasDeseadas
	
	method catar(plato) = if (self.platoCumpleExpectativa(plato)) 10 else self.calificacionSiNoCumpleExpectativa(plato)
	
	method calificacionSiNoCumpleExpectativa(plato) = 0
	
	method cocinar(elCocinero) = new Principal(cocinero = elCocinero, esBonito = true, cantidadAzucar = cantidadCaloriasDeseadas)
}

class EspecialidadSouschef inherits EspecialidadChef {	
	override method calificacionSiNoCumpleExpectativa(plato) = (plato.cantidadCalorias() / 100).min(6)
	
	override method cocinar(elCocinero) = new Entrada(cocinero = elCocinero)
}

class Torneo{
	const catadores = []
	const platosParticipantes = [] 
	
	// Punto de entrada punto 6a
	method sumarParticipacion(cocinero) {
		platosParticipantes.add(cocinero.cocinar())
	}
	
	// Punto de entrada punto 6b
	method ganador() {
		if (platosParticipantes.isEmpty()) 
			throw new DomainException(message = "No se puede definir el ganador de un torneo sin participantes")
		return platosParticipantes.max({plato => self.calificacionTotal(plato)}).cocinero()
	}
	
	method calificacionTotal(plato) = catadores.sum({catador => catador.catar(plato)})
	
}
