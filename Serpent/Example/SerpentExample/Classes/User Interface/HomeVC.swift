//
//  HomeVC.swift
//  Serpent Example
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

        tableView.register(UINib(nibName: UserListCell.reuseIdentifier, bundle: nil),
                              forCellReuseIdentifier: UserListCell.reuseIdentifier)

        reloadData()
    }

    // MARK: - Callbacks -

    func reloadData() {
        ConnectionManager.fetchRandomUsers { (response) in
            switch response.result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        reloadData()
    }

    // MARK: - UITableView Data Source & Delegate -

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserListCell.staticHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseIdentifier, for: indexPath) as? UserListCell ?? UserListCell()
        cell.populateWithUser(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowUserDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetails" {
            if let userVC = segue.destination as? UserDetailsVC, let indexPath = sender as? IndexPath {
                userVC.user = users[indexPath.row]
            }
        }
    }
}

