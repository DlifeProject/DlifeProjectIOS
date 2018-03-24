//
//  Page1VC.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import CoreLocation
class Page1VC: UIViewController,  UITableViewDelegate,UITableViewDataSource ,CLLocationManagerDelegate{
    var objects = [Any]()
    var dataManager:CoredataManger<DiaryTest>!
    var keydataManager:CoredataManger<Key>!
    var diarydataManager:CoredataManger<CreateDiary>!
    let locationManager = CLLocationManager()
    static var diaryselectedSegmentIndex = 0
    var address = Page1Diary.address
    var allDiary = [DiaryDetail]()
    var deleteOnlineindexPath:IndexPath?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var diaryUIView: UIView!
    var diaryCounts = 0
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    

    @IBAction func diaryStateChangedSegmentContril(_ sender: UISegmentedControl) {
        Page1VC.diaryselectedSegmentIndex =  sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 1{
            getDiaryOnline()
        }
        self.diaryTableView.reloadData()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
//        NotificationCenter.default.addObserver(self, selector: #selector(getGPSInBackground), name: NSNotification.Name("WillTerminate"), object: nil)
        
       locationManager.startUpdatingLocation()
        
        //For Background Mode.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
         dataManager = CoredataManger<DiaryTest>(momdFilename: "DiaryModel", entityName: "DiaryTest", sortKey: "creationDate")
        keydataManager = CoredataManger<Key>(momdFilename: "DiaryModel", entityName: "Key", sortKey: "key")
        diarydataManager = CoredataManger<CreateDiary>(momdFilename: "DiaryModel", entityName: "CreateDiary", sortKey: "startDate")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTableItem), name: NSNotification.Name(rawValue:"delete"), object: nil)
        // Do any additional setup after loading the view.
    }
   
    @objc func deleteTableItem(notification:NSNotification){
        guard let sk = notification.object as? String else {
            return
        }
        let object = diarydataManager.fetchObject(at: Int(sk)!)
        diarydataManager.delete(object: object!)
        diarydataManager.saveContext{ (success) in}
        diaryTableView.reloadData()
        NSLog("delete 第\(sk)筆diary")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - CLLocationManagerDelegate methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            NSLog("Fail to get coordinate")
            return
        }
        let place = "\(coordinate.longitude) + \(coordinate.latitude)"
        NSLog("place:\(place)")
        

        creatediary(coordinate)
    
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func creatediary(_ coordinate:CLLocationCoordinate2D){
        if dataManager.count != 0 {
            
            guard let preforwardkey = dataManager.fetchObject(at: dataManager.count - 1)?.forwardkey else{
                return
            }
            guard let prekey = dataManager.fetchObject(at: dataManager.count - 1)?.key else {
                return
            }
            if preforwardkey == "0" {
                NSLog("不用參照")
                guard let prelatitude = dataManager.fetchObject(at: dataManager.count - 1)?.latitude else{
                    return
                }
                guard let prelongitude = dataManager.fetchObject(at: dataManager.count - 1)?.longitude else{
                    return
                }
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                NSLog("dataManager.count = \(dataManager.count)")
                NSLog("preplace:\(prelongitude) + \(prelatitude)")
                let prelocation = CLLocation(latitude: Double(prelatitude)! , longitude: Double(prelongitude)!)
                let distance = location.distance(from:prelocation)
                NSLog("第\(dataManager.count)筆: \(coordinate.longitude),\(coordinate.latitude),distance : \(distance) M")
                if distance < 100.0{
                    NSLog("距離小於100M")
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = "\(prekey)"
                    NSLog("儲存第\(dataManager.count + 1)筆: key: \(String(describing: finalObject.key)), forwardkey: \(prekey) ")
                    self.dataManager.saveContext{ (success) in}
                    addDiaryCounts()
                    
                }else{
                    NSLog("距離大於100M")
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = "0"
                    NSLog("儲存第\(dataManager.count + 1)筆: key: \(String(describing: finalObject.key)), forwardkey: 0")
                    self.dataManager.saveContext{ (success) in}
                    
                }
            }else {
                NSLog("要參照第\(preforwardkey)")
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                guard let forwardkeylatitude = dataManager.fetchObject(at: Int(preforwardkey)!-1)?.latitude else{
                    return
                }
                guard let forwardkeylongitude = dataManager.fetchObject(at: Int(preforwardkey)!-1)?.longitude else{
                    return
                }
                NSLog("preplace:\(forwardkeylongitude) + \(forwardkeylatitude)")
                let forwardkeylocation = CLLocation(latitude: Double(forwardkeylatitude)! , longitude: Double(forwardkeylongitude)!)
                let distance = location.distance(from:forwardkeylocation)
                NSLog("第\(dataManager.count + 1)筆: \(coordinate.longitude),\(coordinate.latitude),distance : \(distance) M")
                
                if distance < 100.0{
                    NSLog("距離小於100M")
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = preforwardkey
                    self.dataManager.saveContext{ (success) in}
                    NSLog("儲存第\(dataManager.count + 1)筆: key: \(String(describing: finalObject.key)), forwardkey: \(preforwardkey) ")
                    addDiaryCounts()
                    
                }else{
                    NSLog("距離大於100M")
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = "0"
                    NSLog("儲存第\(dataManager.count)筆: key: \(String(describing: finalObject.key)), forwardkey: 0")
                    self.dataManager.saveContext{ (success) in}
                    
                    guard let  diraycounts = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
                        assertionFailure()
                        return
                    }
                    NSLog("select 從第\(Int(preforwardkey)! + 1)筆 到 第 \(diraycounts)筆")
                    calculate(from: Int(preforwardkey)!, to:Int(diraycounts)!-1 )
                    
                    
                }
                
            }
            
        } else{
            var finalObject = DiaryTest()
            finalObject = self.dataManager.createObject()
            finalObject.creationDate = Date()
            finalObject.longitude = "\(coordinate.longitude)"
            finalObject.latitude = "\(coordinate.latitude)"
            finalObject.key = "1"
            finalObject.forwardkey = "0"
            self.dataManager.saveContext{ (success) in}
            
            var finalkey = Key()
            finalkey = self.keydataManager.createObject()
            finalkey.key = "1"
            finalkey.createdsk = "1"
            self.keydataManager.saveContext{ (success) in}
            NSLog("第一筆:\(coordinate.longitude),\(coordinate.latitude),key:\(1),forwardkey:\(0)")
        }
        
    }
    //MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Page1VC.diaryselectedSegmentIndex == 0 {
            
            if diarydataManager.count == 0{
                diaryTableView.backgroundView = UIImageView(image: UIImage(named:"no_diary"))
                diaryTableView.backgroundView?.alpha = 0
            }
        
            return diarydataManager.count
            
        } else{
            
            if allDiary.count == 0{
                diaryTableView.backgroundView = UIImageView(image:UIImage(named:"no_upload_diary"))
                diaryTableView.backgroundView?.alpha = 0
            }
            return allDiary.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Page1VC.diaryselectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableView" ,for:indexPath) as! DiaryTableViewCell
            let object = diarydataManager.fetchObject(at: indexPath.row)
            
            let cLlongitude = object?.longitude
            let cLlatitude = object?.latitude
            getLocation(latitude: cLlatitude!, longitude: cLlongitude!)
            cell.placeLabel.text = "取得位置中..."
            cell.placeLabel.text = address
            cell.placeImageView.image = UIImage(named: "ic_place")
            cell.noteImageView.image = UIImage(named:"ic_diary-1")
            cell.photoImageView.image = UIImage(named: "picture1")
            cell.tagImageView.image = UIImage(named: "ic_new")
            cell.starttimeLabel.text =  object?.startDate?.toString(dateFormat: "HH:mm")
            cell.endtimeLabel.text = object?.endDate?.toString(dateFormat: "HH:mm")
            cell.dateLabel.text = object?.startDate?.toString(dateFormat: "YYYY-MM-dd")
            cell.noteLabel.text = "請輸入日記內容"
            
            
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableView" ,for:indexPath) as! DiaryTableViewCell
            let diary = allDiary[indexPath.row]
            let cLlongitude = "\(diary.longitude)"
            let cLlatitude = "\(diary.latitude)"
            getLocation(latitude: cLlatitude, longitude: cLlongitude)
            cell.placeLabel.text = address
            cell.placeImageView.image = UIImage(named: "ic_place")
            cell.noteImageView.image = UIImage(named:"ic_diary-1")
            cell.photoImageView.image = UIImage(named: "picture1")
            cell.starttimeLabel.text =  diary.start_date.toSpecialDateString(style:"YYYY-MM-dd HH:mm:ss.s",dateformat: "HH:mm")
            cell.endtimeLabel.text = diary.end_date.toSpecialDateString(style:"YYYY-MM-dd HH:mm:ss.s",dateformat: "HH:mm")
            cell.dateLabel.text = diary.start_date.toSpecialDateString(style:"YYYY-MM-dd HH:mm:ss.s",dateformat: "YYYY-MM-dd")
            cell.noteLabel.text = diary.note
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if Page1VC.diaryselectedSegmentIndex == 0{
            let object = diarydataManager.fetchObject(at: indexPath.row)
            NSLog("\(diarydataManager.count)")
            self.diarydataManager.delete(object: object!)
            self.diarydataManager.saveContext{ (success) in}
            NSLog("\(diarydataManager.count)")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            } else{
                diaryCounts = self.allDiary.count
                deleteDiaryOnline(at:indexPath.row)
                if diaryCounts > self.allDiary.count{
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    // MARK: -preparefor segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DiaryViewController
         let indexPath = self.diaryTableView.indexPathForSelectedRow
        if Page1VC.diaryselectedSegmentIndex == 0{
       
        
        let object = diarydataManager.fetchObject(at: (indexPath?.row)!)
            controller.place = address!
            controller.startTime = (object?.startDate?.toString(dateFormat: "HH:mm"))!
            controller.endTime = (object?.endDate?.toString(dateFormat: "HH:mm"))!
            controller.startDate = (object?.startDate?.toString(dateFormat: "YYYY-MM-dd HH:mm:ss"))!
            controller.endDate = (object?.endDate?.toString(dateFormat: "YYYY-MM-dd HH:mm:ss"))!
            controller.date = (object?.startDate?.toString(dateFormat: "YYYY-MM-dd"))!
            controller.startStamp = "\(object?.startDate?.toTimeStamp())"
            controller.endStamp = "\(object?.endDate?.toTimeStamp())"
            controller.longitude  = object?.longitude!.toCLLoactionDegrees()
            controller.latitude = object?.latitude!.toCLLoactionDegrees()
            controller.diarySK = (object?.sk)!
            
        }else {
            let diary = allDiary[(indexPath?.row)!]
            controller.place = address!
            controller.startTime = diary.start_date.toSpecialDateString(style: "YYYY-MM-dd HH:mm:ss.s", dateformat: "HH:mm")
            controller.endTime = diary.end_date.toSpecialDateString(style: "YYYY-MM-dd HH:mm:ss.s", dateformat: "HH:mm")
            controller.startDate = diary.start_date
            controller.endDate = diary.end_date
            controller.date = diary.start_date.toSpecialDateString(style: "YYYY-MM-dd HH:mm:ss.s", dateformat: "YYYY-MM-dd")
            controller.startStamp = diary.start_stamp
            controller.endStamp = diary.end_stamp
            controller.longitude  = diary.longitude
            controller.latitude = diary.latitude
            controller.diarySK = "\(diary.sk)"
            
            
        }
        
    }
    
    func calculate(from index1:Int,to index2:Int){
        var averagelatitude:Double = 0.0
        var averagelongitude:Double = 0.0
        var totallatitude:Double = 0.0
        var totallongitude:Double = 0.0
        for  i  in index1 + 1  ... index2 {
            guard let latitude = dataManager.fetchObject(at: i - 1)?.latitude else{
                return
            }
            guard let longitude = dataManager.fetchObject(at: i - 1)?.longitude else{
                return
            }
            totallatitude += Double(latitude)!
            totallongitude += Double(longitude)!
        }
        averagelatitude = totallatitude / Double(index2 - index1 )
        averagelongitude = totallongitude / Double(index2 - index1 )
        guard let startcreationDate = dataManager.fetchObject(at: index1  )?.creationDate else{
            return
        }
        guard let endcreationDate = dataManager.fetchObject(at: index2 - 1)?.creationDate else{
            return
        }
        
        var finalObject:CreateDiary
        finalObject = self.diarydataManager.createObject()
        finalObject.startDate = startcreationDate
        finalObject.endDate = endcreationDate
        finalObject.longitude = "\(averagelongitude)"
        finalObject.latitude = "\(averagelatitude)"
        finalObject.sk = getCreatedSK()
        NSLog("生成日記, sk: \(finalObject.sk)")
        self.diarydataManager.saveContext{ (success) in}
        self.diaryTableView.reloadData()
        
        
    }
    func getPrimaryKey() -> String{
        
        
        guard let  key = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
            assertionFailure()
            return String()
        }
        guard let finalkey = keydataManager.fetchObject(at: keydataManager.count-1)else{
            assertionFailure()
            return String()
        }
        let newkey =  Int(key)! + 1
        finalkey.key = "\(newkey)"
        self.keydataManager.saveContext{ (success) in}
        NSLog((" key plus 1 :\(newkey)"))
        return "\(newkey)"
       
        
    }
    func getCreatedSK() -> String{
        
        
        guard let  key = keydataManager.fetchObject(at: keydataManager.count-1)?.createdsk else{
            assertionFailure()
            return String()
        }
        guard let finalkey = keydataManager.fetchObject(at: keydataManager.count-1)else{
            assertionFailure()
            return String()
        }
        let newkey =  Int(key)! + 1
        finalkey.createdsk = "\(newkey)"
        self.keydataManager.saveContext{ (success) in}
        NSLog((" createdsk plus 1 :\(newkey)"))
        return "\(key)"
        
        
        
    }
    func addDiaryCounts(){
        guard let  diraycounts = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
            assertionFailure()
            return
        }
        guard let finalkey = keydataManager.fetchObject(at: keydataManager.count-1)else{
            assertionFailure()
            return
        }
        
        let newdiraycounts =  Int(diraycounts)! + 1
        finalkey.diarycounts = " \(newdiraycounts)"
        NSLog(("newdiraycounts plus 1 :\(newdiraycounts)"))
        self.keydataManager.saveContext{ (success) in}
        
        
        
    }
    func deleteDiary(from index1:Int,to index2:Int){
        for  i  in index1 + 1  ... index2 {
            guard let deleteobject = dataManager.fetchObject(at: i - 1) else{
                return
            }
           dataManager.delete(object: deleteobject)
        
     }
    }
    func getDiaryOnline(){
        let parameters:[String:Any] = ["action":"getRecyclerViewDiary","account":"twodan7566@gmail.com","password":"twodan7566@gmail.com"]
        Common.shared.text(api: Common.DIARY_URL, jsonDictionary: parameters, jsonRow: 0) { (error, results) in
            var diary = DiaryDetail(sk: 0, member_sk: 0, top_category_sk: 0, member_location_sk: 0, note: "", start_stamp: "", end_stamp: "", start_date: "", end_date: "", latitude: 0.0, longitude: 0.0, altitude: 0.0)
            guard let results = results else{
                return
            }
            for result in results{
                diary.sk = result["sk"] as! Int
                diary.member_sk = result["member_sk"] as! Int
                diary.top_category_sk = result["top_category_sk"] as! Int
                diary.member_location_sk = result["member_location_sk"] as! Int
                diary.note = result["note"] as! String
                diary.start_stamp = result["start_stamp"] as! String
                diary.end_stamp = result["end_stamp"] as! String
                diary.start_date = result["start_date"] as! String
                diary.end_date = result["end_date"] as! String
                diary.altitude = result["altitude"] as! Double
                diary.longitude = result["longitude"] as! Double
                diary.latitude = result["latitude"] as! Double
                self.allDiary.append(diary)
            }
           
            self.diaryTableView.reloadData()
            
        }
    }
    func deleteDiaryOnline(at index:Int) {
        let parameters:[String:Any] = ["action":"toDeleteDiary","account":"twodan7566@gmail.com","password":"twodan7566@gmail.com","diaryDetailSK":allDiary[index].sk]
        Common.shared.textUpate(api: Common.DIARY_URL, jsonDictionary: parameters, doneHandler: { (error, result) in
            if let error = error{
                NSLog("deleteDiaryOnline fail : \(error)")
            }
            NSLog("deleteDiaryOnline:\(String(describing: result))")
            self.getDiaryOnline()
        })
    }
    func getImageList(){
        
    }
    func getImageOnline(){
        
    }
    func getLocation(latitude:String,longitude:String){
        
        let cLlongitude = longitude.toCLLoactionDegrees()
        let cLlatitude = latitude.toCLLoactionDegrees()
        let cLLocation = CLLocation(latitude: cLlatitude, longitude: cLlongitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(cLLocation) { (placeMarks, error) in
            
            if error != nil{
                NSLog("\(String(describing: error))" )
                return
            }
            if placeMarks != nil{
                
                let placeMark = placeMarks![0] as CLPlacemark
                self.address = placeMark.name!
                
                
               
            }
        }
    }
    
    
}
