Feature: Clientes de Tarjeta de Crédito

Scenario: un cliente comun paga
	Given un cliente con un saldo de 40 
	When compra algo de 28
	Then le queda 12 de saldo

Scenario: un cliente safe shop paga
	Given un cliente con un saldo de 40
	And safe shop con monto maximo de 20
	When compra algo de 15
	Then le queda 25 de saldo
	
Scenario: un cliente safe shop no puede comprar mas del monto maximo permitido
	Given un cliente con un saldo de 40
	And safe shop con monto maximo de 20
	When compra algo de 30
	Then el usuario recibe un error
	Then le queda 40 de saldo
	
		
Scenario: un cliente comun compra varias cosas
	Given un cliente con un saldo de 50
	When compra los siguientes items:
		| nombre | precio |
     	| leche	 | 7      |
     	| pan    | 20     |
     	| azucar | 5      |
     Then le queda 18 de saldo