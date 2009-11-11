SwazooRequestReader subclass: SCGIReader [
    | fields |

    <comment: nil>
    <category: 'Swazoo-SCGI'>

    convertFieldNamed: aString to: anotherString [
	"Convert header fields from SCGI standard to HTTP for Swazoo request"
	<category: 'private'>
	request headers 
	    fieldNamed: aString
	    ifPresent: [:header |
		request headers addField: 
		    (HeaderField 
			name: anotherString
			value: header value)]
	    ifAbsent: []
    ]

    convertHeaders [
	<category: 'private'>
	self
	    convertFieldNamed: 'HTTP_COOKIE' to: 'COOKIE';
	    convertFieldNamed: 'HTTP_ACCEPT' to: 'ACCEPT';
	    convertFieldNamed: 'HTTP_ACCEPT_CHARSET' to: 'ACCEPT-CHARSET';
	    convertFieldNamed: 'HTTP_ACCEPT_ENCODING' to: 'ACCEPT-ENCODING';
	    convertFieldNamed: 'HTTP_ACCEPT_LANGUAGE' to: 'ACCEPT-LANGUAGE';
	    convertFieldNamed: 'HTTP_AUTHORIZATION' to: 'AUTHORIZATION';
	    convertFieldNamed: 'HTTP_HOST' to: 'HOST';
	    convertFieldNamed: 'HTTP_REFERER' to: 'REFERER';
	    convertFieldNamed: 'HTTP_USER_AGENT' to: 'USER-AGENT'
    ]

    readHeaders [
	<category: 'parsing'>
	| uriHeader methodHeader |
	self readHeadersFrom: stream readNetString.
	uriHeader := fields
	    detect: [:each | each name asUppercase = 'REQUEST_URI']
	    ifNone: [nil].
	self requestURI: (SwazooURI fromString: (uriHeader 
	    ifNil: [''] 
	    ifNotNil: [uriHeader value])).
	methodHeader := fields
	    detect: [:each | each name asUppercase = 'REQUEST_METHOD']
	    ifNone: [nil].
	self method: (methodHeader 
	    ifNil: ['GET'] 
	    ifNotNil: [methodHeader value]).
    ]

    readHeadersFrom: aString [
	"This is the request parsing code based on Simple CGI standard:
	 http://python.ca/scgi/protocol.txt"
	<category: 'parsing'>

	| zero start end key valueEnd value |
	zero := Character value: 0.
	start := 1.
	fields := OrderedCollection new.

	[end := aString indexOf: zero startingAt: start.
	key := aString copyFrom: start to: end - 1.
	valueEnd := aString indexOf: zero startingAt: end + 1.
	value := aString copyFrom: end + 1 to: valueEnd - 1.
	fields add: (HeaderField name: key value: value).
	valueEnd = aString size] 
	    whileFalse: [start := valueEnd + 1]
    ]

    readRequest [
	<category: 'parsing'>
	self readHeaders.
	request := (HTTPRequest classFor: self method) new.
	fields do: [:each |
	    request headers addField: each].
	self convertHeaders.
	request requestLine: requestLine.
	self request setTimestamp.
	self readBody.
    ]
]

