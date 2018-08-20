//
//  Book.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-18.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit


class Book {
    
    var name: String
    var chapterNumber: Int
    var volumeNumber: Int
    var currentPage: Int
    var cover: String
    var pages = [URL]()
    var id: String
    
    init(name: String, chapterNumber: Int, volumeNumber: Int, currentPage: Int, cover: String, id: String){
        
        self.name = name
        self.chapterNumber = chapterNumber
        self.volumeNumber = volumeNumber
        self.currentPage = currentPage
        self.cover = cover
        self.id = id
        
    }
}
