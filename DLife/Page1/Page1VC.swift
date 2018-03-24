//
//  Page1VC.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//
// Regan test
import UIKit
import CoreLocation
class Page1VC: UIViewController,  UITableViewDelegate,UITableViewDataSource ,CLLocationManagerDelegate{
    var diarys = Diary.all
    var objects = [Any]()
    var dataManager:CoredataManger<DiaryTest>!
    var keydataManager:CoredataManger<Key>!
    var diarydataManager:CoredataManger<CreateDiary>!
    let locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         //return diarydataManager.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableView" ,for:indexPath) as! DiaryTableViewCell
//        let object = diarydataManager.fetchObject(at: indexPath.row)
//        cell.placeLabel.text = object?.longitude
//        cell.noteLabel.text = object?.latitude
//        cell.starttimeLabel.text = " \(String(describing: object?.startDate))"
//        cell.endtimeLabel.text = "\(String(describing: object?.endDate))"
        //cell.noteLabel.text = "\(object?.key)"
   
        cell.placeLabel.text = "123"
        cell.noteLabel.text = "321"
        
            return cell
    }


    @IBAction func diaryStateChangedSegmentContril(_ sender: UISegmentedControl) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        NotificationCenter.default.addObserver(self, selector: #selector(getGPSInBackground), name: NSNotification.Name("WillTerminate"), object: nil)
        
       locationManager.startUpdatingLocation()
        
        //For Background Mode.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
         dataManager = CoredataManger<DiaryTest>(momdFilename: "DiaryModel", entityName: "DiaryTest", sortKey: "creationDate")
        keydataManager = CoredataManger<Key>(momdFilename: "DiaryModel", entityName: "Key", sortKey: "key")
        diarydataManager = CoredataManger<CreateDiary>(momdFilename: "DiaryModel", entityName: "CreateDiary", sortKey: "startDate")
        // Do any additional setup after loading the view.
    }
    @objc func getGPSInBackground(notification:Notification)  {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            NSLog("Fail to get coordinate")
            return
        }
        let place = "\(coordinate.longitude) + \(coordinate.latitude)"
        NSLog("place:\(place)")
        

       // creatediary(coordinate)
        
        
        self.diaryTableView.reloadData()
        
    }
    func getDistance(from indexA:CLLocation, to indexB:CLLocation) -> Double{
        return indexA.distance(from: indexB)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getPrimaryKey() -> String{
//        if keydataManager.count == 0{
//            var finalkey = Key()
//            finalkey = self.keydataManager.createObject()
//            finalkey.key = 1
//            self.keydataManager.saveContext{ (success) in}
//            return 1
//        } else{
        
        guard let  key = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
            assertionFailure()
            return String()
                        }
            let finalkey = Key()
            let newkey =  Int(key)! + 1
            finalkey.key = "\(newkey)"
            self.keydataManager.saveContext{ (success) in}
            print("newkey")
            return "newkey"
            
        
    
    }
    func addDiaryCounts(){
        guard let  diraycounts = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
            assertionFailure()
            return
        }
        let finalkey = Key()
        let newdiraycounts =  Int(diraycounts)! + 1
        finalkey.diarycounts = " \(newdiraycounts)"
        self.keydataManager.saveContext{ (success) in}
        print("newdiraycounts")
        
    }
    func creatediary(_ coordinate:CLLocationCoordinate2D){
        if dataManager.count != 0 {
            
            guard let preforwardkey = dataManager.fetchObject(at: dataManager.count - 1)?.forwardkey else{
                return
            }
            guard let prekey = dataManager.fetchObject(at: dataManager.count - 1)?.key else {
                return
            }
            if preforwardkey == "0" {
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
                NSLog("distance is \(distance) M")
                if distance < 5.0{
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = prekey
                    self.dataManager.saveContext{ (success) in}
                    addDiaryCounts()
                    
                }else{
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = "0"
                    self.dataManager.saveContext{ (success) in}
                    
                }
            }else {
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
                NSLog("distance is \(distance) M")
                if distance < 5.0{
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = preforwardkey
                    self.dataManager.saveContext{ (success) in}
                    addDiaryCounts()
                    
                }else{
                    var finalObject = DiaryTest()
                    finalObject = self.dataManager.createObject()
                    finalObject.creationDate = Date()
                    finalObject.longitude = "\(coordinate.longitude)"
                    finalObject.latitude = "\(coordinate.latitude)"
                    finalObject.key = getPrimaryKey()
                    finalObject.forwardkey = "0"
                    self.dataManager.saveContext{ (success) in}
                    
                    guard let  diraycounts = keydataManager.fetchObject(at: keydataManager.count-1)?.key else{
                        assertionFailure()
                        return
                    }
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
            self.keydataManager.saveContext{ (success) in}
        }
        
    }
    func calculate(from index1:Int,to index2:Int){
        var averagelatitude:Double = 0.0
        var averagelongitude:Double = 0.0
        var totallatitude:Double = 0.0
        var totallongitude:Double = 0.0
        for  i  in index1 + 1 ... index2 - 1 {
            guard let latitude = dataManager.fetchObject(at: i - 1)?.latitude else{
                return
            }
            guard let longitude = dataManager.fetchObject(at: i - 1)?.longitude else{
                return
            }
            totallatitude += Double(latitude)!
            totallongitude += Double(longitude)!
        }
        averagelatitude = totallatitude / Double(index2 - index1 - 1)
        averagelongitude = totallongitude / Double(index2 - index1 - 1)
        guard let startcreationDate = dataManager.fetchObject(at: index1 )?.creationDate else{
            return
        }
        guard let endcreationDate = dataManager.fetchObject(at: index2 - 2)?.creationDate else{
            return
        }
        
        var finalObject:CreateDiary
        finalObject = self.diarydataManager.createObject()
        finalObject.startDate = startcreationDate
        finalObject.endDate = endcreationDate
        finalObject.longitude = "\(averagelongitude)"
        finalObject.latitude = "\(averagelatitude)"
        self.diarydataManager.saveContext{ (success) in}
        
        
    }

}
