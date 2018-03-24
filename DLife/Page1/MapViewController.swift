//
//  MapViewController.swift
//  D.Life
//
//  Created by Allen on 2018/3/19.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var placeCLLocation:CLLocation?
    var landmarkCLLoction:CLLocation?

    @IBOutlet weak var diaryMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryMapView.mapType = .standard
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let mapLoaction =  (placeCLLocation == nil ? landmarkCLLoction : placeCLLocation)
        let region = MKCoordinateRegion(center: (mapLoaction?.coordinate)!, span: span)
        diaryMapView.setRegion(region, animated: true)
        diaryMapView.setCenter((mapLoaction?.coordinate)!, animated: true)
        let  annotation = MKPointAnnotation()
        annotation.coordinate = (mapLoaction?.coordinate)!
        diaryMapView.addAnnotation(annotation)

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
