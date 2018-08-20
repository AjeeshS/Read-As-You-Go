//
//  SeriesTableViewCell.swift
//  Read As You Go
//
//  Created by Ajeesh Srijeyarajah on 2017-10-18.
//  Copyright © 2017 Ajeesh Srijeyarajah. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var seriesNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
