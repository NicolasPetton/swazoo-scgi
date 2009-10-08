SwazooRequestReader subclass: SCGIReader [
    
    <comment: nil>
    <category: 'Swazoo-SCGI'>

    convertFieldNamed: aString to: anotherString [
	"Convert header fields from SCGI standard to HTTP for Swazoo request"

	<category: 'private'>
	request headers 
	    fieldNamed: aString
	    ifPresent: 
		[request headers addField: (HeaderField name: anotherString
			    value: (request headers at: aString))]
	    ifAbsent: []
    ]

    convertHeaders [
	<category: 'private'>
	self
	    convertFieldNamed: 'HTTP_COOKIE' to: 'COOKIE';
	    convertFieldNamed: 'HTTP_ACCEPT' to: 'ACCEPT';
	    convertFieldNamed: 'HTTP_ACCEPT_CHARSET' to: 'ACCEPT_CHARSET';
	    convertFieldNamed: 'HTTP_ACCEPT_ENCODING' to: 'CCEPT_ENCODING';
	    convertFieldNamed: 'HTTP_ACCEPT_LANGUAGE' to: 'ACCEPT_LANGUAGE';
	    convertFieldNamed: 'HTTP_AUTHORIZATION' to: 'AUTHORIZATION';
	    convertFieldNamed: 'HTTP_HOST' to: 'HOST';
	    convertFieldNamed: 'HTTP_REFERER' to: 'REFERER';
	    convertFieldNamed: 'HTTP_USER_AGENT' to: 'USER_AGENT'
    ]

    readHeaders [
	<category: 'parsing'>
	self readHeadersFrom: stream readNetString.
	self convertHeaders.
	self requestURI: (SwazooURI 
		    fromString: (request headers fieldNamed: 'REQUEST_URI' ifNone: '')).
	self method: (request headers fieldNamed: 'REQUEST_METHOD' ifNone: 'GET')
    ]

    readHeadersFrom: aString [
	"This is the request parsing code based on Simple CGI standard:
	 http://python.ca/scgi/protocol.txt"

	<category: 'parsing'>
	| zero start end key valueEnd value |
	zero := Character value: 0.
	start := 1.
	
	[end := aString indexOf: zero startingAt: start.
	key := aString copyFrom: start to: end - 1.
	valueEnd := aString indexOf: zero startingAt: end + 1.
	value := aString copyFrom: end + 1 to: valueEnd - 1.
	request headers addField: (HeaderField name: key value: value).
	valueEnd = aString size] 
		whileFalse: [start := valueEnd + 1]
    ]

    readRequest [
	<category: 'parsing'>
	self readHeaders.
	request := (HTTPRequest classFor: self method) new.
	request requestLine: requestLine.
	self request setTimestamp.
	self readBody
    ]
]

