//
//  EditBookViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-22.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EditBookViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var seriesField: UITextField!
    @IBOutlet var summaryField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var genreField: UITextField!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var volumeField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var currentPageField: UITextField!
    @IBOutlet var storyArcField: UITextField!
    @IBOutlet var webField: UITextField!
    @IBOutlet var alternateSeriesField: UITextField!
    @IBOutlet var readingDirectionField: UITextField!
    @IBOutlet var tagsField: UITextField!
    @IBOutlet var typeField: UITextField!
    
    
    var bookId = ""
    var oldUrl: URL!
    
    var bookUrl: URL!
    
    
    
    
    //TODO: SEGUE BACK TO BOOKLISTVIEW, PASSING IN THE OLD URL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesField.delegate = self
        summaryField.delegate = self
        authorField.delegate = self
        genreField.delegate = self
        titleField.delegate = self
        volumeField.delegate = self
        numberField.delegate = self
        ratingField.delegate = self
        currentPageField.delegate = self
        storyArcField.delegate = self
        webField.delegate = self
        alternateSeriesField.delegate = self
        readingDirectionField.delegate = self
        tagsField.delegate = self
        typeField.delegate = self
        
        if bookId != ""{
            
            bookUrl = URL(string: "https://adambibby.ca/book/\(bookId)")
            
            print(bookUrl)
            print(oldUrl)
            
            //pull all the information
            
            getMetadata() { response in
                
                self.seriesField.text = response["series"].stringValue
                self.summaryField.text = response["summary"].stringValue
                self.authorField.text = response["author"].stringValue
                self.genreField.text = response["genre"].stringValue
                self.titleField.text = response["title"].stringValue
                self.volumeField.text = response["volume"].stringValue
                self.numberField.text = response["number"].stringValue
                self.ratingField.text = response["rating"].stringValue
                self.currentPageField.text = response["current_page"].stringValue
                self.storyArcField.text = response["story_arc"].stringValue
                self.webField.text = response["web"].stringValue
                self.alternateSeriesField.text = response["alternate_series"].stringValue
                self.readingDirectionField.text = response["reading_direction"].stringValue
                self.tagsField.text = response["tags"].stringValue
                self.typeField.text = response["type"].stringValue
                
            }

            
            
        }
    
        
    
        // Do any additional setup after loading the view.
    }
    func getMetadata(completion: @escaping (JSON) -> ()){
        
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(bookUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers ).validate().responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                
                
                completion(json)
                
                
                break
                
                
            case .failure(let error):
                print(error)
                
            
                break
            }
            
        }
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        seriesField.resignFirstResponder()
        summaryField.resignFirstResponder()
        authorField.resignFirstResponder()
        genreField.resignFirstResponder()
        titleField.resignFirstResponder()
        volumeField.resignFirstResponder()
        numberField.resignFirstResponder()
        ratingField.resignFirstResponder()
        currentPageField.resignFirstResponder()
        storyArcField.resignFirstResponder()
        webField.resignFirstResponder()
        alternateSeriesField.resignFirstResponder()
        readingDirectionField.resignFirstResponder()
        tagsField.resignFirstResponder()
        typeField.resignFirstResponder()

        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToBooks"{
            
            let bookListView = segue.destination as! BookListViewController
            
            
            
            
            bookListView.bookUrl = oldUrl
            
        }
        
    }

    
    @IBAction func saveChanges(_ sender: UIButton) {
        
        
        let series = seriesField.text!
        let summary = summaryField.text!
        let author = authorField.text!
        let genre = genreField.text!
        let title = titleField.text!
        let volume = Int(volumeField.text!)
        let number = Int(numberField.text!)
        let rating = Int(ratingField.text!)
        let currentPage = Int(currentPageField.text!)
        let storyArc = storyArcField.text!
        let web = webField.text!
        let alternateSeries = alternateSeriesField.text!
        let readingDirection = readingDirectionField.text!
        let tags = tagsField.text!
        let type = typeField.text!
        
        
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let parameters: Parameters =
            ["series": "\(series)",
             "summary": "\(summary)",
             "author": "\(author)",
             "genre": "\(genre)",
             "title": "\(title)",
             "volume": volume!,
             "number": number!,
             "rating": rating!,
             "current_page": currentPage!,
             "story_arc": "\(storyArc)",
             "web": "\(web)",
             "alternate_series": "\(alternateSeries)",
             "reading_direction": "\(readingDirection)",
             "tags": "\(tags)",
             "type": "\(type)"
        ]
        
        
        print(parameters)
        Alamofire.request(bookUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: user, password: password).responseJSON{ response in
            
            print("does this even happen")
            print(response.request!)
            print(response)
            
            self.performSegue(withIdentifier: "backToBooks", sender: nil)
            
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
