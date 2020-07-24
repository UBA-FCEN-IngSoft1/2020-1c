'From Cuis 5.0 [latest update: #4247] on 24 July 2020 at 11:09:22 am'!
'Description Interfaz REST de TusLibros. Usar con:
- http://localhost:9999/createCart?clientId=hernan&password=smalltalk
- http://localhost:9999/addToCart?cartId=1&bookIsbn=GreenBook&bookQuantity=10
- http://localhost:9999/listCart?cartId=1
- http://localhost:9999/checkOutCart?cartId=1&ccn=1234&cced=072020&cco=PepeSanchez
- http://localhost:9999/listPurchases?clientId=hernan&password=smalltalk
'!
!provides: 'TusLibrosREST' 1 2!
!requires: 'WebClient' 1 19 nil!
!requires: 'TusLibros' 1 0 nil!
SystemOrganization addCategory: #TusLibrosREST!


!classDefinition: #RealTimeClock category: #TusLibrosREST!
Clock subclass: #RealTimeClock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibrosREST'!
!classDefinition: 'RealTimeClock class' category: #TusLibrosREST!
RealTimeClock class
	instanceVariableNames: ''!

!classDefinition: #DefaultMerchantProcessor category: #TusLibrosREST!
MerchantProcessor subclass: #DefaultMerchantProcessor
	instanceVariableNames: 'transactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibrosREST'!
!classDefinition: 'DefaultMerchantProcessor class' category: #TusLibrosREST!
DefaultMerchantProcessor class
	instanceVariableNames: ''!

!classDefinition: #TusLibrosRestInterface category: #TusLibrosREST!
Object subclass: #TusLibrosRestInterface
	instanceVariableNames: 'systemFacade'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibrosREST'!
!classDefinition: 'TusLibrosRestInterface class' category: #TusLibrosREST!
TusLibrosRestInterface class
	instanceVariableNames: ''!


!RealTimeClock methodsFor: 'time' stamp: 'HAW 5/5/2020 17:07:39'!
now

	^DateAndTime now! !

!RealTimeClock methodsFor: 'time' stamp: 'HAW 5/5/2020 17:07:48'!
today

	^Date today! !

!DefaultMerchantProcessor methodsFor: 'debit' stamp: 'HAW 5/5/2020 17:13:16'!
debit: anAmount from: aCreditCard 

	transactionId := transactionId + 1.
	^transactionId! !

!DefaultMerchantProcessor methodsFor: 'initialization' stamp: 'HAW 5/5/2020 17:13:31'!
initialize

	super initialize.
	transactionId := 0! !

!TusLibrosRestInterface methodsFor: 'initialization' stamp: 'HAW 5/5/2020 17:18:31'!
initializeOn: aTusLibrosSystemFacade 
	
	systemFacade := aTusLibrosSystemFacade.! !

