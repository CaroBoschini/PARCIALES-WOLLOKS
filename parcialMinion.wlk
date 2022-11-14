//PARCIAL MINIONS
class Rol {
	method tieneTodasLasHerramientas(herramientas) = false
	
	method estasDispuestoADefenderSector() = true
	
	method fuerza(fuerzaBase) = fuerzaBase
	
	method defendisteSector(empleado) {
		empleado.disminuirEstaminaEn(empleado.estamina() / 2)
	}
	
	method puedeLimpiarSector(empleado, sector) =
		empleado.estamina() >= sector.estaminaRequerida()
		
	method limpiasteSector(empleado, sector) {
		empleado.disminuirEstaminaEn(sector.estaminaRequerida())
	}
	
	method realizarTarea(empleado, tarea) {
		tarea.serRealizadaPor(empleado)
		empleado.hicisteTarea(tarea)
	}
	
	method puedeRealizarTarea(empleado, unaTarea) =
		unaTarea.requisitosSonCumplidosPor(empleado)
}

class Capataz inherits Rol {
	const subordinados = []
	
	override method realizarTarea(empleado, tarea) {
		const subordinadosQuePuedenHacerLaTarea = subordinados.filter { subordinado => tarea.puedeSerRealizadaPor(subordinado) }
		if(subordinadosQuePuedenHacerLaTarea.isEmpty()) {
			super(empleado, tarea)
		} else {
			const quienHaceLaTarea = subordinadosQuePuedenHacerLaTarea.max { subordinado => subordinado.experiencia() }
			quienHaceLaTarea.realizarTarea(tarea)
			empleado.hicisteTarea(tarea)
		}
	}
	
	override method puedeRealizarTarea(empleado, unaTarea) =
		subordinados.any {
			subordinado => subordinado.puedeRealizarTarea(unaTarea)
		} || super(empleado, unaTarea)
}

class Soldado inherits Rol {
	var danioExtraPorPractica = 0
	
	method danioExtraPorPractica() = danioExtraPorPractica 

	override method fuerza(fuerzaBase) = fuerzaBase + danioExtraPorPractica
	
	override method defendisteSector(_empleado) {
		danioExtraPorPractica += 2
	}
}

class Mucama inherits Rol {
	override method estasDispuestoADefenderSector() = false
	
	override method puedeLimpiarSector(_empleado, _sector) = true
	
	override method limpiasteSector(empleado, sector) {
	}
}

class Obrero inherits Rol {
	const herramientasEnCinturon = []

	override method tieneTodasLasHerramientas(herramientasNecesarias) =
		herramientasNecesarias.all { herramienta =>
			herramientasEnCinturon.contains(herramienta)
		}
}


class Empleado {
	var estamina = 0
	const tareasRealizadas = []
	const rol = new Obrero()

	method estamina() = estamina
	
	method experiencia() =
		tareasRealizadas.sum { tarea =>
			tarea.dificultadPara(self)
		} * tareasRealizadas.size()
	
	method comer(fruta) {
		estamina = self.estaminaResultanteTrasComer(fruta)
	}
	
	method disminuirEstaminaEn(cantidad) {
		estamina -= cantidad
	}
	
	method hicisteTarea(unaTarea) {
		tareasRealizadas.add(unaTarea)
	}

	method realizarTarea(unaTarea) {
		rol.realizarTarea(self, unaTarea)
	}

	method estaminaResultanteTrasComer(fruta) {
		return estamina + fruta.estaminaQueRecupera()
	}
	
	method fuerza() {
		return rol.fuerza(estamina / 2 + 2)
	}
	
	method estasDispuestoADefenderSector() {
		return rol.estasDispuestoADefenderSector()
	}
	
	method tieneTodasLasHerramientas(herramientas) {
		return rol.tieneTodasLasHerramientas(herramientas)
	}
	
	method defendisteSector() {
		return rol.defendisteSector(self)
	}
	
	method puedeLimpiarSector(sector) {
		return rol.puedeLimpiarSector(self, sector)
	}
	
	method limpiasteSector(sector) {
		return rol.limpiasteSector(self, sector)
	}
	
	method puedeRealizarTarea(unaTarea) {
		return rol.puedeRealizarTarea(self, unaTarea)
	}
}

class Ciclope inherits Empleado {
	method dificultadDeDefenderUnSector(defenderSector) =
		defenderSector.gradoDeAmenaza() * 2
	
	override method fuerza() = super() / 2
}

class Biclope inherits Empleado {
	method limiteDeEstamina() = 10
	
	method dificultadDeDefenderUnSector(defenderSector) =
		defenderSector.gradoDeAmenaza()

	override method estaminaResultanteTrasComer(fruta) {
		return super(fruta).min(self.limiteDeEstamina())
	}
}

class Uva {
	method estaminaQueRecupera() = 1
}

class Manzana {
	method estaminaQueRecupera() = 5
}

class Banana {
	method estaminaQueRecupera() = 10
}

class Tarea {
	method serRealizadaPor(empleado) {
		if(not self.puedeSerRealizadaPor(empleado)) {
			self.error("No se cumplieron los requerimientos para realizar la tarea")
		}
		self.seRealizoLaTarea(empleado)
	}
	
	method seRealizoLaTarea(empleado)
	
	method puedeSerRealizadaPor(empleado) {
		return empleado.puedeRealizarTarea(self)
	}
	
	method requisitosSonCumplidosPor(empleado)
}

class ArreglarMaquina inherits Tarea {
	const complejidadDeLaMaquina
	const herramientasNecesarias = []
	
	method dificultadPara(_empleado) = complejidadDeLaMaquina * 2
	
	override method seRealizoLaTarea(empleado) {
		empleado.disminuirEstaminaEn(complejidadDeLaMaquina)
	}
	
	override method requisitosSonCumplidosPor(empleado) {
		return (empleado.estamina() >= complejidadDeLaMaquina) &&
			empleado.tieneTodasLasHerramientas(herramientasNecesarias)
	}
}

class DefenderSector inherits Tarea {
	const gradoDeAmenaza
	
	method gradoDeAmenaza() = gradoDeAmenaza
	
	method dificultadPara(empleado) {
		return empleado.dificultadDeDefenderUnSector(self)
	}
	
	override method requisitosSonCumplidosPor(empleado) {
		return empleado.estasDispuestoADefenderSector() && empleado.fuerza() >= gradoDeAmenaza
	}
	
	override method seRealizoLaTarea(empleado) {
		empleado.defendisteSector()
	}
}

class LimpiarSector inherits Tarea {
	const grande = false

	method dificultadPara(_empleado) = tareasDeLimpieza.dificultad()
	
	override method requisitosSonCumplidosPor(empleado) = empleado.puedeLimpiarSector(self)
	
	method estaminaRequerida() = if(grande) 4 else 1
	
	override method seRealizoLaTarea(empleado) {
		empleado.limpiasteSector(self)

	}
}

object tareasDeLimpieza {
	var dificultad = 10
	
	method dificultad(){
		return dificultad
	}
	
	method configurarDificultad(nuevaDificultad){
		dificultad = nuevaDificultad
	}
}
