
//  AlamofireExtension.swift
//  Serializable
//
//  Created by Kasper Welner on 08/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Alamofire

public struct Parser {
    public static let APICallSucceededNotification = "APICallSucceededNotification"
}

public extension Parser {
    
    /**
     Parse any generic object using the parsing handler.
     */
    
    internal static func serializer<T>(_ parsingHandler: (( _ data: Any? ) -> T?)?) -> DataResponseSerializer<T> {
        return DataResponseSerializer<T> { (request, response, data, error) -> Result<T> in
            
           
            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            switch result {
            case let .success(value):
                if let parsedObject: T = parsingHandler?( value ) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: APICallSucceededNotification), object: nil)
                    return .success(parsedObject)
                } else {
                    return .failure(NSError(domain: "Serializable.Parser", code: 2048, userInfo: [ NSLocalizedDescriptionKey : "Parsing block failed!", "JSONResponse" : value]))
                }
                
            case let .failure(error):
                if let data = data , data.count != 0 {
                    //TODO; Find out what to do with error
//                    var userInfo = error.userInfo
//                    userInfo["ResponseString"] = String(data: data, encoding: String.Encoding.utf8)
//                    let newError = NSError(domain: error.domain, code: error.code, userInfo: userInfo)
                    return .failure(error)
                }
                
                return .failure(error)
            }
        }
    }
    
    typealias Unwrapper = ((_ sourceDictionary: NSDictionary, _ expectedType:Any) -> Any?)
    
    /**
     The default unwrapper. Default implementation just passes data straight through. 
     */
    
    public static var defaultUnwrapper: Unwrapper = { $0.0 }
}


//MARK: - Wrapper methods

public extension Alamofire.DataRequest
{
    /**
     Adds a handler that attempts to parse the result of the request into a **Decodable**
     
     - parameter completionHandler:A closure that is invoked when the request is finished
     
     - parameter unwrapper: A closure that extracts the data to be parsed from the JSON response data.
     The default implementation checks for a "data" field in the JSON response, then checks for a field
     with the same name as the target model. If not found, it passes the JSON response straight through.
     
     - returns: The request
     */
    @discardableResult
    public func responseSerializable<T:Decodable>(_ completionHandler: @escaping (DataResponse<T>) -> Void, unwrapper:@escaping Parser.Unwrapper = Parser.defaultUnwrapper) -> Self {
        let serializer = Parser.serializer( {
            ( data: Any? ) -> T? in
            
            if let sourceDictionary = data as? NSDictionary {
                
                let unwrappedDictionary = unwrapper(sourceDictionary, T.self) as? NSDictionary ?? sourceDictionary
                
                return T(dictionary: unwrappedDictionary) as T?
            }
            
            return nil
        })
        
        return validate().response(responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    /**
     Adds a handler that attempts to parse the result of the request into an array of **Decodable**
     
     - parameter completionHandler:A closure that is invoked when the request is finished
     
     - parameter unwrapper: A closure that extracts the data to be parsed from the JSON response data.
     The default implementation checks for a "data" field in the JSON response, then checks for a field
     with the same name as the target model. If not found, it passes the JSON response straight through.
     
     - returns: The request
     */
	@discardableResult
    public func responseSerializable<T:Decodable>(_ completionHandler: @escaping (DataResponse<[T]>) -> Void, unwrapper:@escaping Parser.Unwrapper = Parser.defaultUnwrapper) -> Self {
        
        let serializer = Parser.serializer( {
            ( data: Any? ) -> [T]? in
            
            var finalArray:Any? = data
            
            if let dataDict = data as? NSDictionary {
                if let unwrappedArray = unwrapper(dataDict, T.self) as? NSArray {
                    finalArray = unwrappedArray
                }
            }
            
            if let sourceArray = finalArray as? NSArray {
                return T.array(sourceArray)
            }
            return nil
        })
        
        return validate().response(responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    /**
     Convenience method for a handler that does not need to parse the results of the network request.
     
     - parameter completionHandler:A closure that is invoked when the request is finished
     
     - returns: The request
     */
    
	@discardableResult
    public func responseSerializable(_ completionHandler: @escaping (DataResponse<NilSerializable>) -> Void) -> Self {
        return validate().responseJSON(completionHandler: completionHandler)
    }
    
}
// Convenience type for network requests with no response data
public typealias NilSerializable = Any
