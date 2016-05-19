//
//  LoginInfo.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable

struct LoginInfo {
    var username = ""
    var password = ""
    var salt   = ""
    var md5    = ""
    var sha1   = ""
    var sha256 = ""
}

extension LoginInfo: Serializable {
    init(dictionary: NSDictionary?) {
        username <== (self, dictionary, "username")
        password <== (self, dictionary, "password")
        salt     <== (self, dictionary, "salt")
        md5      <== (self, dictionary, "md5")
        sha1     <== (self, dictionary, "sha1")
        sha256   <== (self, dictionary, "sha256")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "username") <== username
        (dict, "password") <== password
        (dict, "salt")     <== salt
        (dict, "md5")      <== md5
        (dict, "sha1")     <== sha1
        (dict, "sha256")   <== sha256
        return dict
    }
}