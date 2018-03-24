//
//  LottieBirthdayVC.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import Lottie

class LottieBirthdayVC: UIViewController {
    
    var number=0
    var button=UIButton()
    let animationView = LOTAnimationView(name: "gift")
     let animationOpenView = LOTAnimationView(name: "giftOpen")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
            
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation=true

//        animationView.animationSpeed=0.5
        
        view.addSubview(animationView)
        
        button.frame=CGRect(x: 0, y: 0, width: 350, height: 350)
//        button.backgroundColor=UIColor.darkGray
        button.center=self.view.center
        
        button.addTarget(self, action:  #selector(buttonPressed), for:.touchUpInside)
        
//        button.addTarget(self, action:  #selector(buttonUp), for:.touchUpInside)
        
        
        view.addSubview(button)
        animationView.play()


        

    }
    
    @objc func buttonPressed(){
        animationView.stop()
        animationView.isHidden=true
        
        animationOpenView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationOpenView.center = self.view.center
        animationOpenView.contentMode = .scaleAspectFill
        view.addSubview(animationOpenView)
        animationOpenView.play()
        number+=1
        if number==1{
        let time: TimeInterval = 2.2
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.performSegue(withIdentifier: "friendMatch", sender: nil)
        
                }
        
        }
        
        

    }
    
    @objc func buttonUp(){
        animationOpenView.loopAnimation=false
        animationOpenView.play(fromProgress: 0.3, toProgress: 1.0) { (ok) in
            if ok==true{self.performSegue(withIdentifier: "friendMatch", sender: nil)
                
        }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        number=0
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
