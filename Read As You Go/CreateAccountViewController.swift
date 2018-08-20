//
//  CreateAccountViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-02.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateAccountViewController: UIViewController {

    @IBOutlet var fullNameFIeld: UITextField!
    @IBOutlet var usernameFIeld: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func createAccount(_ sender: UIButton) {
        if fullNameFIeld.text == "" || usernameFIeld.text == "" || passwordField.text == "" || confirmPasswordField.text == ""{
            
            self.createAlert(title: "Create Account", message: "One or more fields are blank!")
            return
            
            
        }
        
        if passwordField.text != confirmPasswordField.text{
            self.createAlert(title: "Create Account", message: "Passwords do not match")
            
            return
        }
        
        
        let fullName = String(describing: fullNameFIeld.text!)
        let userName = String(describing: usernameFIeld.text!)
        let newPassword = String(describing: passwordField.text!)
        
        
        
        let parameters: Parameters = ["user": "\(userName)",
                                      "password": "\(newPassword)",
                                      "name": "\(fullName)"]
        
        Alamofire.request("https://adambibby.ca/user/", method: .post, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: "adam", password: "test").responseJSON{ response in
            
            let code = Int((response.response?.statusCode)!)
            
            if code == 500{
                self.createAlert(title: "Create Account", message: "Account with this name already exists!")
                return
            }
            
            self.performSegue(withIdentifier: "createSuccess", sender: nil)
            
            
        }
        
        
    }
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
