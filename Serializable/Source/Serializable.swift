//
//  Serializable.swift
//  NOCore
//
//  Created by Kasper Welner on 22/01/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation


// MARK: - Custom Operators -

infix operator <== { associativity left precedence 90 }

// For Encodable
public func <==<T>(left: (dict: NSMutableDictionary, key: String), right: T?) {
    left.dict.setValue(right as? AnyObject, forKey: left.key)
}

public func <==<T: Encodable>(left: (dict: NSMutableDictionary, key: String), right: T?) {
    left.dict.setValue(right?.encodableRepresentation(), forKey: left.key)
}

// For Decodable
public func <==<T, S where S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: Decodable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T: Decodable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: [T]?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: [T]? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: [T], right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: [T]? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

//MARK: - Extensions

public extension Array where Element:Encodable {
    func encodableRepresentation() -> [NSCoding] {
        return self.map { element in return element.encodableRepresentation() }
    }
}

public extension RawRepresentable {
	public func encodableRepresentation() -> RawValue {
		return self.rawValue
	}
}

public protocol Serializable: Decodable, Encodable, Keymappable {
}

public protocol Decodable {
	init(dictionary:NSDictionary?)
	static func array(source: AnyObject?) -> [Self]
}

public protocol Encodable {
    func encodableRepresentation() -> NSCoding
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

public protocol Keymappable {}

public extension Keymappable {

	/**
    Maps the content of value for **key** in **dictionary** to generic type **T**, conforming to **Serializable** protocol.
     
     - parameter dictionary: An optional dictionary containing values which should be parsed.
     - parameter key: ValueForKey will be called on the dictionary to extract the value to be parsed
     
     - returns: A mapped object conforming to *Serializable*, or nil if parsing failed
     */
	public func mapped<T where T:Decodable>(dictionary: NSDictionary?, key: String) -> T? {
		
		guard let dict = dictionary else {
			return nil
		}
		
		let sourceOpt = dict[key]

        if sourceOpt != nil && sourceOpt is NSDictionary {
            return T(dictionary: (sourceOpt as! NSDictionary))
        }

        return nil
	}
	
    /**
     Maps the content of value for **key** in **dictionary** to an array containing where elements is of generic type **T**, conforming to **Serializable** protocol.
     
     - parameter dictionary: An optional dictionary containing values which should be parsed.
     - parameter key: ValueForKey will be called on the dictionary to extract the value to be parsed.
     
     - returns: An array of mapped objects conforming to *Serializable*, or an empty array if parsing failed.
     */
	public func mapped<T where T:_ArrayType, T:CollectionType, T.Generator.Element: Decodable>(dictionary: NSDictionary?, key: String) -> T? {
		
		guard let dict = dictionary else {
			return T()
		}
		
		let sourceOpt = dict[key]

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

        // Get the value from the dictionary for our key
		let sourceOpt = dict[key]

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
        
        let sourceOpt = dict[key]
        
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
        
        let sourceOpt = dict[key]
        
        if let source = sourceOpt as? [T.Generator.Element.RawValue] {
            let finalArray = source.map { T.Generator.Element.init(rawValue: $0)! }
            return (finalArray as! T)
        }
        
        return T()
    }
}

public protocol StringInitializable {
	init?(string: String)
}

extension NSURL:StringInitializable {
}

public struct Date: StringInitializable {
    
    //MARK: Public
    
    public static var ISOFormatter:NSDateFormatter {
        return formatter()
    }
    
    
    public let value:NSDate
    public var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    public init() {
        value = NSDate()
    }
    
    public init?(string: String) {
        
        if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") {
            value = dateObject
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
        }
        else
            if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd'T'HH:mm:ss") {
                value = dateObject
                dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
            }
            else
                if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd") {
                    value = dateObject
                    dateFormat = "yyyy-MM-dd"
                    
                }
                else {
                    return nil
        }
    }
    
    /**
        Convert a `String` that holds a date into a `NSDate`.
        Check if `date String` is in a format which is possible to parse.
        Therefore it will call the private function `dateFromString` that will return the converted date after checking or if it is not possible to parse it will return `nil`.
     
        - Parameter string: `String` that holds a date.
        - Returns: Converted date string as `NSDate` that was checked for validation or `nil`.
     */
    public static func dateFromString(string:String) -> NSDate? {
        
        if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") {
            return dateObject
            
        }
        else
            if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd'T'HH:mm:ss") {
                return dateObject
                
            }
            else
                if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd") {
                    return dateObject
                    
        }
        print("Failed to parse datestring: \(string) as format")
        return nil
    }
    
    /**
        Priviate function `dateFromString` that will check if the `format` of a date `String` is possible to parse to a `NSDate`. If possible it will convert the `String` into a `NSDate`.
     
        - Parameter:
            - string: `String` that holds a date.
            - format: The date format that will be checked.
        - Returns: Converted date string as `NSDate` or `nil`.
    */
    private static func dateFromString(string:String, format:String) -> NSDate? {
        Date.internalISOFormatter.dateFormat = format
        if let dateObject = Date.internalISOFormatter.dateFromString(string) {
            return dateObject
        }
        
        return nil
    }
    
    public init?(date: NSDate) {
        value = date
    }
    
    /**
        Convert a `date` into a `String` in a predefined format.
     
        - returns: Converted `date` as a `String`.
    */
    public func stringRepresentation() -> String {
        Date.internalISOFormatter.dateFormat = dateFormat
        return Date.internalISOFormatter.stringFromDate(value)
    }
    
    /**
        Make a `date Sring` encodable.
     
        - returns: `Date` as encodable `NSCoding`.
     */
    public func encodableRepresentation() -> NSCoding {
        return self.stringRepresentation()
    }
    
    //MARK: Private
    
    private static let internalISOFormatter = NSDateFormatter()
    
    internal static func formatter() -> NSDateFormatter {
        Date.internalISOFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return Date.internalISOFormatter
    }
}

@objc public class BridgingBox : NSObject, NSCoding {
    
    static var sharedBoxCache = [String : Any]()
    
    private var internalValue:Serializable?
    public var dictValue:NSDictionary?

    /**
        Get value of the `NSDictionary` `dictValue` that will be or was archived and that conforms with `Serializable`.
     
        - returns: Value of type `Serializable` or `nil`.
    */
    public func value<T:Serializable>() -> T? {
        if let dictValue = dictValue where internalValue == nil {
            return T(dictionary: dictValue)
        }
        
        return internalValue as? T
    }
    
    public init(_ value: Serializable) {
        self.internalValue = value
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        dictValue = aDecoder.decodeObjectForKey("dictValue") as? NSDictionary
    }
    
   public func encodeWithCoder(aCoder: NSCoder) {
        if let value = internalValue {
            if dictValue == nil {
                dictValue = value.encodableRepresentation() as? NSDictionary
            }
            
            aCoder.encodeObject(dictValue, forKey:"dictValue")
        }
    }
}
