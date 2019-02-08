//
//  ViewController.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/6/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import UIKit
import CoreData
import Photos
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    var dataSource = ObjectDataSource()
    let photoPicker = UIImagePickerController ()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
   
    @IBOutlet weak var matchTable: UITableView!
    
    @IBOutlet weak var viewProgressBtn: UIButton!
    
    
    //bar button actions
    @IBAction func deleteAll(_ sender: Any) {
        //show alert to delete and call method to delete from Model
     Alert.showBasicAlert(on: self, with: "Warning! Are you sure you want to delete ALL Stats?", message: "For individual deletion, slide left on the specific date", actionName: "Delete All")
    }
    
    fileprivate func showHelpMenu() {
        //menu to show once user opens app for 1st time or needs help
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUp") as! HelpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func help(_ sender: Any) {
        //show help on the tab button
        showHelpMenu()
    }
    
    
    @IBAction func viewMore(_ sender: Any) {
        //user can choose to view more cells  by adjusting the table frame location
         matchTable.frame = CGRect(x: 0, y: 383, width: self.view.frame.size.width, height: 300)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]  ) {
        if let location = locations.first{
            currentLocation = location
        }
    }
    
    @IBAction func addStats(_ sender: UIButton) {
        sender.shake()
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self](_) in
                // Present the UIImagePickerController
                self?.present((self?.photoPicker)!, animated: true, completion: nil)
            }
        }
        let alertController = UIAlertController(title: "First add picture of the field", message: "It will help us determine the game conditions", preferredStyle: .alert)
        
        let serachAction = UIAlertAction(title: "Library", style: .default) { (action) in
            // load image
            self.photoPicker.sourceType = .photoLibrary
            // display image selection view
            self.self.present(self.photoPicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default) { (action) in
                                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                                //self.photoPicker.delegate = self
                                                self.photoPicker.allowsEditing = false
                                                self.photoPicker.sourceType = UIImagePickerController.SourceType.camera
                                                self.photoPicker.cameraCaptureMode = .photo
                                                self.photoPicker.modalPresentationStyle = .fullScreen
                                                self.present(self.photoPicker,animated: true,completion: nil)
                                            } else {
                                                print("No camera")
                                            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cameraAction)
        alertController.addAction(serachAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let fieldImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                let coordinate = (info[UIImagePickerController.InfoKey.phAsset] as? PHAsset)?.location?.coordinate
                var  lat: Double = coordinate?.latitude ?? 0.0
                var  lon: Double = coordinate?.longitude ?? 0.0

                if lon == 0.0  || lat == 0.0 {
                    if self.currentLocation == nil{
                        lon = -122.03118
                        lat = 37.33182
                    }else{
                        lon = self.currentLocation.coordinate.longitude
                        lat = self.currentLocation.coordinate.latitude
                    }
                }
                let vcf = ViewControllerFunction()
                let resized = vcf.resizeImage(image: fieldImage, newWidth: 150)
                let imageData = resized.pngData()
                self.stats(i: imageData! as NSData,la: lat , lo: lon )
            })
        }
    }
    
    func stats(i: NSData, la: Double, lo: Double){
        //present alert that asks user to add stats
        let vcf = ViewControllerFunction()
        vcf.showAddAlert(on: self, with: "Add Stats", message: "Make sure not leave any field empty",i: i, la: la, lo: lo)
    }
    
    fileprivate func setBackground() {
        //set app backgrouund image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidLoad() {
        //check if user had launched app beofre, if not then show welome message
        let vc = ViewControllerFunction()
        if vc.isAppAlreadyLaunchedOnce() == false{
            showHelpMenu()
        }
        photoPicker.delegate = self
        matchTable.dataSource = dataSource
        setBackground()
        viewProgressBtn.layer.cornerRadius = 10.0
        viewProgressBtn.layer.masksToBounds = true
      
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        let notificationNme = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadTableview), name: notificationNme, object: nil)
    }
    
    @objc func reloadTableview() {
        self.matchTable.reloadData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        //check if user has an internet connection, if not then display alert
        if Reachability.isConnectedToNetwork() == false {
            Alert.showBasicAlert(on: self, with:  "No Internet Detected", message: "This app requires an Internet connection to add stats, feel free to look around", actionName: "Okay")
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.2333, saturation: 0, brightness: 0.89, alpha: 1.0)
        self.matchTable.tableFooterView = UIView(frame: .zero)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vd = ViewControllerFunction()
        if (segue.identifier == "toDetail"){
        let send = (matchTable.indexPath(for: sender as! MatchTableViewCell)!)
        vd.prepareSegues(segue, sent: send)
        }
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue  = unwindScaleSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
}

