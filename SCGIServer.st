AbstractHTTPServer subclass: SCGIServer [
    | port |
    
    <comment: nil>
    <category: 'Swazoo-SCGI'>

    createSocket [
	<category: 'start/stop'>
	^(self socketClass serverOnIP: self ip port: self port)
	    listenFor: 50;
	    yourself
    ]

    ip [
	<category: 'private-initialize'>
	^'0.0.0.0'
    ]

    port [
	<category: 'private-initialize'>
	^port
    ]

    port: anInteger [
	<category: 'private-initialize'>
	port := anInteger
    ]

    requestReaderClass [
	<category: 'serving'>
	^SCGIReader
    ]

    responsePrinterClass [
	<category: 'serving'>
	^SCGIPrinter
    ]

    socketClass [
	<category: 'serving'>
	^SwazooSocket
    ]
]

