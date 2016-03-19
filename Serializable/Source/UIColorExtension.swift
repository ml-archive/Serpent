//
//  UIColorExtension.swift
//  Serializable
//
//  Created by Chris Combs on 19/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit


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
