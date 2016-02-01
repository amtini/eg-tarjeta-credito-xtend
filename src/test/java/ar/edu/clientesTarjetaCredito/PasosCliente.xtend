package ar.edu.clientesTarjetaCredito

import ar.edu.clientesTarjetaCredito.exceptions.BusinessException
import cucumber.api.java.en.And
import cucumber.api.java.en.Given
import cucumber.api.java.en.Then
import cucumber.api.java.en.When
import java.util.List
import org.junit.Assert

class PasosCliente {

	Cliente unCliente
	Exception expectedException
	
	@Given("^un cliente con un saldo de (\\d+)")
	def void clienteConSaldoDe(int monto) {
		unCliente = new ClientePosta(monto)
	}

	@And("^safe shop con monto maximo de (\\d+)")
	def void safeShopConMontoMaximoDe(int monto) {
		val clienteTemp = unCliente
		unCliente = new ClienteSafeShopDecorator(clienteTemp, monto)
	}
	
	@When("^compra algo de (\\d+)")
	def void clienteCompraAlgoDePrecio(int precio){
		try {
			unCliente.comprar(precio)
		} catch (Exception e) {
			expectedException = e
		}
	}

	@When("^compra los siguientes items:")
	def clienteCompraItems(List<ItemDeCompra> items) {
		items.forEach [ unCliente.comprar(it.precio) ]
	}
	
	@Then("^le queda (\\d+) de saldo")
	def leQueda(int expected){
		Assert.assertEquals(expected, unCliente.saldo)
	}

	@Then("^el usuario recibe un error")
	def usuarioRecibeError(){
		Assert.assertEquals(expectedException.class, typeof(BusinessException))
	}

}

class ItemDeCompra {
	int precio
	String nombre
	
	/**
	 * Construimos getters y setters a mano para no tener que cambiar el feature
	 */
	def getPrecio() {
		precio
	}
	
	def void setPrecio(int _precio) {
		precio = _precio
	}
	
	def void setNombre(String _nombre) {
		nombre = _nombre
	}
}