!TusLibrosRestInterface methodsFor: 'request' stamp: 'HAW 5/5/2020 18:16:39'!
answer: aBlock to: aRequest 

	| response |
	
	[ response := aBlock value.
	aRequest send200Response: '0|', response ]
		on: Error
		do: [ :anError | aRequest send200Response: '1|', anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'request' stamp: 'HAW 7/23/2020 16:18:57'!
cartIdFrom: requestFields

	^ (requestFields at: 'cartId') asNumber! !

!TusLibrosRestInterface methodsFor: 'request' stamp: 'HAW 7/23/2020 16:20:08'!
clientIdFrom: requestFields

	^ requestFields at: 'clientId'! !

!TusLibrosRestInterface methodsFor: 'request' stamp: 'HAW 7/23/2020 16:20:19'!
passwordFrom: requestFields

	^ requestFields at: 'password'! !

!TusLibrosRestInterface methodsFor: 'request' stamp: 'HAW 5/5/2020 18:26:47'!
withFieldsOf: aRequest do: aBlock

	[ aBlock value: aRequest fields ]
		on: Error
		do: [ :anError | aRequest 
			sendResponseCode: 400 
			content: ('Invalid request: ', anError messageText) asUtf8
			type: 'text/plain; charset=utf-8'
			close: true ]! !

!TusLibrosRestInterface methodsFor: 'rest interface' stamp: 'HAW 7/23/2020 16:18:57'!
addToCart: aRequest

	| bookIsbn cartId quantity |
	
	self withFieldsOf: aRequest do: [ :requestFields |
		cartId := self cartIdFrom: requestFields.
		bookIsbn := requestFields at: 'bookIsbn'.
		quantity := (requestFields at: 'bookQuantity') asNumber ].
		
	self 
		answer: [
			systemFacade add: quantity of: bookIsbn toCartIdentifiedAs: cartId.
			'OK' ]
		to: aRequest 
	! !

!TusLibrosRestInterface methodsFor: 'rest interface' stamp: 'HAW 7/23/2020 16:19:16'!
checkOutCart: aRequest

	| cartId creditCardNumber creditCardOwner creditCartExpirationDate creditCartExpirationDateString transactionId |
	
	self withFieldsOf: aRequest do: [ :requestFields |
		cartId := self cartIdFrom: requestFields.
		creditCardNumber := requestFields at: 'ccn'.
		creditCartExpirationDateString := requestFields at: 'cced'.
		creditCartExpirationDate := Month 
			month: (creditCartExpirationDateString first: 2) asNumber 
			year: (creditCartExpirationDateString last: 4) asNumber.
		creditCardOwner := requestFields at: 'cco' ].
	
	self 
		answer: [
			transactionId := systemFacade 
					checkOutCartIdentifiedAs: cartId 
					withCreditCardNumbered: creditCardNumber 
					ownedBy: creditCardOwner 
					expiringOn: creditCartExpirationDate. 
			transactionId printString ]
		to: aRequest ! !

!TusLibrosRestInterface methodsFor: 'rest interface' stamp: 'HAW 7/24/2020 11:05:36'!
createCart: aRequest

	| clientId password |
	
	self withFieldsOf: aRequest do: [ :requestFields |
		clientId := self clientIdFrom: requestFields.
		password := self passwordFrom: requestFields ].
	
	self 
		answer: [ | cartId | 
			cartId := systemFacade createCartFor: clientId authenticatedWith: password.
			cartId printString ]
		to: aRequest ! !

!TusLibrosRestInterface methodsFor: 'rest interface' stamp: 'HAW 7/23/2020 16:19:56'!
listCart: aRequest

	| cartId content response |
	
	self withFieldsOf: aRequest do: [ :requestFields |
		cartId := self cartIdFrom: requestFields ].
	
	self 
		answer: [ 
			content := systemFacade listCartIdentifiedAs: cartId.
			response := String streamContents: [:stream |
				content contents associations 
					do: [ :isbnAndAmount | stream nextPutAll: isbnAndAmount key; nextPut: $|; print: isbnAndAmount value ]
					separatedBy: [ stream nextPut: $| ]].
			response ]
		to: aRequest 
! !

!TusLibrosRestInterface methodsFor: 'rest interface' stamp: 'HAW 7/23/2020 16:20:19'!
listPurchases: aRequest

	| clientId password purchases response |
	
	self withFieldsOf: aRequest do: [ :requestFields |
		clientId := self clientIdFrom: requestFields.
		password := self passwordFrom: requestFields ].
	
	self 
		answer: [ | soldItems total |
			purchases := systemFacade listPurchasesOf: clientId authenticatingWith: password.
			soldItems := purchases first.
			total := purchases second.
			response := String streamContents: [:stream | 
				soldItems keysAndValuesDo: [ :isbn :amount |
					stream nextPutAll: isbn; nextPut: $|; print: amount; nextPut: $| ].
				stream print: total ].
			response ]
		to: aRequest ! !

!TusLibrosRestInterface class methodsFor: 'default objects' stamp: 'HAW 5/5/2020 17:11:42'!
createSalesBook
	
	^OrderedCollection new! !

!TusLibrosRestInterface class methodsFor: 'default objects' stamp: 'HAW 5/5/2020 17:47:11'!
defaultCatalog 
	
	^Dictionary new
		at: 'GreenBook' put: 10*dollar;
		at: 'BlueBook' put: 15*dollar;
		at: 'MartinFierro' put: 350*peso;
		yourself! !

!TusLibrosRestInterface class methodsFor: 'default objects' stamp: 'HAW 5/5/2020 17:13:55'!
defaultMerchantProcessor 
	
	^DefaultMerchantProcessor new! !

!TusLibrosRestInterface class methodsFor: 'default objects' stamp: 'HAW 5/5/2020 17:13:46'!
defaultSystem

	| clock systemFacade |
	
	clock := RealTimeClock new.
	systemFacade := TusLibrosSystemFacade 
		authenticatingWith: self validUsersAndPasswords 
		acceptingItemsOf: self defaultCatalog 
		registeringOn: self createSalesBook
		debitingThrought: self defaultMerchantProcessor 
		measuringTimeWith: clock.

	^systemFacade ! !

!TusLibrosRestInterface class methodsFor: 'default objects' stamp: 'HAW 5/5/2020 17:10:11'!
validUsersAndPasswords 
	
	^Dictionary new
		at: 'hernan' put: 'smalltalk';
		at: 'maximo' put: 'ruby';
		yourself! !

!TusLibrosRestInterface class methodsFor: 'instance creation' stamp: 'HAW 5/5/2020 17:18:06'!
on: aTusLibrosSystemFacade 

	^self new initializeOn: aTusLibrosSystemFacade ! !

!TusLibrosRestInterface class methodsFor: 'installation' stamp: 'HAW 7/24/2020 11:07:02'!
installForDefaultSystem

	"self installForDefaultSystem"
	
	| server port interface |
	
	interface := self on: self defaultSystem.
	
	"Esto es para poder acceder a la interface de manera global - Hernan"
	Smalltalk at: #CurrentTusLibrosRestInterface put: interface.
	
	port := 9999.
	server := WebServer reset default.
	server listenOn: port.
	server 
		addService: '/createCart' 
		action: [:request | interface createCart: request ].
	server 
		addService: '/addToCart' 
		action: [:request | interface addToCart: request ].
	server
		addService: '/listCart' 
		action: [:request | interface listCart: request ].
	server
		addService: '/checkOutCart' 
		action: [:request | interface checkOutCart: request ].
	server
		addService: '/listPurchases' 
		action: [:request | interface listPurchases: request ].
	server useDebugErrorHandler ! !
