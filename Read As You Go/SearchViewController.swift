//
//  SearchViewController.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-14.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var searchButton: UIButton!

    @IBOutlet var basicSearchField: UITextField!
    @IBOutlet var backButton: UIButton!
    
    
    @IBOutlet var columnField: UITextField!
    
    @IBOutlet var operatorField: UITextField!
    
    
    @IBOutlet var advSearchButton: UIButton!
    
    @IBOutlet var valueField: UITextField!
    
    
    @IBOutlet var negationField: UITextField!
    
    @IBOutlet var addButton: UIButton!
    var columns = ["Series", "Summary", "Story_Arc", "Author", "Genre", "Tags", "Title", "Community_Rating",
                "Number"]
    
    var operators = ["Equals", "Greater Than","Less Than", "Starts With", "Ends With", "Contains"]
    
    var negations = ["Is", "Is Not"]
    
    var queryList = [String]()
    
    var listName = ""
    var listId = ""
    
    let picker = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFields()
        
        queryList.removeAll()
        
        picker.delegate = self
        picker.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        picker3.delegate = self
        picker3.dataSource = self
        
        valueField.delegate = self
        
        
        columnField.inputView = picker
        operatorField.inputView = picker2
        negationField.inputView = picker3

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView == picker){
            return columns.count

        }
        else if(pickerView == picker2){
            return operators.count
        }
        else if(pickerView == picker3){
            return negations.count
            
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if(pickerView == picker){
            return columns[row]
            
        }
        else if(pickerView == picker2){
            return operators[row]
        }
        else if(pickerView == picker3){
            return negations[row]
        }
        
        return " "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        columnField.text = columns[row]
        self.view.endEditing(true)
        
        if(pickerView == picker){
            columnField.text = columns[row]
            self.view.endEditing(true)
            
        }
        else if(pickerView == picker2){
            operatorField.text = operators[row]
            self.view.endEditing(true)
        }
        else if(pickerView == picker3){
            negationField.text = negations[row]
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueField.resignFirstResponder()
        return true
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //get text
        
        var query = basicSearchField.text!
        
        if(listName == ""){
            performSegue(withIdentifier: "searchBooks", sender: query)
        }
        else{
            //name alert
            let alert = UIAlertController(title: "Create List", message: "Please enter the list name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField{ (textField) in
                textField.text = self.listName
            }
            
            alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                
                self.listName = alert.textFields![0].text!
                if(self.listName != ""){
                    
                    //post request with the list name
                    print(self.listName)
                    print(query)
                    
                    
                    query = query.replacingOccurrences(of: " ", with: "%20")
                    
                    
                    let parameters: Parameters = ["name": "\(self.listName)",
                        "query": "all=.~(\(query))"]
                    
                    Alamofire.request("https://adambibby.ca/list/\(self.listId)", method: .put, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: user, password: password).responseJSON{ response in
                        
                        let code = Int((response.response?.statusCode)!)
                        
                        if(code == 500){
                            self.createAlert(title: "Error", message: "Error creating list")
                        }
                        
                        
                        self.performSegue(withIdentifier: "backToListBrowse", sender: nil)
                        
                    }
                    
                    
                }
                else{
                    self.createAlert(title: "Create List", message: "Please enter a valid name")
                }
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchBooks"{
            
            let bookListView = segue.destination as! BookListViewController
            
            var query = sender as! String
            
            query = query.replacingOccurrences(of: " ", with: "%20")
            
            let urlString = "https://adambibby.ca/book?all=.~(\(query))"
            
            bookListView.bookUrl = URL(string: urlString)
            bookListView.cameFromSearch = true
            bookListView.query = "all=.~(\(query))"
            
        }
        
        else if segue.identifier == "advancedSearch"{
            
            let bookListView = segue.destination as! BookListViewController
            
            var query = sender as! String
            
            let urlString = "https://adambibby.ca/book?" + query
            
            bookListView.bookUrl = URL(string: urlString)
            bookListView.cameFromSearch = true
            bookListView.query = query
        }
        
    }
    
    

    
    @IBAction func addQuery(_ sender: UIButton) {
        
        var baseQuery = ""
        
        if (columnField.text != "" && operatorField.text != "" && valueField.text != "" && negationField.text != ""){
            baseQuery = baseQuery + columnField.text! + "="
            
            
            if(negationField.text == "Is"){
                
                baseQuery = baseQuery + "."
                
            }
            else if(negationField.text == "Is Not"){
                
                baseQuery = baseQuery + "!"
            }
            
            
            if(operatorField.text == "Equals"){
                
                baseQuery = baseQuery + "@"
                
            }
            
            else if(operatorField.text == "Greater Than"){
                
                baseQuery = baseQuery + "g"
                
            }
            else if(operatorField.text == "Less Than"){
                
                baseQuery = baseQuery + "l"
                
            }
            else if(operatorField.text == "Starts With"){
                
                baseQuery = baseQuery + "'"

                
            }
            else if(operatorField.text == "Ends With"){
                
                baseQuery = baseQuery + "$"

                
            }
            else if(operatorField.text == "Contains"){
                baseQuery = baseQuery + "~"

            }
            
            
            baseQuery = baseQuery + "(" + valueField.text!.replacingOccurrences(of: " ", with: "%20") + ")"
            
            
            
            baseQuery = baseQuery.lowercased()
            
            queryList.append(baseQuery)
            
            resetFields()
        }
        else{
            //show error alert
        }
    }
    
    
    @IBAction func advSearchClicked(_ sender: UIButton) {
        
        var fullQuery = ""
        
        if(queryList.count <= 0){
            //error
        }
        else if (queryList.count == 1){
            fullQuery = fullQuery + queryList[0]
        }
        else{
            for i in 0 ... queryList.count-1 {
                fullQuery = fullQuery + queryList[i]
                
                if (i != queryList.count-1){
                    fullQuery = fullQuery + "&"
                }
            }
        }
        
        if(listName == ""){
            
            performSegue(withIdentifier: "advancedSearch", sender: fullQuery)

        }
        else{
            //name alert
            let alert = UIAlertController(title: "Create List", message: "Please enter the list name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField{ (textField) in
                textField.text = self.listName
            }
            
            alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                
                self.listName = alert.textFields![0].text!
                if(self.listName != ""){
                    
                    //post request with the list name
                    print(self.listName)
                    print(fullQuery)
                    
                    let parameters: Parameters = ["name": "\(self.listName)",
                        "query": "\(fullQuery)"]
                    
                    Alamofire.request("https://adambibby.ca/list/\(self.listId)", method: .put, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: user, password: password).responseJSON{ response in
                        
                        let code = Int((response.response?.statusCode)!)
                        
                        if(code == 500){
                            self.createAlert(title: "Error", message: "Error creating list")
                        }
                        
                        self.performSegue(withIdentifier: "backToListBrowse", sender: nil)
                        
                        
                        
                    }
                    
                    
                }
                else{
                    self.createAlert(title: "Create List", message: "Please enter a valid name")
                }
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetFields(){
        
        negationField.text = "Is"
        columnField.text = "Series"
        operatorField.text = "Contains"
        valueField.text = ""
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
