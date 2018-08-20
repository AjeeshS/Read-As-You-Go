//
//  ViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-05.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class ViewController: UIViewController {
    
    
    

    //UI Components
    
    @IBOutlet weak var resultTextField: UITextView!
    @IBOutlet weak var pageImage: UIImageView!
    
    @IBOutlet weak var pageSlider: UISlider!

    @IBOutlet var pageLabel: UILabel!
    
    
    
    //Basic struct to represent the book currently being read
    
    
    var currentBook = Book(name: "", chapterNumber: 0, volumeNumber: 0, currentPage: 0, cover: "", id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        
        
        
        pageLabel.text = "\(currentBook.currentPage)/\(currentBook.pages.count-1)"
        pageSlider.maximumValue = Float(currentBook.pages.count-1)
        pageSlider.minimumValue = 0
        pageSlider.reloadInputViews()
        
        loadPage(imageUrl: currentBook.pages[currentBook.currentPage])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    //Action for when the the user swipes the screen left or right
    //TODO: Switch the outcomes for the directions (swipe left advances the page, right goes back)
    
    func swipeAction(swipe:UISwipeGestureRecognizer){
        switch swipe.direction.rawValue{
        case 1:
            currentBook.currentPage = currentBook.currentPage + 1
            if(currentBook.currentPage > currentBook.pages.count-1){
                currentBook.currentPage = currentBook.pages.count-1
                return
            }
            pageLabel.text = "\(currentBook.currentPage)/\(currentBook.pages.count-1)"
            loadPage(imageUrl: currentBook.pages[currentBook.currentPage])
            updateCurrentPage()
        case 2:
            if currentBook.currentPage > 0 {
                currentBook.currentPage = currentBook.currentPage - 1
                pageLabel.text = "\(currentBook.currentPage)/\(currentBook.pages.count-1)"
                loadPage(imageUrl: currentBook.pages[currentBook.currentPage])
                updateCurrentPage()
            }
        default:
            break
        }
    }
    
    //Action for when the user selects a page with the slider
    
    @IBAction func switchPageSlider(_ sender: UISlider) {
        
        let pageNum = Int(sender.value)
        
        pageLabel.text = "\(pageNum)/\(currentBook.pages.count-1)"
        currentBook.currentPage = pageNum
        loadPage(imageUrl: currentBook.pages[currentBook.currentPage])
        updateCurrentPage()
    }
    
    //function to load a page from the server based on the given page number
    func loadPage(imageUrl: URL!){
        
        
        
                
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(imageUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers).responseImage { response in
            guard let image = response.result.value else{
                return
            }
            
            self.pageImage.image = image
            
        }
       
        
        
    }
    
    func updateCurrentPage(){
        
       
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let parameters: Parameters = ["current_page": currentBook.currentPage]
        
        Alamofire.request("https://adambibby.ca/book/\(currentBook.id)/", method: .put, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: user, password: password).responseJSON{ response in
            
            print("does this even happen")
            print(response.request!)
            print(response)
            
            
        }
    }
    
    
    
    /*func getBook() {
        
        guard let url = URL(string: "http://adambibby.ca:8080/book/443f132a-7f92-4c7d-8ecf-0985871e0425/page/1") else {return}
        
        var output = ""
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            
            if let data = data{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                    
                    print(json)
                    /*let test = json["books"] as! NSArray
                    
                    let length = test.count
                    
                    var str = ""
                    
                    for i in 0..<length {
                        let test2 = test[i] as! [String:AnyObject]
                        
                        str = str + "Series: \(test2["series"]!) \nVolume: \(test2["volume"]!)\n\n"
                        print(str)
                        
                        DispatchQueue.global(qos: .userInitiated).async{
                         
                         DispatchQueue.main.async{
                         print(str)
                         
                         
                         }
                         
                         }
                    }*/
                    
                    
                   
     
     
                } catch{
                    print(error)
                }
            }
        }.resume()
        
    }*/
    
    
    
    
    

}

