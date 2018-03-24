//
//  FriendshipTableViewCell.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/12.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class FriendshipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myType: UILabel!
    
    
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendType: UILabel!
    var ss :String?
    var friendship:Friendship?{
        didSet{
            let mytype=friendship?.myCategory as! String
            let myStartType=mytype.index(mytype.startIndex, offsetBy: 0)
            let myEndType=mytype.index(myStartType,offsetBy:1)
            let mytypeSubString=mytype[myStartType..<myEndType]
            
            myType.text=String(mytypeSubString)
            
            friendName.text=friendship?.myFriendName
            
            let histype=friendship?.myFriendCategory as! String
            let hisStartType=histype.index(histype.startIndex, offsetBy: 0)
            let hisEndType=histype.index(hisStartType, offsetBy: 1)
            let histypeSubString=histype[hisStartType..<hisEndType]
            friendType.text=String(histypeSubString)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
