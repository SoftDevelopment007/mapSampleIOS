//
//  SignupController.swift
//  mapSample
//
//  Created by Pedro on 11/2/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

import FirebaseDatabase


class SignupController: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var btn_signup: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txt_email.layer.cornerRadius = 5.0
        txt_email.layer.borderColor = UIColor.lightGray.cgColor
        txt_email.layer.borderWidth = 1
        
        txt_pass.layer.cornerRadius = 5.0
        txt_pass.layer.borderColor = UIColor.lightGray.cgColor
        txt_pass.layer.borderWidth = 1
        
        btn_signup.layer.cornerRadius = 5.0
        btn_signup.layer.borderColor = UIColor.lightGray.cgColor
        btn_signup.layer.borderWidth = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txt_email.text = ""
        txt_pass.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ontappedGotoSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedSignup(_ sender: Any) {
        
        if ((txt_email.text?.characters.count)! < 1 || (txt_email.text?.characters.count)! < 1 || (txt_pass.text?.characters.count)! < 1) {
            //self.view.dodo.error(UserDialogs.CompleteRequireFields.rawValue)
            return
        }
        
        //For Email_Signup using Firebase
        if self.txt_email.text == "" || self.txt_pass.text == ""
        {
            let alertController = UIAlertController(title: "Alert!", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            SVProgressHUD.show()
            FIRAuth.auth()?.createUser(withEmail: self.txt_email.text!, password: self.txt_pass.text!) { (user, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil
                {
                    DispatchQueue.main.async {
                        
                        let transition = CATransition()
                        transition.duration = 0.3
                        transition.type = "flip"
                        transition.subtype = kCATransitionFromLeft
                        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                        
                        
                        let user = FIRAuth.auth()?.currentUser
                        let newMessage = FIRDatabase.database().reference().child("Users").child((user?.uid)!)
                        
                        newMessage.removeValue()
                        let messageData =
                            [
                                "Location": ["latitude": g_latitude, "longitude": g_longitude],
                                "Email": self.txt_email.text,
                                "createdAt": [".sv": "timestamp"]
                            ] as [String : Any]
                        
                        newMessage.setValue(messageData)
                        
                        let alertController = UIAlertController(title: "Alert!", message: "Sucessfully Signed up.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        //self.performSegue(withIdentifier: StorySegues.FromEmailsignupToSignin.rawValue, sender: self)
                    }
                } else {
                    
                    self.txt_email.text = ""
                    self.txt_pass.text = ""
                    
                    let alertController = UIAlertController(title: "Alert!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

