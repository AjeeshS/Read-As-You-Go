//
//  SeriesViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-23.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SideMenu

var seriesList = [Series]()


class SeriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        seriesList.removeAll()
        
        getSeries() { response in
            
            for i in 0...response.count-1{
                
                let name = response[i]["name"].stringValue
                let url = URL(string: response[i]["url"].stringValue)
                let count = response[i]["count"].intValue
                let unread = response[i]["unread"].intValue
                
                let imageUrl = response[i]["image"].stringValue
                
                let temp = Series(name: name, url: url!, count: count, unread: unread, image: imageUrl)
                
                
                seriesList.append(temp)
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
        
        return seriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath as IndexPath) as! SeriesCollectionViewCell
        
        
        cell.image.image = nil
        cell.details.text = ""
        
        
        cell.details.text = seriesList[indexPath.row].name
        
        
        let strUrl = seriesList[indexPath.row].image
        
        
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
        performSegue(withIdentifier: "switchToBooks", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "switchToBooks"{
            
            let bookListView = segue.destination as! BookListViewController
            
            let ip = sender as! IndexPath
            
            
            
            bookListView.bookUrl = seriesList[ip.row].url
            
        }
        
    }
    
    
    
    
    func getSeries(completion: @escaping (JSON) -> ()){
        
        
        
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
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
