URIIdentifier subclass: SCGIIdentifier [
    | port |
    
    <comment: nil>
    <category: 'Swazoo-SCGI'>

    SCGIIdentifier class >> port: aPort [
	<category: 'instance creation'>
	^self new setPort: aPort
    ]

    SCGIIdentifier class >> host: aString ip: anotherString port: aPort [
	<category: 'instance creation'>
	^self port: aPort
    ]

    currentUrl [
	<category: 'accessing'>
	| stream |
	stream := WriteStream on: String new.
	self printUrlOn: stream.
	^stream contents
    ]

    port [
	<category: 'accessing'>
	^port
    ]

    port: aNumber [
	<category: 'private'>
	port := aNumber
    ]

    ip [
	^'0.0.0.0'
    ]

    isEmpty [
	<category: 'testing'>
	^port isNil
    ]

    newServer [
	<category: 'initialize-release'>
	^SCGIServer new port: self port
    ]

    setPort: aPort [
	<category: 'initialize-release'>
	self port: aPort
    ]

    printString [
	<category: 'private'>
	^'a Swazoo.SCGIIndentifier'
    ]

    printUrlOn: aWriteStream [
	<category: 'private'>
	aWriteStream nextPutAll: '*:' , self port printString
    ]

    portMatch: aSCGIIdentifier [
	<category: 'private-comparing'>
	^self port = aSCGIIdentifier port
    ]

    valueMatch: aSiteIdentifier [
	<category: 'private-comparing'>
	^self portMatch: aSiteIdentifier
    ]
]

