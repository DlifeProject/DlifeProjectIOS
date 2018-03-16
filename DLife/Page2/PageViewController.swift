//
//  PageViewController.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

// 這裡是控制換頁
class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageIndex = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        pageIndex = index
        let previousIndex = index - 1
        guard previousIndex >= 0 && previousIndex < orderedViewControllers.count else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        pageIndex = index
        let nextIndex = index + 1
        guard nextIndex >= 0 && nextIndex < orderedViewControllers.count else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([pieChartVC], direction: .forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var pieChartVC: PieChartVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "PieChart")
        }() as! PieChartVC
    
    lazy var shoppingVC: ShoppingVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "Shopping")
        }() as! ShoppingVC
    
    lazy var hobbyVC: HobbyVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "Hobby")
        }() as! HobbyVC
    
    lazy var learningVC: LearningVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "Learning")
        }() as! LearningVC
   
    lazy var travelVC: TravelVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "Travel")
        }() as! TravelVC
    
    lazy var workVC: WorkVC = {
        self.storyboard!.instantiateViewController(withIdentifier: "Work")
        }() as! WorkVC
    
    lazy var orderedViewControllers: [UIViewController] = {
        [self.pieChartVC, self.shoppingVC, self.hobbyVC, self.learningVC, self.travelVC, self.workVC]
    }()
    
    
    //給定index值然後可以換到指定頁
    func showPage(byIndex index: Int) {
        let viewController = orderedViewControllers[index]
        if index > pageIndex {
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            pageIndex = index
        } else {
            setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
            pageIndex = index
        }
    }
}
