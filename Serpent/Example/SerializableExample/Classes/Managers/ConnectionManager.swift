//
//  ConnectionManager.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable
import Alamofire
import UIKit

// MARK: - Basic Setup -

struct ConnectionManager {
    static let manager: Manager = Manager(configuration: ConnectionManager.configuration())

    static func configuration() -> NSURLSessionConfiguration {
        let configuration = Manager.sharedInstance.session.configuration

        configuration.timeoutIntervalForRequest = 20
        configuration.HTTPAdditionalHeaders = ["Accept" : "application/json"]

        return configuration
    }
}

extension ConnectionManager {

    static func fetchRandomUsers(userCount count: Int = 150, completion: ((response: Response<[User], NSError>) -> Void)) {
        let params: [String: AnyObject] = ["results" : count]
        manager.request(.GET, "https://randomuser.me/api/", parameters: params).responseSerializable(completion)
    }
}


// MARK: - Extensions -

extension UIImageView {

    // Taken from http://stackoverflow.com/a/30591853/1001803
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}