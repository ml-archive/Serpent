//
//  Extensions.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

public extension SequenceType where Generator.Element:Encodable {
	func encodableRepresentation() -> [NSCoding] {
		return self.map { element in return element.encodableRepresentation() }
	}
}

public extension RawRepresentable {
	public func encodableRepresentation() -> RawValue {
		return self.rawValue
	}
}


public protocol StringInitializable {
	init?(string: String)
}

extension NSURL:StringInitializable {}

public protocol HexInitializable {
    static func colorWithHexString (hex:String) -> UIColor?
}

let validHexRegex = try! NSRegularExpression(pattern: "[0-9A-F]{6}", options: NSRegularExpressionOptions(rawValue: 0))

extension UIColor:HexInitializable {
    
    public static func colorWithHexString (hex:String) -> UIColor? {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if cString.characters.count != 6 {
            return nil
        }
        
        let range = NSMakeRange(0, 6)
        
        if validHexRegex.numberOfMatchesInString(cString, options: NSMatchingOptions(rawValue:0), range: range) != 1 {
            return nil
        }
        
        let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
        let gString = cString.substringWithRange(Range<String.Index>(cString.startIndex.advancedBy(2)..<cString.startIndex.advancedBy(4)))
        let bString = cString.substringWithRange(Range<String.Index>(cString.startIndex.advancedBy(4)..<cString.startIndex.advancedBy(6)))
        
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
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
		else if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd'T'HH:mm:ss") {
			value = dateObject
			dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		}
		else if let dateObject = Date.dateFromString(string, format: "yyyy-MM-dd") {
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

extension Date: Equatable {
	
}

public func ==(lhs: Date, rhs: Date) -> Bool {
	return lhs.stringRepresentation() == rhs.stringRepresentation()
}
