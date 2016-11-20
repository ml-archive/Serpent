//
//  ConnectionManager.swift
//  SerpentExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serpent
import Alamofire
import UIKit

// MARK: - Basic Setup -

struct ConnectionManager {
    static let manager = SessionManager(configuration: ConnectionManager.configuration())

    static func configuration() -> URLSessionConfiguration {
        let configuration = SessionManager.default.session.configuration

        configuration.timeoutIntervalForRequest = 20
        configuration.httpAdditionalHeaders = ["Accept" : "application/json"]

        return configuration
    }
}

extension ConnectionManager {

    static func fetchRandomUsers(userCount count: Int = 150, completion: @escaping (DataResponse<[User]>) -> Void) {
        let params: [String: AnyObject] = ["results" : count as AnyObject]

        manager.request("https://randomuser.me/api", method: .get,
                        parameters: params, headers: nil).responseSerializable(completion)
    }
}


// MARK: - Extensions -

extension UIImageView {

    // Taken from http://stackoverflow.com/a/30591853/1001803
    public func imageFromUrl(_ url: URL?) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
