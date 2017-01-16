## Sequence 지원하기

### why?

다른분이 posting 한 블로그글 [Implementing SequenceType](http://swiftandpainless.com/implementing-sequencetype/) 이 swift 2.x 대 문법으로 되어 있어 swift 3.x 대 에서는 어떻게 구현하는것이 맞을까? 하고 다시 정리하게 되었다.



### how

1. Protocol 지원


	* Swift 2.x 버전에서는 SequenceType protocol 을 지원하면 된다. 

	~~~swift
	protocol SequenceType {
		func generate() -> Self.Generator
	}

	protocol GeneratorType {
		typealias Element
	
		mutating func next() -> Self.Element?
	}
	~~~


	* Swift 3.x 버전에서는 Sequence protocol 을 지원하면 된다.

	~~~swfit
	protocol Sequence {
		associatedtype Iterator : IteratorProtocol
	
		func makeIterator() -> Self.Iterator
	}

	protocol IteratorProtocol {

		mutating func next() -> Self.Element?
	}
	~~~

2. Apple Sample 

	~~~swift
	/// Implementing SequenceType
	struct Countdown: Sequence, IteratorProtocol {
		var count: Int
    
		mutating func next() -> Int? {
			if count == 0 {
				return nil
			} else {
				defer { count -= 1 }
				return count
			}
		}
	}

	let threeToGo = Countdown(count: 3)
	for i in threeToGo {
		print(i)
	}
	// Prints "3"
	// Prints "2"
	// Prints "1"
	~~~
	
3. 	[Implementing SequenceType](http://swiftandpainless.com/implementing-sequencetype/) 을 Swift 3.x 문법 적용

	~~~swift
	struct Domains {
		let names: [String]
		let tld: String
	}

	extension Domains: Sequence {
		func makeIterator() -> DomainsIterator {
			return DomainsIterator(domains: self)
		}
    
		struct DomainsIterator: IteratorProtocol {
			var domains: Domains
			var index = 0
        
			init(domains: Domains) {
				self.domains = domains
			}
        
			mutating func next() -> String? {
				if index < domains.names.count {
					defer {
						self.index += 1
					}

					return "\(domains.names[index]).\(domains.tld)"
				} else {
					return nil
				}
			}
		}
	}

	let domains = Domains(names: ["swiftandpainless","duckduckgo","apple","github"], tld: "com")

	for domain in domains {
		print(domain)
	}
	
	// output : 
	// swiftandpainless.com
	// duckduckgo.com
	// apple.com
	// github.com	
	~~~


### reference

[Implementing SequenceType](http://swiftandpainless.com/implementing-sequencetype/)