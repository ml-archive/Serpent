# Serializable

Serializable is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's implemented using protocol extensions, which makes it easily expandable.

It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects.

It's designed to be used together with our helper app, the Model Boiler, making model creation a breeze.

The Serializable framework uses static typing, exhibiting superior performance compared to frameworks using reflection eliminate boilerplate code.


[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Serializable.svg)](https://cocoapods.org/pods/Serializable)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Serializable/blob/master/LICENSE)

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
To use KeyboardHelper as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following to your `Package.swift` file.  

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
> **TODO:** Add instructions


## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Serializable** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Serializable/blob/master/LICENSE) file for more info.
