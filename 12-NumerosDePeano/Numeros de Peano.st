!classDefinition: #I category: #'Numeros de Peano'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: #'Numeros de Peano'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'base' stamp: 'AM 4/27/2020 21:20:19'!
successor

	^self createChildNamed: self name , 'I'.! !


!I class methodsFor: 'operation' stamp: 'AM 4/27/2020 21:38:28'!
+ aNumber 
	
	^aNumber successor! !


!classDefinition: #II category: #'Numeros de Peano'!
I subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: #'Numeros de Peano'!
II class
	instanceVariableNames: ''!

!II class methodsFor: 'base' stamp: 'AM 4/27/2020 21:42:53'!
previous

	^self parent! !


!II class methodsFor: 'operation' stamp: 'AM 4/27/2020 21:48:54'!
+ aNumber 

	^self previous + aNumber successor! !

!II class methodsFor: 'operation' stamp: 'AM 4/27/2020 21:57:58'!
- aNumber 
	
	aNumber = I
		ifTrue: [^self previous]
		ifFalse:[^self previous - aNumber previous]! !


!classDefinition: #III category: #'Numeros de Peano'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!


!classDefinition: #IIII category: #'Numeros de Peano'!
III subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!


!classDefinition: #TestNumerosDePeano category: #'Numeros de Peano'!
DenotativeObject subclass: #TestNumerosDePeano
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestNumerosDePeano class' category: #'Numeros de Peano'!
TestNumerosDePeano class
	instanceVariableNames: ''!

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:25:55'!
test01

	Assert that: I successor isEqualTo: II.! !

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:28:06'!
test02ElSucesorDeUnNumeroNEsNAsterisco

	Assert that: II successor isEqualTo: III.! !

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:33:59'!
test03UnoMasUnNumeroEsIgualAlSucesorDelNumero

	Assert that: I + III isEqualTo: III successor! !

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:35:40'!
test04

	Assert that: II + III isEqualTo: IIII successor! !

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:52:23'!
test05

	Assert that: II - I isEqualTo: I! !

!TestNumerosDePeano class methodsFor: 'as yet unclassified' stamp: 'AM 4/27/2020 21:55:03'!
test06

	Assert that: IIII - II isEqualTo: II! !
