# Serializable

Serializable is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's implemented using protocol extensions, which makes it easily expandable.

It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects.

It's designed to be used together with our helper app, the Model Boiler, making model creation a breeze.

The Serializable framework uses static typing, exhibiting superior performance compared to frameworks using reflection and eliminates boilerplate code.

[![Travis](https://img.shields.io/travis/nodes-ios/Serializable.svg)](https://travis-ci.org/nodes-ios/Serializable)
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/Serializable.svg)](https://codecov.io/github/nodes-ios/Serializable)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Serializable.svg)](https://cocoapods.org/pods/Serializable)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serializable/blob/master/LICENSE)

## 📝 Requirements

* iOS 8.0+

## 📦 Installation

### Carthage
~~~
github "nodes-ios/Serializable"
~~~

### CocoaPods
~~~
pod 'Serializable', '~> 0.0.1'
~~~

### Swit Package Manager
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

**NOTE:** This doesn't currently work as SPM doens't support iOS, but once it will we will already be supporting it! :)


## 🔧 Setup

We **highly** recommend you use our ![ModelBoiler](http://i.imgur.com/V5UzMVk.png) [Model Boiler](https://github.com/nodes-ios/ModelBoiler) to assist with generating the boilerplate code needed to conform to Serializable. Instructions for installation and usage can be found at the [Model Boiler github repository](https://github.com/nodes-ios/ModelBoiler). 

## 💻 Usage

### Getting started

Serializable supports Primitive types, Enums, other Serializables, and Arrays of all of the aforementioned types. Your variable declarations can have a default value or be optional. 

1. Create your model struct or class:

~~~
struct Foo {
	var id = 0
	var name = ""
	var address: String? 
}
~~~

**NOTE:** Classes must be marked `final`

2. Add the required methods for `Encodable` and `Decodable`: 

~~~
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

And thats it! If you're using the ![ModelBoiler](http://i.imgur.com/V5UzMVk.png) [Model Boiler](https://github.com/nodes-ios/ModelBoiler), this extension will be generated for you, so that you don't need to type it all out for every model you have. 

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Serializable** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Serializable/blob/master/LICENSE) file for more info.
