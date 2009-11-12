SwazooRequestReader subclass: SCGIReader [
    | fields |

    <comment: nil>
    <category: 'Swazoo-SCGI'>

    readHeaders [
	<category: 'parsing'>
	| uriHeader methodHeader |
	self readHeadersFrom: stream readNetString.
	uriHeader := fields
	    detect: [:each | each name asUppercase = 'REQUEST-URI']
	    ifNone: [nil].
	self requestURI: (SwazooURI fromString: (uriHeader 
	    ifNil: [''] 
	    ifNotNil: [uriHeader value])).
	methodHeader := fields
	    detect: [:each | each name asUppercase = 'REQUEST-METHOD']
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
	fields add: (HeaderField 
	    name: (self convertFieldName: key) 
	    value: value).
	valueEnd = aString size] 
	    whileFalse: [start := valueEnd + 1]
    ]

    readRequest [
	<category: 'parsing'>
	self readHeaders.
	request := (HTTPRequest classFor: self method) new.
	self httpVersion: #(0 0).
	fields do: [:each |
	    request headers 
		fieldOfClass: each class
		ifNone: [request headers addField: each]].
	request requestLine: requestLine.
	self request setTimestamp.
	self readBody.
    ]

    convertFieldName: aString [
	<category: 'private'>
	^(aString 
	    copyReplacingAllRegex: '^HTTP_' with: '')
	    copyReplacingAllRegex: '_' with: '-'
    ]
]

