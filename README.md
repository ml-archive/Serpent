# Serializable

Serializable is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's implemented using protocol extensions, which makes it easily expandable.

It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects.

It's designed to be used together with our helper app, the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), making model creation a breeze.

The Serializable framework uses static typing, exhibiting superior performance compared to frameworks using reflection and eliminates boilerplate code.

[![Travis](https://img.shields.io/travis/nodes-ios/Serializable.svg)](https://travis-ci.org/nodes-ios/Serializable)
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/Serializable.svg)](https://codecov.io/github/nodes-ios/Serializable)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Serializable.svg)](https://cocoapods.org/pods/Serializable)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serializable/blob/master/LICENSE)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-ios/serializable)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-ios/serializable)


## Why Serializable?
There are plenty of other Encoding and Decoding frameworks available. Why should you use Serializable? 

* [Performance](https://github.com/nodes-ios/Serializable/wiki/Performance-tests). Serializable is fast, up to 4x faster than similar frameworks
* [Features](https://github.com/nodes-ios/Serializable/wiki/Performance-tests#feature-comparison). Serializable can parse anything you throw at it. Nested objects, Enums, NSURL, UIColor, you name it!
* [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler). Every framework of this kind requires tedious boilerplate code that takes forever to write, [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) generates it for you instantly. 


## 📝 Requirements

* iOS 8.0+
* Swift 2.0+

## 📦 Installation

### Carthage
~~~
github "nodes-ios/Serializable" 
~~~

### CocoaPods
~~~
pod 'Serializable', '~> 0.1.0'
~~~

### Swift Package Manager
To use Serializable as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following to your `Package.swift` file.  

~~~swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/nodes-ios/Serializable.git", majorVersion: 0)
    ]
)
~~~

**NOTE:** This doesn't currently work as SPM doens't support UIKit, but once it will we will already be supporting it! :)


## 🔧 Setup

We **highly** recommend you use our [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) to assist with generating the code needed to conform to Serializable. Instructions for installation and usage can be found at the [Model Boiler github repository](https://github.com/nodes-ios/ModelBoiler). 

## 💻 Usage

### Getting started

Serializable supports Primitive types, Enum, NSURL, NSDate, UIColor, other Serializables, and Arrays of all of the aforementioned types. Your variable declarations can have a default value or be optional. 

Primitive types do not need to have an explicit type, if Swift is able to infer it normally. `var name: String = ""` works just as well as `var name = ""`. Optionals will of course need an explicit type. 

**Note:** Enums you create must conform to RawRepresentable, meaning they must have an explicit type. Otherwise, the parser won't know what to do with the incoming data it receives. 


#### Create your model struct or class:

~~~swift
struct Foo {
	var id = 0
	var name = ""
	var address: String? 
}
~~~

**NOTE:** Classes must be marked `final`

####Add the required methods for `Encodable` and `Decodable`: 

~~~swift
extension Foo: Serializable {
    init(dictionary: NSDictionary?) {
        id      <== (self, dictionary, "id")
        name    <== (self, dictionary, "name")
        address <== (self, dictionary, "address")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "id")      <== id
        (dict, "name")    <== name
        (dict, "address") <== address
        return dict
    }
}
~~~

And thats it! If you're using the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), this extension will be generated for you, so that you don't need to type it all out for every model you have. 

###Using Serializable models

New instances of your model can be created with a dictionary, e.g. from parsed JSON. 

~~~swift
let dictionary = try NSJSONSerialization.JSONObjectWithData(someData, options: .AllowFragments) as? NSDictionary
let newModel = Foo(dictionary: dictionary)
~~~

You can generate a dictionary version of your model by calling `encodableRepresentation()`:

~~~swift
let encodedDictionary = newModel.encodableRepresentation()
~~~

###More complex examples

In this example, we have two models, Student and School. 

~~~swift
struct Student {
	enum Gender: String {
		case Male = "male"
		case Female = "female"
		case Unspecified = "unspecified"
	}
	
	var name = ""
	var age: Int = 0
	var gender: Gender?
}

struct School {
	enum Sport: Int {
		case Football
		case Basketball
		case Tennis
		case Swimming
	}
	
	var name = ""
	var location = ""
	var website: NSURL?
	var students: [Student] = []
	var sports: [Sport]?
}
~~~


You can get as complicated as you like, and the syntax will always remain the same. The extensions will be:

~~~swift
extension Student: Serializable {
	init(dictionary: NSDictionary?) {
		name   <== (self, dictionary, "name")
		age    <== (self, dictionary, "age")
		gender <== (self, dictionary, "gender")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "name")   <== name
		(dict, "age")    <== age
		(dict, "gender") <== gender
		return dict
	}
}

extension School: Serializable {
	init(dictionary: NSDictionary?) {
		name     <== (self, dictionary, "name")
		location <== (self, dictionary, "location")
		website  <== (self, dictionary, "website")
		students <== (self, dictionary, "students")
		sports   <== (self, dictionary, "sports")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "name")     <== name
		(dict, "location") <== location
		(dict, "website")  <== website
		(dict, "students") <== students
		(dict, "sports")   <== sports
		return dict
	}
}
~~~
Again, the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) generates all of this code for you in less than a second!

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Serializable** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Serializable/blob/master/LICENSE) file for more info.
