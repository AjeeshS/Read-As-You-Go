//
//  Series.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-18.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit

class Series {
    var name: String
    var url: URL
    var count: Int
    var unread: Int
    var image: String
    
    init(name: String, url: URL, count: Int, unread: Int, image: String){
        self.name = name
        self.url = url
        self.count = count
        self.unread = unread
        self.image = image
    }
}
