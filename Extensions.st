SwazooSite extend [
    scgiPort: aNumber [
	<category: '*Swazoo-SCGI'>
	"This is ugly. #initialize shouldn't add a SiteIdentifier"
	(self uriPattern notEmpty and: [
		(self uriPattern first class includesBehavior: Swazoo.SCGIIdentifier) not]) ifTrue: [uriPattern := OrderedCollection new].
	self uriPattern isEmpty ifTrue: [self uriPattern add: SCGIIdentifier new].
	self uriPattern first port: aNumber
    ]
]

SwazooStream extend [
    
    readNetString [
	<category: '*Swazoo-SCGI'>
	"This method implements the NetString protocol as 
	defined by: http://cr.yp.to/proto/netstrings.txt"
	
	| size answer |
	size := self readNetStringSize.
	answer := self next: size.
	self skip: 1. "Skip over the comma"
	^answer
    ]

    readNetStringSize [
	<category: '*Swazoo-SCGI'>
	| size c |
	size := 0.
	[(c := self next) value = 58] whileFalse: [
	    (c value < 48 or: [c value > 57]) ifTrue: [
		    ^self error: 'invalid net string'].
	    size := (size * 10) + (c value - 48)].
	^size
    ]	
]
