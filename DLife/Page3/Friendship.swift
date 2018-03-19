//
//  Friendship.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/18.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation
class Friendship {
    
    static var all = [Friendship]()
    
    var myCategory: String
    var myCategorySK: Int
    var myFriendCategory:String
    var myFriendCategorySK: Int
    var myFriendName: String
    var myFriendSK: Int
    var isShareable:Int=1
    var postDay = "0000-00-00"

    
    //自訂建構子
    init(myCategory: String,myCategorySK: Int,myFriendCategory:String,myFriendCategorySK: Int,myFriendName: String,myFriendSK: Int,isShareable:Int,postDay:String) {
        self.myCategory = myCategory
        self.myCategorySK = myCategorySK
        self.myFriendCategory=myFriendCategory
        self.myFriendCategorySK=myFriendCategorySK
        self.myFriendName=myFriendName
        self.myFriendSK=myFriendSK
        self.isShareable=isShareable
        self.postDay=postDay
}
    
    static func add(friendship: Friendship) {
        all.append(friendship)
    }
}
