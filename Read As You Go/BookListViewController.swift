//
//  BookListViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-25.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

var bookList = [Book]()

class BookListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var createListButton: UIBarButtonItem!
    
    var bookUrl: URL!
    var cameFromSearch = false
    var listName = ""
    var query: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(bookUrl)
        
        bookList.removeAll()
        
        if cameFromSearch == false{
            self.createListButton.title = ""
            self.createListButton.isEnabled = false
            query = ""
        }
        else{
            self.createListButton.title = "Create List"
            self.createListButton.isEnabled = true
        }
        
        getBooks() { response in
            
            
            let tempList = response["books"].arrayValue
            
            if(tempList.count <= 0){
                self.createAlert(title: "Error Retreiving Books", message: "No books were found")
            }
            else{
                for i in 0...tempList.count-1{
                    let name = tempList[i]["title"].stringValue
                    let chapterNumber = tempList[i]["number"].intValue
                    let volumeNumber = tempList[i]["volume"].intValue
                    let currentPage = tempList[i]["current_page"].intValue
                    let cover = tempList[i]["pages"][0]["url"].stringValue
                    var pages = [URL]()
                    let id = tempList[i]["id"].stringValue
                
                
                    for j in 0...tempList[i]["pages"].count-1{
                        pages.append(URL(string: tempList[i]["pages"][j]["url"].stringValue)!)
                    }
                
                
                    let temp = Book(name: name, chapterNumber: chapterNumber, volumeNumber: volumeNumber, currentPage: currentPage, cover: cover, id: id)
                
                    temp.pages = pages
                
                
                    bookList.append(temp)
                }
                
        
            }
            
            
            self.collectionView.reloadData()
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 4;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath as IndexPath) as! BookListCollectionViewCell
        
        
        
        cell.image.image = nil
        cell.details.text = ""
        
        cell.editButton.layer.setValue(indexPath.row, forKey: "index")
        cell.editButton.addTarget(self, action: #selector(BookListViewController.editBook(_:)), for: UIControlEvents.touchUpInside)
        
        
        let strUrl = bookList[indexPath.row].cover
        
        if bookList[indexPath.row].volumeNumber != 0 {
            if bookList[indexPath.row].chapterNumber != 0{
                cell.details.text = "V\(bookList[indexPath.row].volumeNumber) #\(bookList[indexPath.row].chapterNumber) \(bookList[indexPath.row].name)"
            }
            else{
                cell.details.text = "V\(bookList[indexPath.row].volumeNumber) \(bookList[indexPath.row].name)"
                
            }
        }
        else{
            if bookList[indexPath.row].chapterNumber != 0{
                cell.details.text = "#\(bookList[indexPath.row].chapterNumber) \(bookList[indexPath.row].name)"
            }
            else{
                cell.details.text = "\(bookList[indexPath.row].name)"

            }
        }
        
        
        let imageUrl = URL(string: strUrl)
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(imageUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers).responseImage { response in
            guard let image = response.result.value else{
                
                print("failed to get image")
                return
            }
            print("Got the image")
            
            cell.image.image = image
        }

        
        
       
        
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "switchToReader", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "switchToReader"{
            
            let reader = segue.destination as! ViewController
            
            let ip = sender as! IndexPath
            
            
            print(bookList[ip.row].pages.count)
            reader.currentBook = bookList[ip.row]
            
        }
        //prepare the segue by sending the book ID to the window
        //set the id of the selected book
        //set the url to the old bookUrl
        
        if segue.identifier == "editView"{
            
            let view = segue.destination as! EditBookViewController
            
            let ip = sender as! Int
            
            view.bookId = bookList[ip].id
            view.oldUrl = bookUrl
        }
    }

    
    func getBooks(completion: @escaping (JSON) -> ()){
        
        
        
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
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createTextAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField{ (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.listName = alert.textFields![0].text!
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func createList(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Create List", message: "Please enter the list name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField{ (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.listName = alert.textFields![0].text!
            if(self.listName != ""){
                
                //post request with the list name
                print(self.listName)
                print(self.query)
                
                let parameters: Parameters = ["name": "\(self.listName)",
                    "query": "\(self.query)"]
                
                Alamofire.request("https://adambibby.ca/list", method: .post, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: user, password: password).responseJSON{ response in
                    
                    let code = Int((response.response?.statusCode)!)
                    
                    if(code == 500){
                        self.createAlert(title: "Error", message: "Error creating list")
                    }
                  
                    
                    
                }

                
            }
            else{
                self.createAlert(title: "Create List", message: "Please enter a valid name")
            }
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }

    @IBAction func editBook(_ sender: UIButton) {
        
        let i = (sender as AnyObject).layer.value(forKey: "index") as! Int
        
        
      
        
        performSegue(withIdentifier: "editView", sender: i)

    }
    
    
    
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "switchToReader", sender: indexPath)
    }*/


}
