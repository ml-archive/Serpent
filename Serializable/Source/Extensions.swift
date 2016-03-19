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

