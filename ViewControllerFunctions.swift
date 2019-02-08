//
//  ViewControllerFunctions.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/17/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SystemConfiguration

class ViewControllerFunction{

    func prepareSegues(_ segue: UIStoryboardSegue, sent: Any?) {
        let s = GameStats()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
        
        if (segue.identifier == "toDetail"){
            
            var fetchResults = ((try? s.managedObjectContext.fetch(fetchRequest)) as? [StatsEntity])!
            let selectedIndex : IndexPath = sent as! IndexPath
            
            let stats = fetchResults[selectedIndex.row]
            
            if (segue.identifier == "toDetail"){
                if let view : MatchDetailViewController = segue.destination as? MatchDetailViewController{
                    
                    view.date = stats.date
                    view.goals = stats.goals
                    view.assists = stats.assists
                    view.minutes = stats.minutes
                    view.long = stats.longitude
                    view.lat = stats.latitude
                    view.w = stats.wind
                    view.h = stats.humidity
                    view.t = stats.temp
                }
            }
        }
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

    func showAddAlert(on vc: ViewController, with title : String, message: String, i: NSData, la: Double, lo: Double ){
    
        let s = GameStats()
    
    let addStatAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    addStatAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    addStatAlert.addTextField(configurationHandler: { textField in
        textField.keyboardType = .numbersAndPunctuation
        textField.placeholder = "Enter Goals"
        
    })
    addStatAlert.addTextField(configurationHandler: { textField in
 
        textField.keyboardType = .numbersAndPunctuation
        
        textField.placeholder = "Enter Assists"
    })
    addStatAlert.addTextField(configurationHandler: { textField in
        textField.keyboardType = .numbersAndPunctuation

        textField.placeholder = "Enter Minutes Played"
    })
    
    vc.present(addStatAlert, animated: true)
    
    
    addStatAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        if addStatAlert.textFields?[2].text == "" || addStatAlert.textFields?[2].text == "0" {
            let alert2 = UIAlertController(title: "Oops!", message: "Please provide your location", preferredStyle: UIAlertController.Style.alert)
            alert2.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            
            vc.present(addStatAlert, animated: true)
            vc.present(alert2, animated: true, completion: nil)
            
        }else{
            
            let goals:Int? = Int(addStatAlert.textFields?.first?.text ?? "") ?? 0
            let assists:Int? = Int(addStatAlert.textFields?[1].text ?? "") ?? 0
            let minutes:Double? = Double(addStatAlert.textFields?.last?.text ?? "") ?? 0
            
            //save stats
            
            
            
            s.saveStats(g: goals!, a: assists!, m: minutes!, i: i, la: la, lo: lo)
            
            let notificationNme = NSNotification.Name("NotificationIdf")
            NotificationCenter.default.post(name: notificationNme, object: nil)
            
        }
    }))
    
}
}
