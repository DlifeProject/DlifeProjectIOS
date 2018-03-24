//
//  Page2VC.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class Page2VC: UIViewController {

    //宣告成員變數
    var pageViewController: PageViewController!
        
    //從ContainerView的Segue取得裡面的頁面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            pageViewController = segue.destination as! PageViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = "hello"
        let url = Common.fileURL(fileKey: a)
        let dictionary: Dictionary = ["name":"Tom", "age": 18] as [String : Any]
        Common.plistSave(fileURL: url, dictionary: dictionary)
        let b = Common.plistLoad(fileURL: url)
        print(b)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func arrorLeftBtnPress(_ sender: Any) {
        if pageViewController.pageIndex > 0 {
            
            pageViewController.showPage(byIndex: pageViewController.pageIndex - 1)
            
        }
    }
    
    @IBAction func arrorRightBtnPress(_ sender: Any) {
        if pageViewController.pageIndex < 5 {
        
            pageViewController.showPage(byIndex: pageViewController.pageIndex + 1)
            
        }
    }
    
    

}
