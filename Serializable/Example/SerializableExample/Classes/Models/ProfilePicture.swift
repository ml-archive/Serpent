//
//  ProfilePicture.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable

struct ProfilePicture {
    var thumbnail: NSURL?
    var medium: NSURL?
    var large: NSURL?
}

extension ProfilePicture: Serializable {
    init(dictionary: NSDictionary?) {
        thumbnail <== (self, dictionary, "thumbnail")
        medium    <== (self, dictionary, "medium")
        large     <== (self, dictionary, "large")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "thumbnail") <== thumbnail
        (dict, "medium")    <== medium
        (dict, "large")     <== large
        return dict
    }
}