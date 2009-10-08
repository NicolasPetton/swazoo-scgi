SwazooSite extend [
    scgiPort: aNumber [
	<category: '*Swazoo-SCGI'>
	"This is ugly. #initialize shouldn't add a SiteIdentifier"
	(self uriPattern notEmpty and: [
		(self uriPattern first class includesBehavior: Swazoo.SCGIIdentifier) not]) ifTrue: [
			self uriPattern removeAll].
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
	[(c := self next) = 58] whileFalse: [
		(c < 48 or: [c > 57]) ifTrue: [
			^self error: 'invalid net string'].
		size := (size * 10) + (c - 48)].
	^size
    ]	
]
