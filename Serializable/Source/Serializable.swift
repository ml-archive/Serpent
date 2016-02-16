//
//  Serializable.swift
//  NOCore
//
//  Created by Kasper Welner on 22/01/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol Serializable: Decodable, Encodable, Keymappable {}

public protocol Encodable {
	func encodableRepresentation() -> NSCoding
}

public protocol Decodable {
	init(dictionary:NSDictionary?)
	static func array(source: AnyObject?) -> [Self]
}

public extension Decodable {
	public static func array(source: AnyObject?) -> [Self] {
		guard let source = source as? [NSDictionary] else {
			return [Self]()
		}
        return source.map {
            Self(dictionary: ($0))
        }
	}
}

private struct DefaultKeyMappings {
    private static let mappings = [String : String]()
}

public protocol Keymappable {
	func inputKeyMappings() -> [String : String]
}

public extension Keymappable {

	public func inputKeyMappings() -> [String : String] {
		return DefaultKeyMappings.mappings
	}
	
	///Used for objects conforming to 'Serializable' protocol
	public func mapped<T where T:Decodable>(dictionary: NSDictionary?, key: String) -> T? {
		
		guard let dict = dictionary else {
			return nil
		}
		
		let newKey = inputKeyMappings()[key] ?? key
		let sourceOpt = dict[newKey]

        if sourceOpt != nil && sourceOpt is NSDictionary {
            return T(dictionary: (sourceOpt as! NSDictionary))
        }

        return nil
	}
	
	///Used for arrays containing Serializable objects
	public func mapped<T where T:_ArrayType, T:CollectionType, T.Generator.Element: Decodable>(dictionary: NSDictionary?, key: String) -> T? {
		
		guard let dict = dictionary else {
			return T()
		}
		
		let newKey = inputKeyMappings()[key] ?? key
		let sourceOpt = dict[newKey]

        if sourceOpt is [NSDictionary] {
            let source = (sourceOpt as! [NSDictionary])
            let finalArray = source.map { T.Generator.Element.init(dictionary: $0) } as? T
            return finalArray ?? T()
        }

        return T()
	}
	
    /**
     A generic mapping function that will try to parse primitive types from the provided dictionary.
     Currently supported types are `Int`, `Float`, `Double`, `Bool`, `Char` and `String`.

     The `key` parameter will be first used to check value in custom input key mappings and if
     no value is found, then `key` is used as the key to get the value stored in `dictionary`.

     - parameter dictionary: An optional dictionary containing values which should be parsed.
     - parameter key: The key which will be used to get the actual key from input key mappings
     or as the actual key for the value being parsed from the dictionary.

     - returns: The value of primitive type `T` or `nil` if parsing was unsuccessful.
     */
	public func mapped<T>(dictionary: NSDictionary?, key: String) -> T? {

        // Ensure the dictionary is not nil
		guard let dict = dictionary else {
            return nil
		}

        // Check the input key mappings for a different key, 
        // fallback to the one provided as a parameter if nothing found
		let newKey = inputKeyMappings()[key] ?? key

        // Get the value from the dictionary for our key
		let sourceOpt = dict[newKey]

        // Figure out what type is the value we got and parse accordingly
        switch sourceOpt {

        case (is T):
            return (sourceOpt as! T)

        case (is String) where T.self is Int.Type:
            let source = (sourceOpt as! String)
            return Int(source) as? T

        case (is String) where T.self is Double.Type:
            let source = (sourceOpt as! String)
            return Double(source) as? T

        case (is NSString) where T.self is Bool.Type:
            let source = (sourceOpt as! NSString)
            return source.boolValue as? T

        case (is Int) where T.self is String.Type:
            let source = (sourceOpt as! Int)
            return String(source) as? T

        case (is String) where T.self is Character.Type:
            let source = (sourceOpt as! String)
            return Character(source) as? T

        case (is Double) where T.self is String.Type:
            let source = (sourceOpt as! Double)
            return String(source) as? T

        case (is Bool) where T.self is String.Type:
            let source = (sourceOpt as! Bool)
            return String(source) as? T

        default:
			return nil

        }
	}
	
    ///Used for NSURL, etc.
    public func mapped<T:StringInitializable>(dictionary: NSDictionary?, key: String) -> T? {
        
        guard let dict = dictionary else {
            return nil
        }
        
        let newKey = inputKeyMappings()[key] ?? key
        let sourceOpt = dict[newKey]
        
        if let source = sourceOpt as? T {
            return source
        } else if let source = sourceOpt as? String where source.characters.count > 0 {
            return T(string: source)
        }
        
        return nil
    }
	
    /**
     A generic mapping function that will try to parse enumerations with raw value from the 
     provided dictionary. 
     
     This function internally uses a variant of the generic `mapped()` function used to parse 
     primitive types, which means that only enums with raw value of primitive type are supported.

     The `key` parameter will be first used to check value in custom input key mappings and if
     no value is found, then `key` is used as the key to get the value stored in `dictionary`.

     - parameter dictionary: An optional dictionary containing values which should be parsed.
     - parameter key: The key which will be used to get the actual key from input key mappings
     or as the actual key for the value being parsed from the dictionary.

     - returns: The enumeration of enum type `T` or `nil` if parsing was unsuccessful or 
     enumeration does not exist.
     */
	public func mapped<T:RawRepresentable>(dictionary: NSDictionary?, key: String) -> T? {
        guard let source: T.RawValue = self.mapped(dictionary, key: key) else {
            return nil
        }

        return T(rawValue: source)
	}
    
    /**
     A generic mapping function that will try to parse an array of enumerations with raw value from the
     array contained in the provided dictionary.
     
     The `key` parameter will be first used to check value in custom input key mappings and if
     no value is found, then `key` is used as the key to get the value stored in `dictionary`.
     
     - parameter dictionary: An optional dictionary containing the array which should be parsed.
     - parameter key: The key which will be used to get the actual key from input key mappings
     or as the actual key for the value being parsed from the dictionary.
     
     - returns: An array of enum type `T` or an empty array if parsing was unsuccessful.
     */
    public func mapped<T where T:_ArrayType, T:CollectionType, T.Generator.Element: RawRepresentable>(dictionary: NSDictionary?, key: String) -> T? {
        
        guard let dict = dictionary else {
            return T()
        }
        
        let newKey = inputKeyMappings()[key] ?? key
        let sourceOpt = dict[newKey]
        
        if sourceOpt is [T.Generator.Element.RawValue] {
            let source = (sourceOpt as! [T.Generator.Element.RawValue])
            let finalArray = source.map { T.Generator.Element.init(rawValue: $0) } as? T
            return finalArray ?? T()
        }
        
        return T()
    }
}
