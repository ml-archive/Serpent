//
//  Bridging.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

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
