//
//  PieChartViewController.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import RKPieChart


class PieChartVC: UIViewController {
    
    @IBOutlet weak var sinceDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    // datePicker 元件
    let sinceDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    
    let today = NSDate()
    let formatter = DateFormatter()
    var todayBefore = NSDate()
    var endDateSelect = NSDate()
    
    static var startDateString: String!
    static var endDateString: String!

        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 給初始值
        formatter.dateFormat = "yyyy/MM/dd"
        let todayString = formatter.string(from: today as Date)
        endDate.text = "\(todayString)"
        todayBefore = today.addingTimeInterval(-60 * 60 * 24 * 7)
        let todayBeforeString = formatter.string(from: todayBefore as Date)
        sinceDate.text = "\(todayBeforeString)"
        pieChart(Shopping: 20, Hobby: 20, Learning: 20, Travel: 20, Work: 20)
        
        // 用成sever的時間格式
        formatter.dateFormat = "yyyy-MM-dd"
        PieChartVC.endDateString = formatter.string(from: today as Date)
        PieChartVC.startDateString = formatter.string(from: todayBefore as Date)
        
        creatSinceDatePicker()
        creatEndDatePicker()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        
    }
    
    
    
    
    
    // 創造datePicker的方法
    func creatSinceDatePicker() {
        
        // 設定語系
        sinceDatePicker.locale = NSLocale(
            localeIdentifier: "zh_TW") as Locale as Locale
        
        // 給預設值
        sinceDatePicker.date = todayBefore as Date
        
        // 設定初始時間
        sinceDatePicker.date = todayBefore as Date
        
        // 設定最晚時間
        sinceDatePicker.maximumDate = endDateSelect as Date
        
        // 創造toolbar
        let sinceToolbar = UIToolbar()
        sinceToolbar.sizeToFit()
        
        
        // 做一個tool button 在toolbar上
        var sinceItems = [UIBarButtonItem]()
        sinceItems.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        sinceItems.append(
            UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(sinceDonePressed))
        )
        
        
        sinceToolbar.items = sinceItems
        
        
        sinceDate.inputAccessoryView = sinceToolbar
        sinceDate.inputView = sinceDatePicker
        
        // 把datePicker轉成日期模式
        sinceDatePicker.datePickerMode = .date
        
    }
    
    // 同上
    func creatEndDatePicker() {
        
        // 設定語系
        endDatePicker.locale = NSLocale(
            localeIdentifier: "zh_TW") as Locale as Locale
        
        // 設定最早時間
        endDatePicker.minimumDate = todayBefore as Date
        
        // 設定最晚時間
        endDatePicker.maximumDate = today as Date
        
        // 創造toolbar
        let endToolbar = UIToolbar()
        endToolbar.sizeToFit()
        
        // 做一個tool button 在toolbar上
        var endItems = [UIBarButtonItem]()
        endItems.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        endItems.append(
            UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDonePressed))
        )
        
        endToolbar.items = endItems
        
        endDate.inputAccessoryView = endToolbar
        endDate.inputView = endDatePicker
        
        // 把datePicker轉成日期模式
        endDatePicker.datePickerMode = .date
        
    }
    
    
    // done按下去的事件
    @objc func sinceDonePressed() {
        //整理時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: sinceDatePicker.date)
        todayBefore = sinceDatePicker.date as NSDate
        sinceDate.text = "\(dateString)"
        formatter.dateFormat = "yyyy-MM-dd"
        PieChartVC.startDateString = formatter.string(from: sinceDatePicker.date)
        self.view.endEditing(true)
        creatSinceDatePicker()
        creatEndDatePicker()
        
        
        //把拿到數值給piechart
        pieChart(Shopping: 0, Hobby: 0, Learning: 0, Travel: 0, Work: 0)
    }
    
    @objc func endDonePressed() {
        //整理時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: endDatePicker.date)
        endDateSelect = endDatePicker.date as NSDate
        endDate.text = "\(dateString)"
        formatter.dateFormat = "yyyy-MM-dd"
        PieChartVC.endDateString = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
        creatSinceDatePicker()
        creatEndDatePicker()
        
        
        //把拿到數值給piechart
        pieChart(Shopping: 20, Hobby: 50, Learning: 20, Travel: 20, Work: 20)
    }
    
    func pieChart(Shopping: Int, Hobby: Int, Learning: Int, Travel: Int, Work: Int) {
       
        let Shopping: RKPieChartItem = RKPieChartItem(ratio: uint(Shopping), color: UIColor(rgb: 0x1C836E), title: "Shopping ")
        let Hobby: RKPieChartItem = RKPieChartItem(ratio: uint(Hobby), color: UIColor(rgb: 0x7AD4BC) , title: "Hobby")
        let Learning: RKPieChartItem = RKPieChartItem(ratio: uint(Learning), color: UIColor(rgb: 0x2B3D41), title: "Learning")
        let Travel: RKPieChartItem = RKPieChartItem(ratio: uint(Travel), color: UIColor(rgb: 0x4C5F6B), title: "Travel")
        let Work: RKPieChartItem = RKPieChartItem(ratio: uint(Work), color: UIColor(rgb: 0x83A0A0), title: "Work")
        
        let chartView = RKPieChartView(items: [Shopping, Hobby, Learning, Travel, Work], centerTitle: "D.Life")
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 60
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = false
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)
        
        chartView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2).isActive = true
        chartView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    // 把Button上面的字送到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let category = sender as! UIButton
        let controller = segue.destination as! DiaryViewVC
        controller.category = category.currentTitle
    }

}


// 轉色碼的方法
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
