//
//  AlreadyMatchVC.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/21.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import Lottie

class AlreadyMatchVC: UIViewController {
    let animationView = LOTAnimationView(name: "empty_status")


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation=true
        //        animationView.animationSpeed=0.5
        view.addSubview(animationView)
        animationView.play()

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
