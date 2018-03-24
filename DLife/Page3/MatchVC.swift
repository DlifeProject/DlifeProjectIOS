//
//  MatchVC.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/21.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class MatchVC: UIViewController {
    
    
    @IBOutlet weak var myPhoto: UIImageView!
    
    @IBOutlet weak var friendPhoto: UIImageView!
    
    @IBOutlet weak var friendTypeLabel: UILabel!
    
    @IBOutlet weak var myTypeLabel: UILabel!
    
    var myCategoryPhotoSKList=[MyCategoryPhotoSK]()
    var photoDatas = [Data]()
    var photoChangeInt = -1
    
    
    let parameters:[String:Any]=["action":"MyShareAbleCateList","account":"irv278@gmail.com","password":"Regan"]
    
//    let requestShareParameters:[String:Any]=["action":"toRequestShare","account":"irv278@gmail.com","password":"Regan","shareCategory":"\(myTypeLabel.text)"]
//
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTypeLabel.text="請選擇種類"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        Common.shared.text(api: Common.FRIEND_URL, jsonDictionary: parameters, jsonRow: 0) { (error, result) in
            if let error=error{
                NSLog("sendTextMessage fail: \(error)")
                
                return
            }
            // success
            let myDiary = result! as [[String: Any]]
            print("myDiary:\n \(myDiary)")
            for i in 0...(myDiary.count - 1) {
                let getmyDiary=myDiary[i]
                let diaryPhotoSK=getmyDiary["diaryPhotoSK"]as!Int
                let categoryType=getmyDiary["categoryType"]as!String
                let myCategoryPhotoSK=MyCategoryPhotoSK(category: categoryType, photoSK: diaryPhotoSK)
                self.myCategoryPhotoSKList.append(myCategoryPhotoSK)
                print("myCategoryPhotoSK:\(myCategoryPhotoSK)")
            }
            print(self.myCategoryPhotoSKList)

            for i in 0..<self.myCategoryPhotoSKList.count{
                
                let photoParameters:[String:Any]=["action":"getImage","account":"irv278@gmail.com","password":"Regan","imageSize":UIScreen.main.bounds.size.width,"id":self.myCategoryPhotoSKList[i].photoSK]
                Common.shared.downloadPhotoMessage(finalFileURLString: Common.BASEURL + Common.PHOTO_URL, parameters: photoParameters, doneHandler: { (error, data) in
                    if let error=error{
                        NSLog("downloadPhoto fail: \(error)")
                        
                        return
                    }
                    guard let data=data else{
                        return
                    }
                    
                    self.photoDatas.append(data)
                    
                    NSLog("photoDatas\(self.photoDatas)")
                })
            }
           
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
    
    //MARK: buttons
    @IBAction func backBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "backToFriend", sender: nil)
    }
    
    @IBAction func leftBtn(_ sender: Any) {
        myTypeLabel.text="請選擇種類 "
        myPhoto.image=#imageLiteral(resourceName: "ExPhoto")
        if photoDatas.count != 0{
        changeMyType(string: "previous")
        }
        
    }
    
    @IBAction func rightBtn(_ sender: Any) {
        myTypeLabel.text="請選擇種類 "
        myPhoto.image=#imageLiteral(resourceName: "ExPhoto")
        if photoDatas.count != 0{
        changeMyType(string: "next")
        }
    }
    @IBAction func sentBtn(_ sender: Any) {
        
        if myTypeLabel.text=="請選擇種類"{
            return
        }else{
            guard let myTypetext=myTypeLabel.text else{
                return
            }
            let requestShareParameters:[String:Any]=["action":"toRequestShare","account":"irv278@gmail.com","password":"Regan","shareCategory":"\(myTypeLabel.text)"]
            
            
            
        }
    }
    
    
    // MARK: 按鈕演算法
    func changeMyType(string:String)  {
        // init share msg
        if photoChangeInt == -1{
            if(myCategoryPhotoSKList.count > 0){
                photoChangeInt = 0
            }else{
               return
            }
        }else{
            if string=="previous"{
                photoChangeInt = photoChangeInt - 1
                if photoChangeInt < 0 {
                    photoChangeInt = myCategoryPhotoSKList.count - 1
                }
            }else{
                photoChangeInt = photoChangeInt + 1
                if photoChangeInt >= myCategoryPhotoSKList.count {
                    photoChangeInt = 0;
                }
            }
        }
        
        if photoChangeInt >= 0{
            myTypeLabel.text=myCategoryPhotoSKList[photoChangeInt].category
            myPhoto.image=UIImage(data:photoDatas[photoChangeInt])
           
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
         myCategoryPhotoSKList=[MyCategoryPhotoSK]()
         photoDatas = [Data]()
         photoChangeInt = -1
    }
}
    
struct MyCategoryPhotoSK {
    
    var category :String
    var  photoSK :Int
}
