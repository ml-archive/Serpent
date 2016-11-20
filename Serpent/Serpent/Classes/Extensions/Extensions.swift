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
	static public var customDateFormats: [String] = []

    public static func fromString<T>(_ string: String) -> T? {
        for format in allowedDateFormats + customDateFormats {
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
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        let a, r, g, b: UInt32
        
        guard Scanner(string: hex).scanHexInt32(&int) else {
            return nil
        }
        
        switch hex.characters.count {
        // RGB (12-bit)
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        // RRGGBB (24-bit)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        // ARGB (32-bit)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        return self.init(red: CGFloat(r) / 255,
                         green: CGFloat(g) / 255,
                         blue: CGFloat(b) / 255,
                         alpha: CGFloat(a) / 255) as? T
    }
}

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


