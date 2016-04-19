//
//  UserDetailsVC.swift
//  SerializableExample
//
//  Created by Pablo Surfate on 4/18/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        usernameLabel.text = user.name.nameString
        locationLabel.text = user.location.city
        genderLabel.text = user.gender.encodableRepresentation()
        emailLabel.text = user.email
        phoneLabel.text = user.phoneNumber
        
        if let picture = user.picture.medium {
            profileImageView.imageFromUrl(picture.URLString)
        }
    }
}
