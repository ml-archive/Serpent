//
//  User.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable

enum Gender: String {
    case Male   = "male"
    case Female = "female"
}

struct User {
    var gender = Gender.Male
    var name   = NameInfo()

    var location = Location()

    var email     = ""
    var loginInfo = LoginInfo() // <-login

    var registrationDate = 0 // <-registered
    var birthDate        = 0 // <-dob

    var phoneNumber = "" // <-phone
    var cellNumber  = "" // <-cell

    var identification = Identification() // <-id

    var picture = ProfilePicture()
}

extension User: Serializable {
    init(dictionary: NSDictionary?) {
        gender           <== (self, dictionary, "gender")
        name             <== (self, dictionary, "name")
        location         <== (self, dictionary, "location")
        email            <== (self, dictionary, "email")
        loginInfo        <== (self, dictionary, "login")
        registrationDate <== (self, dictionary, "registered")
        birthDate        <== (self, dictionary, "dob")
        phoneNumber      <== (self, dictionary, "phone")
        cellNumber       <== (self, dictionary, "cell")
        identification   <== (self, dictionary, "id")
        picture          <== (self, dictionary, "picture")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "gender")     <== gender
        (dict, "name")       <== name
        (dict, "location")   <== location
        (dict, "email")      <== email
        (dict, "login")      <== loginInfo
        (dict, "registered") <== registrationDate
        (dict, "dob")        <== birthDate
        (dict, "phone")      <== phoneNumber
        (dict, "cell")       <== cellNumber
        (dict, "id")         <== identification
        (dict, "picture")    <== picture
        return dict
    }
}