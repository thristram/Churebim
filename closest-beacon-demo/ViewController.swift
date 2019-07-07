//
//  ViewController.swift
//  closest-beacon-demo
//
//  Created by Will Dages on 10/11/14.
//  @willdages on Twitter
//

import UIKit
import CoreLocation
import SwiftHTTP


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var imageview: UIImageView!
    var currentMinor: Int = 0
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, identifier: "Estimotes")
    // Note: make sure you replace the keys here with your own beacons' Minor Values
    let colors = [
        16: #imageLiteral(resourceName: "suitblazer"),
        17: #imageLiteral(resourceName: "Jacket Product with Tabs"),
//        27327: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            let newMinor = closestBeacon.minor.intValue
            if self.currentMinor != newMinor{
                self.currentMinor = newMinor
//                let url = URL (string: self.colors[newMinor]!)
//                let requestObj = URLRequest(url: url!)
//                webview.loadRequest(requestObj)
                if self.colors[newMinor] != nil{
                    self.imageview.image = self.colors[newMinor]!
                }
                
                HTTP.GET("https://seraphtechnology.com/cherubim/log", parameters: ["minor": "\(newMinor)"]) { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    print("opt finished: \(response.description)")
                    //print("data is: \(response.data)") access the response of the data with response.data
                }
            }
            
            
        }
    }
    
}

