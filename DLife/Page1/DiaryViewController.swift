//
//  DiaryViewController.swift
//  D.Life
//
//  Created by Allen on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import BSImagePicker
import BSGridCollectionViewLayout
import UIImageViewModeScaleAspect
import Photos


class DiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate{
   
  
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var landmarkPickerView: UIPickerView!
    @IBOutlet weak var contentConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var topicTextView: UITextView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var endtimeLabel: UILabel!
    @IBOutlet weak var starttimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoBtnOutlet: UIButton!
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    var selectedUIImages = [UIImage]()
    let minimumItemIntervalSpace: CGFloat = 1
    var date:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var place:String = ""
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    let category = ["Shopping","Hobby", "Learning", "Travel", "Work"]
    var nearbyItems =  [Landmark]()
    var diarySK:String = ""
    var categoryType:String = ""
    var diaryDetail:DiaryDetail!
    var startStamp = ""
    var endStamp = ""
    var lanmarkPickerRow:Int = 0
    var top_category_sk = 0
    var startDate = ""
    var endDate = ""
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedUIImages.count == 0{
            return 1
        }
        return selectedUIImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        if selectedUIImages.count == 0{
            let image = UIImage(named:"ex_photo")
            cell.PhotoImageView.image = image
            return cell
        }
        let image = selectedUIImages[indexPath.row]
        cell.PhotoImageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let cW = collectionView.bounds.size.width
        let cH = collectionView.bounds.size.height
        return CGSize(width: cW, height: cH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemIntervalSpace
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        NSLog("\(String(describing: pickerView.restorationIdentifier))")
        
        if pickerView.restorationIdentifier == "category"{
            return category.count}
        else{
            return nearbyItems.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.restorationIdentifier == "category"{
          return category[row]
        } else {
            return nearbyItems[row].name
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.restorationIdentifier == "category"{
            categoryType = category[row]
            top_category_sk = row
        } else {
            lanmarkPickerRow = row
        }
    }
    
    
    @IBAction func photoBtnPressed(_ sender: UIButton) {
        
        sender.setImage(UIImage(named:"photo_select_ontouch"), for: .normal)
        let alert = UIAlertController(title: "Choose source?", message:nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let album = UIAlertAction(title: "Album", style: .default) { (action) in
            let vc = BSImagePickerViewController()
            self.bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
                                                // User selected an asset.
                                                // Do something with it, start upload perhaps?
                                                 self.selectedUIImages.append(self.PHAssetToUIImage(asset: asset))
                                                NSLog("select asset:\(asset)")
                                                
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
                  NSLog("deselect asset:\(asset)")
//                var deslectImage = self.PHAssetToUIImage(asset: asset)
//                for image in self.selectedUIImages{
//                    if image == deslectImage{
//                        //self.selectedUIImages.remove(at: <#T##Int#>)
//                    }
//                }
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                self.selectedUIImages.removeAll()
                 NSLog("cancel asset:\(assets)")
              self.selectedUIImages.removeAll()
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                //assets = self.selectedUIImages
                DispatchQueue.main.async(execute: {
                    self.diaryCollectionView.reloadData()
                    // Handle further UI related operations here....
                    //let ad = UIApplication.shared.delegate as! AppDelegate
                    //let context = ad.persistentContainer.viewContext

                })
                
            }, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            lanuchImagePicker(type:.camera)
        }
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil )
        
        func lanuchImagePicker(type:UIImagePickerControllerSourceType) {
            //Check if have type
            NSLog("type: \(type.rawValue)")
            guard UIImagePickerController.isSourceTypeAvailable(type) else{
                NSLog("Invalid source type.")
                return
            }
            let picker = UIImagePickerController()
            //接受照片和影片
            let mediaTypes = ["public.image","public.movie"]
            //let mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
            picker.sourceType = type
            picker.mediaTypes = mediaTypes
            //有畫面裁切和影片裁切
            picker.allowsEditing = true
            picker.delegate = self
            
            present(picker, animated: true, completion: nil)
        }
        //MARK: - UIImagePickerControllerDelegate Method.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            NSLog("didFinishPickerMediaWithInfo:\(info)")
            guard let type = info[UIImagePickerControllerMediaType] as? String else {
                //遇到閃退(上架後不會執行)
                assertionFailure()
                //abort()
                return
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        placeLabel.text = place
        starttimeLabel.text = startTime
        endtimeLabel.text = endTime
        dateLabel.text = date
        let placeCoordinate = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        NSLog("placeCoordinate: \(placeCoordinate)")
        //註冊我在意鍵盤即將升起的通知
        //#selector後面帶方法
        NotificationCenter.default.addObserver(self, selector: #selector(moveTextFieldUP(aNotification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        getLandmark(latitude: Double(self.latitude!), longitude: Double(self.longitude!))
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func PHAssetToUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "place":
            let placeCoordinate = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
            let mvcontroller = segue.destination as! MapViewController
            mvcontroller.placeCLLocation = placeCoordinate
            
        case "landmark":
            let placeCoordinate = CLLocation(latitude: self.nearbyItems[lanmarkPickerRow].latitude as CLLocationDegrees, longitude: self.nearbyItems[lanmarkPickerRow].longitude as CLLocationDegrees)
            let mvcontroller = segue.destination as! MapViewController
            mvcontroller.landmarkCLLoction = placeCoordinate
            
        default:
            break
        }
    }
    
    //當鍵盤即將升起時會執行的方法
    @objc func moveTextFieldUP(aNotification:Notification){
        //取出詳情（字典資料型態）
        let info = aNotification.userInfo
        //取出尺寸值（給key取出NSValue）
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        //將尺寸值轉為CGSize
        let size = sizeValue.cgRectValue.size
        //拿出高度
        let height = size.height
        //把底部的距離改為0
        contentConstraint.constant = -height
        //利用動畫增加延遲感
        UIView.animate(withDuration: 0.25){
            //重繪畫面
            self.view.layoutIfNeeded()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.resignFirstResponder()
        contentConstraint.constant = 0
        return true
    }
   
    
    @IBAction func placeBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func landmarkBtnPressed(_ sender: UIButton) {
    }
    // MARK: -doneDiaryBtnPressed
    @IBAction func doneDiaryBtnPressed(_ sender: UIBarButtonItem) {
        if Page1VC.diaryselectedSegmentIndex == 0{
            insertDiary()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"delete"), object: self.diarySK)
        } else{
            updateDiary()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getLandmark(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let parameters:[String:Any] = ["action":"nearby","account":"twodan7566@gmail.com","password":"Allen","latitude":Double(latitude),"longitude":Double(longitude)]
        Common.shared.text(api: Common.MAPAPI_URL, jsonDictionary: parameters, jsonRow: 0) { (error, results) in
            if let error = error{
                NSLog("getLandmark fail : \(error)")
            }
            NSLog("\(String(describing: results))")
            var landmark = Landmark(longitude:0.0,latitude:0.0,name:"",placeID:"")
            guard let results = results else{
                landmark.name = "附近沒有地標"
                self.nearbyItems.append(landmark)
                return
            }
            
            for result in results{
                landmark.name = result["name"] as! String
                landmark.longitude = result["longitude"] as! Double
                landmark.latitude = result["latitude"] as! Double
                landmark.placeID = result["placeID"] as! String
                self.nearbyItems.append(landmark)
                NSLog("\(self.nearbyItems.count)" )
                self.landmarkPickerView.reloadAllComponents()
            }
        }
    
    }
    func insertDiary(){
        
        diaryDetail = DiaryDetail(sk: Int(diarySK)!, member_sk: 6, top_category_sk: top_category_sk, member_location_sk: 0, note: contentTextView.text, start_stamp: startStamp, end_stamp: endStamp, start_date: startDate, end_date: endDate, latitude: Double(latitude!), longitude: Double(longitude!), altitude: 0.0)
        guard let jsonString =  try? Common.shared.toJsonString(diaryDetail) else{
            return
        }
        NSLog(" diaryDetail jsonString : \(jsonString) ")
        let parameters:[String:Any] = ["action":"insertDiary","account":"twodan7566@gmail.com","password":"twodan7566@gmail.com","categoryType":categoryType ,"diaryDetail":jsonString]
        
        Common.shared.textUpate(api: Common.DIARY_URL, jsonDictionary: parameters) { (error, result) in
            if let error = error{
                NSLog("insertDiary fail : \(error)")
            }
            NSLog("\(String(describing: result))")
            guard let savedDiarySK = result else{
                NSLog("savedDiarySK : nil ")
                return
            }
            NSLog("insertDiary sk : \(savedDiarySK)")
            self.insertLandmark(sk: savedDiarySK)
            self.updateImage(sk: savedDiarySK)
            
        }

}
    func insertLandmark(sk:Int){
        let landmark = self.nearbyItems[self.lanmarkPickerRow]
        guard let jsonString =  try? Common.shared.toJsonString(landmark) else{
            return
        }
        NSLog("landmark jsonString : \(jsonString) ")
        let parameters:[String:Any] = ["action":"nearBySelect","account":"twodan7566@gmail.com","password":"twodan7566@gmail.com","diaryDetailSK":sk,"nearBy":jsonString]
        Common.shared.textUpateLandmark(api: Common.MAPAPI_URL, jsonDictionary: parameters, doneHandler: { (error, result) in
            
            if let error = error{
                NSLog("insertLandmark fail : \(error)")
            }
            NSLog("\(String(describing: result))")
            guard let savedLandmark = result else{
                NSLog("insertLandmarkSK : nil ")
                return
            }
            NSLog("\(savedLandmark)")
        })
        
    }
    func updateDiary(){
        diaryDetail = DiaryDetail(sk: Int(diarySK)!, member_sk: 6, top_category_sk: top_category_sk, member_location_sk: 0, note: contentTextView.text, start_stamp: startStamp, end_stamp: endStamp, start_date: startDate, end_date: endDate, latitude: Double(latitude!), longitude: Double(longitude!), altitude: 0.0)
        guard let jsonString =  try? Common.shared.toJsonString(diaryDetail) else{
            return
        }
        NSLog(" diaryDetail jsonString : \(jsonString) ")
        let parameters:[String:Any] = ["action":"uploadDiary","account":"twodan7566@gmail.com","password":"Allen",
                                       "uploadCategoryType":categoryType ,"diaryDetail":"" ]
        Common.shared.textUpateLandmark(api: Common.DIARY_URL, jsonDictionary: parameters, doneHandler: { (error, result) in
            
            if let error = error{
                NSLog("updateDiary fail : \(error)")
            }
            NSLog("\(String(describing: result))")
            guard let savedLandmark = result else{
                NSLog("updateDiary : nil ")
                return
            }
            NSLog("\(savedLandmark)")
            self.updateLandmark()
            self.updateImage(sk: Int(self.diarySK)!)
        })

    }
    
    func updateImage(sk:Int){
        for image in self.selectedUIImages{
            let maxWidthHeight:CGFloat = 350.0
            image.resizeImage(maxWidthHeight: maxWidthHeight)
        let parameters:[String:Any] = ["action":"insertDiaryPhoto","account":"twodan7566@gmail.com","password":"twodan7566@gmail.com","diaryDetailSK":sk ,"imageBase64":image.toBase64String()!]
            Common.shared.textUpate(api: Common.DIARY_URL, jsonDictionary: parameters, doneHandler: { (error, result) in
                if let error = error{
                    NSLog("updateImage fail : \(error)")
                }
                NSLog("updateImage:\(String(describing: result))")
            })
        }
    }
    
    
    
    func updateLandmark(){
        let parameters:[String:Any] = ["action":"uploadNearBySelect","account":"twodan7566@gmail.com","password":"Allen","nearBy":["name":nearbyItems[lanmarkPickerRow].name,"placeID":nearbyItems[lanmarkPickerRow].placeID,"latitude":nearbyItems[lanmarkPickerRow].latitude,"longitude":nearbyItems[lanmarkPickerRow].longitude]]
        Common.shared.textUpate(api: Common.MAPAPI_URL, jsonDictionary: parameters, doneHandler: { (error, result) in
            if let error = error{
                NSLog("updateLandmark fail : \(error)")
            }
            NSLog("updateLandmark:\(String(describing: result))")
        })
        
        
    }
}
