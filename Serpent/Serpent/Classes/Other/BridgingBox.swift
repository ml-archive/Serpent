//
//  Bridging.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

@objc open class BridgingBox : NSObject, NSCoding {
	
	static var sharedBoxCache = [String : Any]()
	
	fileprivate var internalValue: Encodable?
	open var dictValue:NSDictionary?
	
	/**
	Get value of the `NSDictionary` `dictValue` that will be or was archived and that conforms with `Serializable`.
	
	- returns: Value of type `Serializable` or `nil`.
	*/
	open func value<T:Serializable>() -> T? {
		if let dictValue = dictValue , internalValue == nil {
			return T(dictionary: dictValue)
		}
		
		return internalValue as? T
	}
	
	public init(_ value: Encodable) {
		self.internalValue = value
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init()
		dictValue = aDecoder.decodeObject(forKey: "dictValue") as? NSDictionary
	}
	
	open func encode(with aCoder: NSCoder) {
		if let value = internalValue {
			if dictValue == nil {
				dictValue = value.encodableRepresentation() as? NSDictionary
			}
			
			aCoder.encode(dictValue, forKey:"dictValue")
		}
	}
}
