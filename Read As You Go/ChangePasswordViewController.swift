//
//  ChangePasswordViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-29.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func changePassword(_ sender: UIButton) {
        
        if passwordField.text == "" || confirmPasswordField.text == "" {
            
            self.createAlert(title: "Create Account", message: "One or more fields are blank!")
            return
            
            
        }
        
        if passwordField.text != confirmPasswordField.text{
            self.createAlert(title: "Create Account", message: "Passwords do not match")
            
            return
        }
        
       
        let newPassword = passwordField.text!
        
        
        
        print(newPassword)
        
        let parameters: Parameters = ["user": "\(newPassword)"]
        
        Alamofire.request("https://adambibby.ca/user/me", method: .put, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: "adam", password: "test").responseJSON{ response in
            
            let code = Int((response.response?.statusCode)!)
            
            if code == 500{
                self.createAlert(title: "Create Account", message: "Failed")
                return
            }
            
            self.performSegue(withIdentifier: "finishReset", sender: nil)
            
            
        }
    }
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
}
