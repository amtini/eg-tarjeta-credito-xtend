package ar.edu.tarjetaCreditoDecoratorCucumber

import ar.edu.tarjetaCreditoDecoratorCucumber.exceptions.BusinessException
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
	def clienteCompraItems(List<List<String>> items) {
		items
			.subList(1, items.length)
			.forEach [ fields |
				val cosa = fields.get(0)
				val precioOriginal = fields.get(1)
				try {
					val precio = new Integer(precioOriginal)
					unCliente.comprar(precio)
				} catch (NumberFormatException e) {
					throw new RuntimeException("Valor inválido para " + cosa + ": " + precioOriginal)
				}
			]
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
