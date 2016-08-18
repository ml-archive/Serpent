//
//  Extensions.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

// MARK: - Protocols -
// MARK: String Initializable

public protocol StringInitializable {
    static func fromString<T>(_ string: String) -> T?
    func stringRepresentation() -> String
}

extension URL: StringInitializable {
    public static func fromString<T>(_ string: String) -> T? {
        return self.init(string: string) as? T
    }

    public func stringRepresentation() -> String {
        return self.absoluteString
    }
}

extension Date: StringInitializable {
    static fileprivate let internalDateFormatter = DateFormatter()
    static fileprivate let allowedDateFormats = ["yyyy-MM-dd'T'HH:mm:ssZZZZZ", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd"]

    public static func fromString<T>(_ string: String) -> T? {
        for format in allowedDateFormats {
            internalDateFormatter.dateFormat = format
            if let date = internalDateFormatter.date(from: string) as? T {
                return date
            }
        }

        return nil
    }

    public func stringRepresentation() -> String {
        Date.internalDateFormatter.dateFormat = Date.allowedDateFormats.first
        return Date.internalDateFormatter.string(from: self)
    }
}

// MARK: Hex Initializable
#if os(OSX)
	import Cocoa
	typealias Color = NSColor
#else
	import UIKit
	typealias Color = UIColor
#endif

public protocol HexInitializable {
	static func fromHexString<T>(_ hexString: String) -> T?
}

extension Color: HexInitializable {
	public static func fromHexString<T>(_ hexString: String) -> T? {
		let charSet = CharacterSet.whitespacesAndNewlines
		var str = hexString.trimmingCharacters(in: charSet).uppercased()
		
		if (str.hasPrefix("#")) {
			str = str.substring(from: str.index(str.startIndex, offsetBy: 1))
		}
		
		// TODO: Handle 3, 4 & 8 character long HEX strings in the future
		if str.characters.count != 6 {
			return nil
		}
		
		let range   = NSMakeRange(0, 6)
		let options = NSRegularExpression.MatchingOptions(rawValue:0)
		
		guard validHexRegex.numberOfMatches(in: str, options: options, range: range) == 1 else {
			return nil
		}
		
		let rString = str.substring(to: str.index(str.startIndex, offsetBy: 2))
		let gString = str.substring(with: str.index(str.startIndex, offsetBy: 2)..<str.index(str.startIndex, offsetBy: 4))
		let bString = str.substring(with: str.index(str.startIndex, offsetBy: 4)..<str.index(str.startIndex, offsetBy: 6))
		
		var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
		Scanner(string: rString).scanHexInt32(&r)
		Scanner(string: gString).scanHexInt32(&g)
		Scanner(string: bString).scanHexInt32(&b)
		
		return self.init(
			red: CGFloat(r) / 255.0,
			green: CGFloat(g) / 255.0,
			blue: CGFloat(b) / 255.0,
			alpha: 1.0) as? T
	}
}

let validHexRegex = try! NSRegularExpression(pattern: "[0-9A-F]{6}", options: NSRegularExpression.Options(rawValue: 0))



// MARK: - Extensions -
// MARK: SequenceType

public extension Sequence where Iterator.Element:Encodable {
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


