<p align="center"><img src="./Serpent_icon.png?raw=true" alt="Serpent"/></p>

[![Travis](https://img.shields.io/travis/nodes-ios/Serpent.svg)](https://travis-ci.org/nodes-ios/Serpent)
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/Serpent.svg)](https://codecov.io/github/nodes-ios/Serpent)
[![codebeat badge](https://codebeat.co/badges/bf41edec-511c-405d-9036-a7253492c118)](https://codebeat.co/projects/github-com-nodes-ios-serpent)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Serpent.svg)](https://cocoapods.org/pods/Serpent)    
![Plaforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serpent/blob/master/LICENSE)

**Serpent** *(previously known as Serializable)* is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects. Designed for use with Alamofire.

It's designed to be used together with our helper app, the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), making model creation a breeze.

Serpent is implemented using protocol extensions and static typing.

## 📑 Table of Contents

- [🐍 Why Serpent?](#-why-serpent)
- [📝 Requirements](#-requirements)
- [📦 Installation](#-installation)
	- [Carthage](#carthage)
	- [CocoaPods](#cocoapods)
	- [Swift Package Manager](#swift-package-manager)
- [🔧 Setup](#-setup)
- [💻 Usage](#-usage)
	- [Getting started](#getting-started)
	- [Using Serpent models](#using-serpent-models)
	- [More complex examples](#more-complex-examples)
	- [Using with Alamofire](#using-with-alamofire)
	- [Date parsing](#date-parsing)
- [👥 Credits](#-credits)
- [📄 License](#-license)

## 🐍 Why Serpent?
There are plenty of other Encoding and Decoding frameworks available. Why should you use Serpent?

* [Performance](https://github.com/nodes-ios/SerpentPerformanceComparison). Serpent is fast, up to 4x faster than similar frameworks.
* [Features](https://github.com/nodes-ios/SerpentPerformanceComparison#-feature-comparison). Serpent can parse anything you throw at it. Nested objects, Enums, URLs, UIColor, you name it!
* [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler). Every framework of this kind requires tedious boilerplate code that takes forever to write.  [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) generates it for you instantly.
* [Alamofire Integration](). Using the included Alamofire extensions makes implementing an API call returning parsed model data as simple as doing a one-liner!
* [Expandability](). Parsing into other datatypes can easily be added.
* [Persisting](). Combined with our caching framework [Cashier](https://github.com/nodes-ios/Cashier), Serpent objects can be very easily persisted to disk.
* <a href = "https://github.com/nodes-ios/SerpentXcodeFileTemplate"><img src = "https://raw.githubusercontent.com/nodes-ios/SerpentXcodeFileTemplate/master/Serpent/Serpent%20Model.xctemplate/TemplateIcon.png" height = 25> Serpent Xcode File Template </a> makes it easier to create the model files in Xcode.

## 📝 Requirements

* iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
* Swift 3.0+  
*(Swift 2.2 & Swift 2.3 supported in older versions)*

## 📦 Installation

### Carthage
~~~bash
github "nodes-ios/Serpent" ~> 1.0
~~~

> Last versions compatible with lower Swift versions:  
>
> **Swift 2.3**  
> `github "nodes-ios/Serpent" == 0.13.2`
>
> **Swift 2.2**  
> `github "nodes-ios/Serpent" == 0.11.2`
>
> **NOTE:** Serpent was previously known as **Serializable**.

### CocoaPods

Choose one of the following, add it to your `Podfile` and run `pod install`:

~~~ruby
pod 'Serpent', '~> 1.0' # Just core
pod 'Serpent/Extensions', '~> 1.0' # Includes core and all extensions
pod 'Serpent/AlamofireExtension', '~> 1.0' # Includes core and Alamofire extension
pod 'Serpent/CashierExtension', '~> 1.0' # Includes core and Cashier extension
~~~

> **NOTE:** CocoaPods only supports Serpent using Swift version 3.0 and higher.

### Swift Package Manager

To use Serpent as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following to your `Package.swift` file.  

~~~swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/nodes-ios/Serpent.git", majorVersion: 1)
    ]
)
~~~


## 🔧 Setup

We **highly** recommend you use our [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) to assist with generating the code needed to conform to Serpent. Instructions for installation and usage can be found at the [Model Boiler GitHub repository](https://github.com/nodes-ios/ModelBoiler).

## 💻 Usage

### Getting started

Serpent supports all primitive types, `enum`, `URL`, `Date`, `UIColor`, other `Serpent` model, and `Array` of all of the aforementioned types. Your variable declarations can have a default value or be optional.

Primitive types do not need to have an explicit type, if Swift is able to infer it normally. `var name: String = ""` works just as well as `var name = ""`. Optionals will of course need an explicit type.

> **NOTE:** Enums you create must conform to `RawRepresentable`, meaning they must have an explicit type. Otherwise, the parser won't know what to do with the incoming data it receives.


#### Create your model struct or class:

~~~swift
struct Foo {
	var id = 0
	var name = ""
	var address: String?
}
~~~

> **NOTE:** Classes must be marked `final`.

#### Add the required methods for `Encodable` and `Decodable`:

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

> **NOTE:** You can add conformance to `Serializable` which is a type alias for both `Encodable` and `Decodable`.

And thats it! If you're using the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), this extension will be generated for you, so that you don't need to type it all out for every model you have.

### Using Serpent models

New instances of your model can be created with a dictionary, e.g. from parsed JSON.

~~~swift
let dictionary = try JSONSerialization.jsonObject(with: someData, options: .allowFragments) as? NSDictionary
let newModel = Foo(dictionary: dictionary)
~~~

You can generate a dictionary version of your model by calling `encodableRepresentation()`:

~~~swift
let encodedDictionary = newModel.encodableRepresentation()
~~~

### More complex examples

In this example, we have two models, Student and School.

~~~swift
struct Student {
	enum Gender: String {
		case male = "male"
		case female = "female"
		case unspecified = "unspecified"
	}

	var name = ""
	var age: Int = 0
	var gender: Gender?
}

struct School {
	enum Sport: Int {
		case football
		case basketball
		case tennis
		case swimming
	}

	var name = ""
	var location = ""
	var website: URL?
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

### Using with Alamofire

Serpent comes integrated with Alamofire out of the box, through an extension on Alamofire's `Request` construct, that adds the function `responseSerializable(completion:unwrapper)`

The extension uses Alamofire's familiar `Response` type to hold the returned data, and uses its generic associated type to automatically parse the data.

Consider an endpoint returning a single `school` structure matching the struct from the example above. To implement the call, simply add a function to your shared connection manager or where ever you like to put it:

~~~swift
func requestSchool(completion: @escaping (DataResponse<School>) -> Void) {
	request("http://somewhere.com/school/1", method: .get).responseSerializable(completion)
}
~~~

In the consuming method you use it like this:

~~~swift
requestSchool() { (response) in
	switch response.result {
		case .success(let school):
			//Use your new school object!

		case .failure(let error):
			//Handle the error object, or check your Response for more detail
	}
}
~~~

For an array of objects, use the same technique:

~~~swift
static func requestStudents(completion: @escaping (DataResponse<[Student]>) -> Void) {
	request("http://somewhere.com/school/1/students", method: .get).responseSerializable(completion)
}
~~~

Some APIs wrap their data in containers. Use the `unwrapper` closure for that. Let's say your `/students` endpoint returns the data wrapped in a `students` object:

~~~json
{
	"students" : [
		{
		    "..." : "..."
		},
		{
		    "..." : "..."
		}
	]
}
~~~

The `unwrapper` closure has 2 input arguments: The `sourceDictionary` (the JSON Response Dictionary) and the `expectedType` (the *type* of the target Serpent). Return the object that will serve as the input for the Serializable initializer.

~~~swift
static func requestStudents(completion: (DataResponse<[Student]>) -> Void) {
	request("http://somewhere.com/school/1/students", method: .get).responseSerializable(completion, unwrapper: { $0.0["students"] })
}
~~~

If you need to unwrap the response data in every call, you can install a default unwrapper using

~~~swift
Parser.defaultWrapper = { sourceDictionary, expectedType in 
	// You custom unwrapper here... 
	return sourceDictionary
}
~~~

The `expectedType` can be used to dynamically determine the key based on the type name using reflection. This is especially useful when handling paginated data.

See [here](https://github.com/nodes-ios/Nodes) for an example on how we use this in our projects at Nodes.

***NOTE:*** `responseSerializable` Internally calls `validate().responseJSON()` on the request, so you don't have to do that.

### Date parsing
Serpent can create `Date` objects from the date strings in the JSON. By default, Serpent can parse the date strings from the following formats: `yyyy-MM-dd'T'HH:mm:ssZZZZZ`, `yyyy-MM-dd'T'HH:mm:ss`, `yyyy-MM-dd`. If you need to parse other date formats, you can do it by adding this line to your code (for example, in `AppDelegate`'s `didFinishLaunchingWithOptions:`:

~~~swift
Date.customDateFormats = ["yyyyMMddHHmm", "yyyyMMdd"]    // add the custom date formats you need here
~~~

The custom date formats won't replace the default ones, they will be still supported. 

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Serpent** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Serpent/blob/master/LICENSE) file for more info.
