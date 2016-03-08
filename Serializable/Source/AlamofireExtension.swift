//
//  AlamofireExtension.swift
//  Serializable
//
//  Created by Kasper Welner on 08/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Alamofire

public struct Harbor {
    public static let APICallSucceededNotification = "APICallSucceededNotification"
    public struct Error {
        
        let error:NSError?
        let response:NSHTTPURLResponse?
        let rawResponse:AnyObject?
        let request:NSURLRequest?
        
        func errorCode() -> Int {return 0}
    }
}

public enum ApiResult<T> {
    case Success(data:T)
    case Error(error:Harbor.Error)
}

public extension Alamofire.Response {
    func harborError() -> Harbor.Error {
        switch self.result {
        case .Failure(let error):
            var rawResponse:AnyObject?
            if let data = self.data {
                rawResponse = NSString(data: data, encoding: NSUTF8StringEncoding) as? String ?? ""
            } else {
                rawResponse = nil
            }
            let unwrappedError = error as NSError ?? NSError(domain: "Harbor", code: 2048, userInfo: [ NSLocalizedDescriptionKey : "Nodes parsing block failed!"])
            return Harbor.Error.init(error: unwrappedError, response: self.response, rawResponse: rawResponse, request: self.request)
        default:
            return Harbor.Error.init(error: nil, response: nil, rawResponse: nil, request: nil)
        }
    }
}

public extension Harbor {
    
    public static func nodesParse<T,S>(response response:Response<S, NSError>, completionHandler: (ApiResult<T>) -> Void, parsingHandler: (( data: AnyObject? ) -> T?)?) {
        switch response.result {
        case let Result.Success(value):
            if let parsedObject: T = parsingHandler?( data: value as? AnyObject ) {
                NSNotificationCenter.defaultCenter().postNotificationName(APICallSucceededNotification, object: nil)
                completionHandler(ApiResult.Success(data: parsedObject));
            } else {
                completionHandler(ApiResult.Error(error:response.harborError()))
            }
            
        case Result.Failure:
            completionHandler(ApiResult.Error(error:response.harborError()))
            break;
        }
    }
    
    public static func nodesParse<T:Serializable,S>(response response:Response<S, NSError>, completionHandler: ApiResult<T> -> Void) {
        nodesParse(response:response, completionHandler: completionHandler, parsingHandler: {
            ( data: AnyObject? ) -> T? in
            
            if let sourceDictionary = data as? [String : AnyObject] {
                
                let unwrappedDictionary = unwrappedSource(sourceDictionary, type:T.self) as? [String : AnyObject] ?? sourceDictionary
                
                return T(dictionary: unwrappedDictionary) as T?
            }
            
            return nil
        })
    }
    
    public static func nodesParse<T:Serializable,S>(response response:Response<S, NSError>, completionHandler: ApiResult<[T]> -> Void) {
        nodesParse(response:response, completionHandler: completionHandler, parsingHandler: {
            ( data: AnyObject? ) -> [T]? in
            
            var finalArray:AnyObject? = data
            
            if let dataDict = data as? NSDictionary {
                if let unwrappedArray = unwrappedSource(dataDict, type:T.self) as? [AnyObject] {
                    finalArray = unwrappedArray
                }
            }
            
            if let sourceArray = finalArray as? [AnyObject] {
                
                var returnArray:[T] = []
                for dict in sourceArray {
                    returnArray.append(T(dictionary: dict as? [String : AnyObject]))
                }
                return returnArray
            }
            return nil
        })
    }
    
    public static func nodesParse<S>(response response:Response<S, NSError>, completionHandler: ApiResult<Void> -> Void) {
        switch response.result {
        case Result.Success:
            NSNotificationCenter.defaultCenter().postNotificationName(APICallSucceededNotification, object: nil)
            completionHandler(ApiResult.Success(data: ()))
            
        case Result.Failure:
            completionHandler(ApiResult.Error(error:response.harborError()))
            break;
        }
    }
    
    public static func unwrappedSource(sourceDictionary: NSDictionary, type:Any) -> AnyObject {
        // Seriously, Swift? This is how you have to do this? All I want is the class of the generic type as a string
        let mirrorString = Mirror(reflecting: type).description
        var typeString:String = ""
        if let dotStartIndex = mirrorString.rangeOfString("for ")?.endIndex {
            typeString = mirrorString.substringFromIndex(dotStartIndex)
            if let nextDotStartIndex = typeString.rangeOfString(".")?.startIndex {
                typeString = typeString.substringToIndex(nextDotStartIndex)
            }
        }
        
        if let nestedObject: AnyObject = sourceDictionary[typeString] {
            return nestedObject
        }
        if let nestedObject: AnyObject = sourceDictionary["data"] {
            return nestedObject
        }
        
        return sourceDictionary
    }
}


//MARK: - NOParsing stuff

public extension Request
{
    
    public func JSONParse<T>(completionHandler: (ApiResult<T>) -> Void, parsingHandler: (( data: AnyObject? ) -> T?)?) -> Self {
        return validate().responseJSON(completionHandler: { (response) -> Void in
            Harbor.nodesParse(response: response, completionHandler: completionHandler, parsingHandler: parsingHandler)
        })
    }
    
    public func JSONParse<T:Serializable>(completionHandler: ApiResult<T> -> Void) -> Self {
        return validate().responseJSON(completionHandler: { (response) -> Void in
            Harbor.nodesParse(response: response, completionHandler: completionHandler)
        })
    }
    
    public func JSONParse<T:Serializable>(completionHandler: ApiResult<[T]> -> Void) -> Self {
        return validate().responseJSON(completionHandler: { (response) -> Void in
            Harbor.nodesParse(response: response, completionHandler: completionHandler)
        })
    }
    
    public func JSONParse(completionHandler: ApiResult<Void> -> Void) -> Self {
        return validate().voidParse(completionHandler)
    }
    
    internal func voidParse(completionHandler: ApiResult<Void> -> Void) -> Self {
        return validate().response(completionHandler: { (request, response, data, error) -> Void in
            
            if error == nil {
                completionHandler(ApiResult.Success(data: ()))
            } else {
                
                let error = error ?? NSError(domain: "Harbor", code: -1, userInfo: nil)
                
                completionHandler(ApiResult.Error(error:Harbor.Error.init(error: error, response: response, rawResponse: nil, request: request))
                )
            }
        })
    }
}
