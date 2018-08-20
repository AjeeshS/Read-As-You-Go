//
//  ListMember.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-11-14.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit

class ListMember{
    
    var id: String
    var name: String
    var query: String
    var count: Int
    var editUrl: URL
    var bookUrl: URL
    var thumbUrl: String
    
    init(id: String, name: String, query: String, count: Int, editUrl: URL, bookUrl: URL, thumbUrl: String){
        self.id = id
        self.name = name
        self.query = query
        self.count = count
        self.editUrl = editUrl
        self.bookUrl = bookUrl
        self.thumbUrl = thumbUrl
        
    }
    
    
}
