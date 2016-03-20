//
//  UIColorExtension.swift
//  Serializable
//
//  Created by Chris Combs on 19/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit

// HexInitializable

public func <==<T, S where T: HexInitializable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T: HexInitializable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

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

extension Keymappable {
	
	/**
	A generic mapping function that will try to parse an object of type `T` from the hex string
	value contained in the provided dictionary.
	
	The `key` parameter will be first used to check value in custom input key mappings and if
	no value is found, then `key` is used as the key to get the value stored in `dictionary`.
	
	- parameter dictionary: An optional dictionary containing the array which should be parsed.
	- parameter key: The key which will be used to get the actual key from input key mappings
	or as the actual key for the value being parsed from the dictionary.
	
	- returns: The value of type `T` or `nil` if parsing was unsuccessful.
	*/
	public func mapped<T: HexInitializable>(dictionary: NSDictionary?, key: String) -> T? {
		guard let dict = dictionary, source = dict[key] else {
			return nil
		}
		
		if let hexString = source as? String where hexString.isEmpty == false {
			return T.fromHexString(hexString)
		}
		
		return source as? T
	}
}