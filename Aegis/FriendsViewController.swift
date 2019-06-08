//
//  FriendsViewController.swift
//  Aegis
//
//  Created by Gaurav Khot on 6/2/19.
//  Copyright © 2019 Tanvi Khot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    @IBOutlet weak var resultsTableView: UITableView!
    var users:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            var ref: DatabaseReference = Database.database().reference()
            let results = ref.child("users").child(user.uid).queryOrderedByKey()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
