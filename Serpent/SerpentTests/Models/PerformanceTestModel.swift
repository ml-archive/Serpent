//
//  PerformanceTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//


import Serpent


struct PerformanceTestModel {
	
	enum EyeColor: String {
		case Blue = "blue"
		case Green = "green"
		case Brown = "brown"
	}
	
	enum Fruit: String {
		case Apple = "apple"
		case Banana = "banana"
		case Strawberry = "strawberry"
	}
	
	var id = ""
	var index = 0
	var guid = ""
	var isActive = true //<- isActive
	var balance = ""
	var picture: NSURL?
	var age = 0
	var eyeColor: EyeColor = .Brown //<- eyeColor
	var name = Name()
	var company = ""
	var email = ""
	var phone = ""
	var address = ""
	var about = ""
	var registered = ""
	var latitude = 0.0
	var longitude = 0.0
	var greeting = ""
	var favoriteFruit: Fruit? //<- favoriteFruit
}

extension PerformanceTestModel: Serializable {
	init(dictionary: NSDictionary?) {
		id            <== (self, dictionary, "id")
		index         <== (self, dictionary, "index")
		guid          <== (self, dictionary, "guid")
		isActive      <== (self, dictionary, "isActive")
		balance       <== (self, dictionary, "balance")
        //picture       <== (self, dictionary, "picture")
		age           <== (self, dictionary, "age")
        //eyeColor      <== (self, dictionary, "eyeColor")
        //name          <== (self, dictionary, "name")
		company       <== (self, dictionary, "company")
		email         <== (self, dictionary, "email")
		phone         <== (self, dictionary, "phone")
		address       <== (self, dictionary, "address")
		about         <== (self, dictionary, "about")
		registered    <== (self, dictionary, "registered")
        //latitude      <== (self, dictionary, "latitude")
        //longitude     <== (self, dictionary, "longitude")
		greeting      <== (self, dictionary, "greeting")
        //favoriteFruit <== (self, dictionary, "favoriteFruit")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")            <== id
		(dict, "index")         <== index
		(dict, "guid")          <== guid
		(dict, "isActive")      <== isActive
		(dict, "balance")       <== balance
		(dict, "picture")       <== picture
		(dict, "age")           <== age
		(dict, "eyeColor")      <== eyeColor
		(dict, "name")          <== name
		(dict, "company")       <== company
		(dict, "email")         <== email
		(dict, "phone")         <== phone
		(dict, "address")       <== address
		(dict, "about")         <== about
		(dict, "registered")    <== registered
		(dict, "latitude")      <== latitude
		(dict, "longitude")     <== longitude
		(dict, "greeting")      <== greeting
		(dict, "favoriteFruit") <== favoriteFruit
		return dict
	}
}

struct Name {
	var first = ""
	var last = ""
}

extension Name: Serializable {
	init(dictionary: NSDictionary?) {
		first <== (self, dictionary, "first")
		last  <== (self, dictionary, "last")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "first") <== first
		(dict, "last")  <== last
		return dict
	}
}
