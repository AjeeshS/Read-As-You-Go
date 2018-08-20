//
//  ListBrowseViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-14.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


var listMembers = [ListMember]()
class ListBrowseViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("does this even load")
        
        //self.automaticallyAdjustsScrollViewInsets = false
        
        listMembers.removeAll()
        
        getLists() { response in
            
            /*let list = response["lists"].arrayValue
            
            if list.count <= 0{
                self.createAlert(title: "Error", message: "No lists were found")
                return
            }*/
            
            print("Enters completion")
            for i in 0...response["lists"].count-1{
                
                
                print("Got the values")
                
                let id = response["lists"][i]["id"].stringValue
                let name = response["lists"][i]["name"].stringValue
                let query = response["lists"][i]["query"].stringValue
                let count = response["lists"][i]["count"].intValue
                let editUrl = URL(string: response["lists"][i]["url"].stringValue)
                let bookUrl = URL(string: response["lists"][i]["book_url"].stringValue)
                let thumbUrl = response["lists"][i]["thumb_url"].stringValue
                
                let temp = ListMember(id: id, name: name, query: query, count: count, editUrl: editUrl!, bookUrl: bookUrl!, thumbUrl: thumbUrl)
                
                
                listMembers.append(temp)
            }
            
            
            
            self.collectionView.reloadData()
            
        }

        // Do any additional setup after loading the view.
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
        
        return listMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseListCell", for: indexPath as IndexPath) as! ListBrowseCollectionViewCell
        
        print("Cell got retrieved")
        
        cell.image.image = nil
        cell.title.text = ""
        
        
        cell.title.text = listMembers[indexPath.row].name
        
        cell.editListBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.editListBtn.addTarget(self, action: #selector(ListBrowseViewController.editList(_:)), for: UIControlEvents.touchUpInside)

        
        cell.deleteListBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteListBtn.addTarget(self, action: #selector(ListBrowseViewController.deleteList(_:)), for: UIControlEvents.touchUpInside)
        
        let strUrl = listMembers[indexPath.row].thumbUrl
        
        
        let imageUrl = URL(string: strUrl)
        
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(imageUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers).responseImage { response in
            guard let image = response.result.value else{
                
                print("failed to get image")
                return
            }
            print("Got the thumb")
            
            cell.image.image = image
        }
        
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "booksInList", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksInList"{
            
            let bookListView = segue.destination as! BookListViewController
            
            let ip = sender as! IndexPath
            
            
            
            bookListView.bookUrl = listMembers[ip.row].bookUrl
            
        }
        
        if segue.identifier == "editList"{
            
            let view = segue.destination as! SearchViewController
            
            let i = sender as! Int
            
            view.listName = listMembers[i].name
            view.listId = listMembers[i].id
            
            
            
        }
        
    }

    
    func getLists(completion: @escaping (JSON) -> ()){
        
        
        print("get lists is called")
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request("https://adambibby.ca/list", method: .get, parameters: nil, encoding: URLEncoding.default, headers:headers ).validate().responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                
                
                print("Here?")
                completion(json)
                
                
                break
                
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async{
                    self.createAlert(title: "Login", message: "Authentication Failed")
                }
                self.performSegue(withIdentifier: "backToLogin", sender: "Authentication Failed")
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


    @IBAction func deleteList(_ sender: Any) {
        
        let i = (sender as AnyObject).layer.value(forKey: "index") as! Int
        
        
        
        Alamofire.request("https://adambibby.ca/list/\(listMembers[i].id)", method: .delete, encoding: JSONEncoding.default).authenticate(user: "adam", password: "test").responseJSON{ response in
            
            let code = Int((response.response?.statusCode)!)
            
            print(code)
            
            listMembers.remove(at: i)
            
            self.collectionView.reloadData()
            
            
        }

    }

    @IBAction func editList(_ sender: UIButton) {
        
        let i = (sender as AnyObject).layer.value(forKey: "index") as! Int
        
        self.performSegue(withIdentifier: "editList", sender: i)
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
