<p align="center">
  <img src="./Serializable_icon.png?raw=true" alt="Serializable"/>
</p>

<center>[![Travis](https://img.shields.io/travis/nodes-ios/Serializable.svg)](https://travis-ci.org/nodes-ios/Serializable) 
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/Serializable.svg)](https://codecov.io/github/nodes-ios/Serializable) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serializable/blob/master/LICENSE)  
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![CocoaPods](https://img.shields.io/cocoapods/v/Serializable.svg)](https://cocoapods.org/pods/Serializable) 
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg) 
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serializable/blob/master/LICENSE) 
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-ios/serializable)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-ios/serializable)</center>

Serializable is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects. Designed for use with Alamofire.

It's designed to be used together with our helper app, the [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), making model creation a breeze.

Serializable is implemented using protocol extensions and static typing.

## Why Serializable?
There are plenty of other Encoding and Decoding frameworks available. Why should you use Serializable? 

* [Performance](https://github.com/nodes-ios/Serializable/wiki/Performance-tests). Serializable is fast, up to 4x faster than similar frameworks
* [Features](https://github.com/nodes-ios/Serializable/wiki/Performance-tests#feature-comparison). Serializable can parse anything you throw at it. Nested objects, Enums, NSURL, UIColor, you name it!
* [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler). Every framework of this kind requires tedious boilerplate code that takes forever to write.  [![ModelBoiler](http://i.imgur.com/V5UzMVk.png)](https://github.com/nodes-ios/ModelBoiler) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) generates it for you instantly. 
* [Alamofire Integration](). Using the included Alamofire extensions makes implementing an API call returning parsed model data as simple as doing a one-liner!
* [Expandability](). Parsing into other datatypes can easily be added.
* [Persisting](). Combined with our caching framework [Cashier](https://github.com/nodes-ios/Cashier), Serializable objects can be very easily persisted to disk. 
* <a href = "https://github.com/nodes-ios/SerializableXcodeFileTemplate"><img src = "https://raw.githubusercontent.com/nodes-ios/SerializableXcodeFileTemplate/master/Serializable/Serializable%20Model.xctemplate/TemplateIcon.png" height = 25> Serializable Xcode File Template </a> makes it easier to create the model files in Xcode.


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

###Using with Alamofire

Serializable comes integrated with Alamofire out of the box, through an extension on Alamofire's `Request` construct, that adds the function `responseSerializable(completion:unwrapper)`

The extension uses Alamofire's familiar `Response` type to hold the returned data, and uses its generic associated type to automatically parse the data.

Consider an endpoint returning a single `school` structure matching the struct from the example above. To implement the call, simply add a function to your shared connection manager or where ever you like to put it:

~~~swift
static func requestSchool:(completion: (Response<School, NSError>) -> Void)) {
	request(.GET, "http://somewhere.com/school/1").responseSerializable(completion)
}
~~~

In the consuming method you use it like this: 

~~~swift
ConnectionManager.requestSchool() { (response) in 
	switch response.result {
		case .Success(let school):
			//Use your new school object!
			
		case .Failure(let error):
			//Handle the error object, or check your Response for more detail
	}
}
~~~

For an array of objects, use the same technique:

~~~swift
static func requestStudents:(completion: (Response<[Student], NSError>) -> Void)) {
	request(.GET, "http://somewhere.com/school/1/students").responseSerializable(completion)
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

The `unwrapper` closure has 2 input arguments: The `sourceDictionary` (the JSON Response Dictionary) and the `expectedType` (the *type* of the target Serializable). Return the object that will serve as the input for the Serialiable initializer. 

~~~swift
static func requestStudents:(completion: (Response<[Student], NSError>) -> Void)) {
	request(.GET, "http://somewhere.com/school/1/students").responseSerializable(completion, unwrapper: { $0.0["students"] })
}
~~~

If you need to unwrap the response data in every call, you can install a default unwrapper using 

~~~swift
Parser.defaultWrapper = { You unwrapper here... }
~~~

The `expectedType` can be used to dynamically determine the key based on the type name using reflection. This is especially useful when handling paginated data. 

See [here](https://github.com/nodes-ios/Nodes) for an example on how we use this in our projects at Nodes.

***NOTE:*** `responseSerializable` Internally calls `validate().responseJSON()` on the request, so don't do that.



## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Serializable** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Serializable/blob/master/LICENSE) file for more info.
