//
//  Extensions.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocols -
// MARK: String Initializable

public protocol StringInitializable {
    static func fromString<T>(string: String) -> T?
    func stringRepresentation() -> String
}

extension NSURL: StringInitializable {
    public static func fromString<T>(string: String) -> T? {
        return self.init(string: string) as? T
    }

    public func stringRepresentation() -> String {
        return self.absoluteString
    }
}

extension NSDate: StringInitializable {
    static private let internalDateFormatter = NSDateFormatter()
    static private let allowedDateFormats = ["yyyy-MM-dd'T'HH:mm:ssZZZZZ", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd"]

    public static func fromString<T>(string: String) -> T? {
        for format in allowedDateFormats {
            internalDateFormatter.dateFormat = format
            if let date = internalDateFormatter.dateFromString(string) as? T {
                return date
            }
        }

        return nil
    }

    public func stringRepresentation() -> String {
        NSDate.internalDateFormatter.dateFormat = NSDate.allowedDateFormats.first
        return NSDate.internalDateFormatter.stringFromDate(self)
    }
}

// MARK: Hex Initializable

let validHexRegex = try! NSRegularExpression(pattern: "[0-9A-F]{6}", options: NSRegularExpressionOptions(rawValue: 0))

public protocol HexInitializable {
    static func fromHexString<T>(hexString: String) -> T?
}

// MARK: - Extensions -
// MARK: SequenceType

public extension SequenceType where Generator.Element:Encodable {
	func encodableRepresentation() -> [NSCoding] {
		return self.map { element in return element.encodableRepresentation() }
	}
}

// MARK: RawRepresentable

public extension RawRepresentable {
	public func encodableRepresentation() -> RawValue {
		return self.rawValue
	}
}

// MARK: UIColor

extension UIColor: HexInitializable {
    public static func fromHexString<T>(hexString: String) -> T? {
        let charSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var str = hexString.stringByTrimmingCharactersInSet(charSet).uppercaseString

        if (str.hasPrefix("#")) {
            str = str.substringFromIndex(str.startIndex.advancedBy(1))
        }

        // TODO: Handle 3, 4 & 8 character long HEX strings in the future
        if str.characters.count != 6 {
            return nil
        }

        let range   = NSMakeRange(0, 6)
        let options = NSMatchingOptions(rawValue:0)

        guard validHexRegex.numberOfMatchesInString(str, options: options, range: range) == 1 else {
            return nil
        }

        let rString = str.substringToIndex(str.startIndex.advancedBy(2))
        let gString = str.substringWithRange(str.startIndex.advancedBy(2)..<str.startIndex.advancedBy(4))
        let bString = str.substringWithRange(str.startIndex.advancedBy(4)..<str.startIndex.advancedBy(6))

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)

        return self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1.0) as? T
    }
}
