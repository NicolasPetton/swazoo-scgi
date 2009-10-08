HTTPPrinter subclass: SCGIPrinter [
    
    <comment: nil>
    <category: 'Swazoo-SCGI'>

    printStatus [
	<category: 'private-sending'>
	stream
	    nextPutAll: 'Status: ';
	    print: response code;
	    space;
	    nextPutAll: response codeText.
	self crlf
    ]
]

