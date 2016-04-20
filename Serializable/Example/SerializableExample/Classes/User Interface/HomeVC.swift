//
//  HomeVC.swift
//  Serializable Example
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: UserListCell.reuseIdentifier, bundle: nil),
                              forCellReuseIdentifier: UserListCell.reuseIdentifier)

        reloadData()
    }

    // MARK: - Callbacks -

    func reloadData() {
        ConnectionManager.fetchRandomUsers { (response) in
            switch response.result {
            case .Success(let users):
                self.users = users
                self.tableView.reloadData()
            case .Failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        reloadData()
    }

    // MARK: - UITableView Data Source & Delegate -

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserListCell.staticHeight
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserListCell.reuseIdentifier, forIndexPath: indexPath) as? UserListCell ?? UserListCell()
        cell.populateWithUser(users[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowUserDetails", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowUserDetails" {
            if let userVC = segue.destinationViewController as? UserDetailsVC {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                userVC.user = users[indexPath.row]
            }
        }
    }
}

