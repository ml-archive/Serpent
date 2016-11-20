//
//  CashierExtension.swift
//  Serializable
//
//  Created by Chris Combs on 12/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Cashier

public extension Cashier {
	
	/**
	Set an `object` to the `BridgingBox` and link it with a `key`.
	
	- Parameters:
	- object: Generic type which confroms with `Serializable`.
	- key: Key as a `String`.
	*/
	public func setSerializable<T>(_ object: T, forKey key: String) where T: Serializable {
		let box = BridgingBox(object)
		self.setObject(box, forKey: key)
		BridgingBox.sharedBoxCache[self.id+key] = object
	}
	
	/**
	Set an `array` to the `BridgingBox` and link it with a `key`.
	
	- Parameters:
	- object: Generic type which confroms with `_ArrayType`.
	- key: Key as a `String`.
	*/
	public func setSerializable<T>(_ object: T, forKey key: String) where T: Sequence, T.Iterator.Element: Serializable {
		let boxedArray = object.map { BridgingBox($0) }
		self.setObject(boxedArray, forKey: key)
		BridgingBox.sharedBoxCache[self.id+key] = object
	}
	
	/**
	Check first if an object with the `key` from `BridgingBox sharedBoxCache` exists and if the `key` is valid.
	If an object for that `key` exisits and the `key` is valid, return the onject of `BridgingBox sharedBoxCache` for that key, if not return nil.
	
	If the object for that `key` of `BridgingBox sharedBoxCache` does not exist check if an `objectForKey` as `BridgingBox` with that `key` exists. Else return nil.
	If the object exisits get the value of that `BridgingBox` and assign it to `BridgingBox.sharedBoxCache` and return the object.
	
	- Parameter key: `Key` for `BridgingBox` or `objectForKey` as `String`.
	- Returns: Generic type stored value/object that conforms with `Serializable` or return `nil`.
	*/
	public func serializableForKey<T>(_ key: String) -> T? where T:Serializable {
		if let cachedSerializable = BridgingBox.sharedBoxCache[self.id+key] as? T {
			return self.object(forKeyIsValid: key) ? cachedSerializable : nil
		}
		
		guard let box:BridgingBox = self.object(forKey: key) as? BridgingBox else {
			return nil
		}
		
		let finalVal:T? = box.value()
		BridgingBox.sharedBoxCache[self.id+key] = finalVal
		return finalVal
	}
	
	
	/**
	Check first if an array with the `key` of `BridgingBox sharedBoxCache` exists and if the `key` is valid.
	If an array exisits for that `key` and the `key` is valid return the `BridgingBox sharedBoxCache` for that key, if not it will return nil.
	
	If the array for that `key` of `BridgingBox sharedBoxCache` does not exists check if an `objectForKey` as an `array` with that `key` exists that holds objects of `BridgingBox`. Else return nil.
	If the array exists get the values of that `BridgingBox` and append them to a `returnArray` and assign the array to `BridgingBox.sharedBoxCache` with the defined `key` and return the `array`.
	
	- Parameter key: `Key` for `BridgingBox` as `String`.
	- Returns: Array that holds object that conforms with `Serializable` or return `nil`.
	*/
	public func serializableForKey<T>(_ key: String) -> [T]? where T:Serializable {
		if let cachedSerializable = BridgingBox.sharedBoxCache[self.id+key] as? [T] {
			return self.object(forKeyIsValid: key) ? cachedSerializable : nil
		}
		
		guard let box = self.object(forKey: key) as? [BridgingBox] else {
			return nil
		}
		
		/// Why did I not just use the Map() function? Because it results in a Segmentation fault 11 from the compiler! Thanks, Jobs!!! :-(
		
		var returnArray = [T]()
		for boxval in box {
			if let val:T = boxval.value() {
				returnArray.append(val)
			}
		}
		
		BridgingBox.sharedBoxCache[self.id+key] = returnArray
		return returnArray
	}
	
	/**
	Clears all saved disk data and optionally purges all memory caches.
	
	- parameter purgeMemoryCaches: If set to `true`, it will also purge all memory caches, including
	the shared bridging box cache for objects adhering to `Serializable`.
	*/
	public func clearAllData(_ purgeMemoryCaches: Bool) {
		self.clearAllData()
		
		if purgeMemoryCaches {
			BridgingBox.sharedBoxCache.removeAll()
		}
	}
	
	/**
	Removes a serializable value from saved disk, and optionally the memory cache.
	
	- parameter key: `Key` for `BridgingBox` as `String`.
	- parameter purgeMemoryCache: If set to `true`, it will also purge the memory cache.
	*/
	public func deleteSerializableForKey(_ key: String, purgeMemoryCache purge: Bool = true) {
		if purge {
			BridgingBox.sharedBoxCache.removeValue(forKey: self.id+key)
		}
		self.deleteObject(forKey: key)
	}
}
