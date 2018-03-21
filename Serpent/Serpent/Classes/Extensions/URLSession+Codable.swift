//
//  URLSession+Codable.swift
//  Serpent
//
//  Created by Andrei Hogea on 16/03/2018.
//  Copyright © 2018 Nodes. All rights reserved.
//

import Foundation

// Decoded Result
public enum DResult<Value> {
    case success(Value)
    case successWithError(Value, Error)
    case failure(Error)
}

public extension URLSession {
    
    /**
     Adds a handler that attempts to parse the result of the request into a **Decodable**
     
     - parameter requestCompletion: The URLSession.dataTask completion
     
     - returns: The Decoded Result (DResult)
     */
    public func decode<Value: Swift.Decodable>(requestCompletion: (Data?, Error?)) -> DResult<Value> {
        switch requestCompletion {
        case (.some(let data), .some(let error)):
            do {
                let decodedData = try JSONDecoder().decode(Value.self, from: data)
                return .successWithError(decodedData, error)
            } catch let decodeError {
                return .failure(decodeError)
            }
        case (.some(let data), .none):
            do {
                let decodedData = try JSONDecoder().decode(Value.self, from: data)
                return .success(decodedData)
            } catch let decodeError {
                return .failure(decodeError)
            }
        case (.none, .some(let error)):
            return .failure(error)

        case (.none, .none):
            let fallBackError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"]) as Error
            return .failure(fallBackError)
        }
    }
    
    /**
     Adds a handler that attempts to parse the result of the request into a **Decodable**
     
     - parameter completion: A closure that is invoked when the request is finished, containting the desired DataModel to be returned
     
     - returns: The URLSession.dataTask completion
     */
    public func decode<Value: Swift.Decodable>(_ completion: @escaping ((DResult<Value>) -> Void)) -> ((Data?, URLResponse?, Error?) -> Void) {
        return { (data, _, error) in
            DispatchQueue.main.async {
                completion(self.decode(requestCompletion: (data, error)))
            }
        }
    }
}
