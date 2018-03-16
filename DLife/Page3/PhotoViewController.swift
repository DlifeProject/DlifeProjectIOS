//
//  PhotoViewController.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/11.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import MobileCoreServices

class PhotoViewController: UIViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBAction func addPhotoBtn(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Choose source?", message:nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let album = UIAlertAction(title: "Album", style: .default) { (action) in
            self.lauchImagePicker(type: .photoLibrary)
            
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.lauchImagePicker(type: .camera)
        }
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil )
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func lauchImagePicker(type: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            NSLog("Invaalid source type.")
            return
        }
        
        let picker = UIImagePickerController()
        //        let mediaTypes = ["public.image","public.movie"]
        //mediaTypes:照片 影片.
        //sourceType:PhotoLibrary(圖庫中的所有資料夾)Camera(拍攝照片影片)SavedPhotosAlbum(預設資料夾,相機膠卷)
        
        let mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        picker.sourceType = type
        picker.mediaTypes = mediaTypes
        picker.allowsEditing = true
        picker.delegate = self
        //The view controller to display over the current view controller’s content.
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Method.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("didFinishPickingMediaWithInfo: \(info)")
        guard let type = info[UIImagePickerControllerMediaType] as? String else {
            assertionFailure() // 讓app閃退 開發版有用 abort()不管上架版本或開發版本都會閃退
            return
        }
        if type == (kUTTypeImage as String) {
            
            //UIImagePickerControllerOriginalImage 是原始  ,edited是使用者編輯後的
            //UIImagePickerControllerImageURL路徑
            guard let originalImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
                return
            }
            
            //            let originalJPGData = UIImageJPEGRepresentation(originalImage, 0.8)
            //            let originalPNGData = UIImagePNGRepresentation(originalImage)
            //            NSLog("\(originalImage): , JPG Size: \(originalJPGData!.count),PNG Size: \(originalPNGData!.count)")
            guard let resizedImaage = originalImage.resize(maxWidthHeight: 1024) else {
                return
            }
            guard let resizedJPGData = UIImageJPEGRepresentation(resizedImaage, 0.8) else {
                return
            }
            NSLog("\(resizedImaage): ,JPG Size: \(resizedJPGData.count)")
            imageView.image=resizedImaage
//            let byteArray=UIimagerep resizedImaage
            
        }
        picker.dismiss(animated: true, completion: nil) // 很重要 退出
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
