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

class DiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    
    let minimumItemIntervalSpace: CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let image = UIImage(named: "Book")
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
    
    
    @IBAction func photoBtnPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose source?", message:nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let album = UIAlertAction(title: "Album", style: .default) { (action) in
            let vc = BSImagePickerViewController()
            self.bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
                                                
                                                // User selected an asset.
                                                // Do something with it, start upload perhaps?
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
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

}
