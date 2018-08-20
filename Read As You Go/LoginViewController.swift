//
//  LoginViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-01.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var user = ""
var password = ""

class LoginViewController: UIViewController {

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        
        if userNameField.text == "" || passwordField.text == ""{
            createAlert(title: "Login Failed", message: "Username or Password is invalid")
            
            return
        }
        
        user = userNameField.text!
        password = passwordField.text!
        
        authenticate() { response in
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        
        
        
    }
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func authenticate(completion: @escaping (JSON) -> ()){
        
        
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request("https://adambibby.ca/series", method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers ).validate().responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                
                
                completion(json)
                
                
                break
                
                
            case .failure(let error):
                print(error)
                
               
                self.createAlert(title: "Login", message: "Authentication Failed")
                break
            }
            
        }
        
        
        
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
