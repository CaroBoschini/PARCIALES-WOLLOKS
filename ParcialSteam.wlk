//parcial Steam

class Juego {
	var precio
	var tipoDescuento
	const caracteristicas = []
	const criticas = []
	var property cantCriticasPositivasNecesarias
		
	method caracteristicas(){
		return caracteristicas
	}
	
	method precio(){
		return precio
	}
	
	method cambiarDescuento(nuevoTipoDescuento){
		tipoDescuento = nuevoTipoDescuento
	}
	
	method tipoDescuento() = tipoDescuento
	
	method aplicarDescuento(){
		precio = tipoDescuento.realizarDescuento(self)
	} 
	
	method agregarDescuentoCaro(juegoMasCaro, nuevoTipoDescuento){
		if(self.juegoCaro(juegoMasCaro)){
			 self.cambiarDescuento(nuevoTipoDescuento) 
		} else
			 throw new DomainException(message = "No supera las tres cuartas partes del precio mas caro, no se le aplica descuento directo")
	}
	
	method juegoCaro(juegoMasCaro){
		return self.precio() >= juegoMasCaro.precio() * 0.75
	}
	
	method aptoParaMenoresEn(pais){
		return pais.juegoLegal(self)
	}
	
	method precialFinalEn(pais){
		return pais.dolarAMonedaLocal(self)
	}
	
	method RegistrarCritica(critica){
		criticas.add(critica.mostrarCritica())
	}
	
	method pasaElUmbral(){
		return criticas.filter{critica => critica.esPositiva(true)}.size() > cantCriticasPositivasNecesarias
	}
	
	method esGalardonado(){
		return criticas.filter{critica => critica.esPositiva(false)}.size() == 0
	}
}



class Pais { 
	const porcConversion
	const legislacionVigente = []
	
	method dolarAMonedaLocal(juego){
		if(self.juegoLegal(juego)){
			return (juego.precio()) * porcConversion
		} else 
			throw new DomainException(message = "El juego no esta a la venta para menores")
		
	}
	
	method juegoLegal(juego){
		return not(juego.caracteristicas().contains{caracteristica => legislacionVigente.contains(caracteristica)})
	}
}

object lengInapropiado{}
object sitViolencia{}
object tematicasAdult{}

//////
///DESCUENTOS
//////

class Descuento {
	method realizarDescuento(juego) = juego.precio()
}

class Directo inherits Descuento{
	var property porcentajeDescuento = 0
	
	override method realizarDescuento(juego){
		return juego.precio() * porcentajeDescuento
	}
}

class DirectoEspecial inherits Descuento{
	var property porcentajeDescuento = 0
	
	override method realizarDescuento(juego){
		return super(juego) - 25
	}
}

class Fijo inherits Descuento{
	var property montoFijo =  0
	
	override method realizarDescuento(juego){
		return (juego.precio() - montoFijo).min(juego.precio())
	}	
}

class Gratis inherits Descuento{
	
	override method realizarDescuento(_juego) = 0
	
}

class SinDescuento inherits Descuento{}


///////
///REVIEW
///////

class Critica {
	const critica 
	var property textoCritica = ""
	var property esPositiva = true
	
	method mostrarCritica() = critica
	
}

class CriticaUsuario inherits Critica{
	
	method esCriticaPositiva(){
		if(self.esPositiva()){
			self.textoCritica("SI")
		} else 
			self.textoCritica("NO") 
	}
}

class CriticaPaga inherits Critica{
	const listaJuegos
	
	method estaEnLaLista(juego){
		return listaJuegos.contains(juego)
	}
	
	method recibirPago(juego){
		self.esPositiva(true)
	}
}

class CriticaRevista inherits Critica{
	
}
