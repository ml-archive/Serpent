//
//  Alamofire+Codable.swift
//  Serpent
//
//  Created by Dominik Ringler on 16/03/2018.
//  Copyright © 2018 Nodes. All rights reserved.
//

import Alamofire

extension Alamofire.DataRequest {
    
    func responseCodable<T: Codable>(handler: @escaping (DataResponse<T>) -> Void) {
        responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    handler(DataResponse(request: self.request, response: self.response, data: data, result: .success(decodedData)))
                }
                catch let error {
                    handler(DataResponse(request: self.request, response: self.response, data: data, result: .failure(error)))
                }
            case .failure(let error):
                handler(DataResponse(request: self.request, response: self.response, data: nil, result: .failure(error)))
            }
        }
    }
}
