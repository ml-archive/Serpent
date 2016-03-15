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

}
