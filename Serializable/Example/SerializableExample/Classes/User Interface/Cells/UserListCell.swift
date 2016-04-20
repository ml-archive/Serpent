//
//  UserListCell.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import UIKit
import Alamofire

class UserListCell: UITableViewCell {

    static let reuseIdentifier = "UserListCell"
    static let staticHeight: CGFloat = 72.0

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.layer.cornerRadius = 2
        profileImageView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        emailLabel.text = nil
    }
}

// MARK: - Populate -

extension UserListCell {
    func populateWithUser(user: User) {
        // Set image
        if let thumbnail = user.picture.thumbnail {
            profileImageView.imageFromUrl(thumbnail.URLString)
        }

        // Set name and email
        nameLabel.text = user.name.nameString
        emailLabel.text = user.email
    }
}