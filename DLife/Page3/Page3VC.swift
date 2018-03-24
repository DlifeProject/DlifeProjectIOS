//
//  Page3VC.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class Page3VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var firstFriendName: UILabel!
    
    @IBOutlet weak var firstMyCategory: UILabel!
    
    @IBOutlet weak var firstFriendCategory: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var NewImage: UIImageView!
    
    
    
    static var firstData:Friendship?
    
    
    var friendships = Friendship.all
    let friendParameters: Dictionary<String, Any> = ["action":"getFriendList","account":"irv278@gmail.com","password":"Regan"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendships.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "FriendshipCell", for: indexPath) as! FriendshipTableViewCell
        cell.selectionStyle = .none
        let friendship=friendships[indexPath.row+1]
        cell.friendship=friendship
        return cell
        
    }
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        tableView.separatorStyle = .none
        
        
        Common.shared.text(api: Common.FRIEND_URL, jsonDictionary: friendParameters,jsonRow:0) { (error, result) in
            if let error = error {
                NSLog("sendTextMessage fail: \(error)")
                
                return
            }
            // success
            let allFriendship = result! as [[String: Any]]
            print("friendship:\n \(allFriendship)")
            for i in 0...(allFriendship.count - 1) {
                let getFriendship=allFriendship[i]
                let myCategory=getFriendship["myCategory"]as!String
                let myCategorySK=getFriendship["myCategorySK"]as!Int
                let myFriendCategory=getFriendship["myFriendCategory"]as!String
                let myFriendCategorySK=getFriendship["myFriendCategorySK"]as! Int
                let myFriendName=getFriendship["myFriendName"]as!String
                let myFriendSK=getFriendship["myFriendSK"]as!Int
                let isShareable=getFriendship["isShareable"]as! Int
                let postDay=getFriendship["postDay"]as!String
                let finalFriendship=Friendship(myCategory: myCategory, myCategorySK: myCategorySK, myFriendCategory: myFriendCategory, myFriendCategorySK: myFriendCategorySK, myFriendName: myFriendName, myFriendSK: myFriendSK, isShareable: isShareable, postDay: postDay)
                Friendship.add(friendship: finalFriendship)
                
            }
            
            self.friendships=Friendship.all
            self.tableView.reloadData()
            
            
           // first[0] 第一筆的資訊
            if self.friendships.count != 0 {
                self.NewImage.isHidden=false
                self.firstMyCategory.isHidden=false
             self.firstFriendCategory.isHidden=false
                self.firstFriendName.text=self.friendships[0].myFriendName
            let mytype=self.friendships[0].myCategory as! String
            
                
                
            let myStartType=mytype.index(mytype.startIndex, offsetBy: 0)
            let myEndType=mytype.index(myStartType,offsetBy:1)
            let mytypeSubString=mytype[myStartType..<myEndType]
            self.firstMyCategory.text=String(mytypeSubString)
           
            let histype=self.friendships[0].myFriendCategory as! String
            let hisStartType=histype.index(histype.startIndex, offsetBy: 0)
            let hisEndType=histype.index(hisStartType, offsetBy: 1)
            let histypeSubString=histype[hisStartType..<hisEndType]
            self.firstFriendCategory.text=String(histypeSubString)
            
            Page3VC.firstData=self.friendships[0]
            NSLog("firstData:\n"+"\(Page3VC.firstData!)")
            }else{
                self.firstFriendName.text="趕快加入新朋友吧！"
               
               
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Friendship.all = [Friendship]()
        
        
    }
    
    @IBAction func darkButton(_ sender: Any) {
        if friendships.count != 0 {
        performSegue(withIdentifier: "segueFirstFriendDiary", sender: nil)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    @IBAction func addFriendBtn(_ sender: Any) {
        performSegue(withIdentifier: "addFriend", sender: nil)
//        performSegue(withIdentifier: "alreadyMatch", sender: nil)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDiary" {
            // 得知使用者點選了哪一個indexPath
            if let indexPath = tableView.indexPathForSelectedRow {
                //得知使用者點了哪一個Emoji
                let friendshipValue = friendships[indexPath.row+1]
                //準備傳給下一頁
                let nextVC = segue.destination as! FriendDiaryViewController
                nextVC.friendshipValue = friendshipValue
            }
        }
        
        //      好友清單第一筆
        if segue.identifier == "segueFirstFriendDiary" {
            let friendshipFirstValue=friendships[0]
            //準備傳給下一頁
            let nextVC = segue.destination as! FriendDiaryViewController
            nextVC.friendshipFirstValue = friendshipFirstValue
        }

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
