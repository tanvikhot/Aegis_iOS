//
//  LoginViewController.swift
//  Aegis
//
//  Copyright © 2019 Tanvi Khot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var handle:AuthStateDidChangeListenerHandle!

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            }

        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let usernameText = usernameText!.text,
            let passwordText = passwordText.text else {
                return
        }
        self.usernameText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
        Auth.auth().signIn(withEmail: usernameText, password: passwordText) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("error \(error)")
                let alert = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(actionOK)
                DispatchQueue.main.async {
                    strongSelf.show(alert, sender: false)
                }
                return
            }
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let usernameText = usernameText!.text,
            let passwordText = passwordText.text else {
                return
        }
        Auth.auth().createUser(withEmail: usernameText, password: passwordText) { authResult, error in
            // ...
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
