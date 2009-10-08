URIIdentifier subclass: SCGIIdentifier [
    | ip port host |
    
    <comment: nil>
    <category: 'Swazoo-SCGI'>

    SCGIIdentifier class >> port: aPort [
	<category: 'instance creation'>
	^self new setPort: aPort
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
	^'a Swazoo.SCGIIndentifier
	ip: ' 
	    , (self ip isNil ifTrue: [''] ifFalse: [self ip])
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

