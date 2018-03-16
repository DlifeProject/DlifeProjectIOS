//
//  DiaryTableViewCell.swift
//  D.Life
//
//  Created by Allen on 2018/3/6.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var starttimeLabel: UILabel!
    
    @IBOutlet weak var endtimeLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var tagImageView: UIImageView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
