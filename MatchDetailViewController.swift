//
//  MatchDetailViewController.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/12/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import UIKit
import MapKit

class MatchDetailViewController: UIViewController {

    
    @IBOutlet weak var detailDateLabel: UILabel!
    
    
    @IBOutlet weak var detailGoalsLabel: UILabel!
    
    @IBOutlet weak var detailAssistsLabel: UILabel!
    
    
    @IBOutlet weak var detailMinutesLabel: UILabel!
    
    @IBOutlet weak var detailWindLabel: UILabel!
    
    @IBOutlet weak var detailHumidLabel: UILabel!
    
    @IBOutlet weak var detailTempLabel: UILabel!
    
    var date: String?
    var goals : Double?
    var assists : Double?
    var minutes : Double?
    var long : Double?
    var lat:Double?
    var w: String?
    var h : Double?
    var t: String?
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        super.viewDidLoad()
        displayMap()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        detailDateLabel.text = date
        detailGoalsLabel .text = goals?.description
        detailAssistsLabel.text = assists?.description
        detailMinutesLabel.text = minutes?.description
        detailHumidLabel.text = h?.description
        if t == "" {detailTempLabel.text = "N/A"
        }
        else{
        let cel = Double(t!)
        let b    = ( (cel! * 1.8 ) + 32)
        detailTempLabel.text = b.rounded().description
        detailWindLabel.text = w?.description
        map.mapType = MKMapType.satellite
        }
    }
    func removeMapMemory() {
        //deallocate memory used
        map.mapType = MKMapType.satellite
        map.delegate = nil
        map.removeFromSuperview()
        map = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeMapMemory()
    }

    func displayMap(){
        if long! != 0.0{
        let annotation = MKPointAnnotation()
            if long == -122.03118 {
                annotation.title = "DEFAULT, please allow location serivces in settings!"
            }else{
                annotation.title = "Played Here"
            }
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
       
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        self.map.setRegion(region, animated: true)
        
        map.addAnnotation(annotation)
        }else {
    
        }
    }
}
