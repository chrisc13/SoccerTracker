//
//  AddGameStats.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/7/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class GameStats : UIViewController , CLLocationManagerDelegate{
    var tep: String?
    var win : String?
    var hum: Double?
    var currentLocation = CLLocation()
    var totalGoals = 0
    var totalAssists = 0
    var totalMinutes = 0.0
    var gameContributions = [Double]()
    var conditions = [Bool]()
     var gameContribution : Double = 0
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    
    
    //this is the array to store entities from the coredata
    var fetchResults = [StatsEntity]()
    
    func getDate()-> String{
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        
        let re = formatter.string(from: date)
        return re
    }
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
            try managedObjectContext.save()
        } catch {
            // Error Handling
        }
    }
    
    func saveStats(g : Int, a : Int, m:Double, i: NSData, la:Double, lo: Double){
        if lo == 0.0  || la == 00 {
            //web api call to get current weather
            getJson(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude, completion: {t,w,h in
                self.tep = t
                self.hum = Double(h)
                self.win = w
            })
        }
        
        getJson(lat: la, long: lo, completion: {t,w,h in
               // let a:Int? = Int(t) //convert temp string to degtree faren
                //let b    = ( (a! * (9 / 5) ) + 32)
                self.tep = t
            
                self.hum = Double(h)
                self.win = w })
        
        
        let goal = Double (g)
        let assist = Double (a)
        
       let ent = NSEntityDescription.entity(forEntityName: "StatsEntity", in: self.managedObjectContext)
        //add to the manege object context
   
        let newItem = StatsEntity(entity: ent!, insertInto: self.managedObjectContext)
        newItem.date = self.getDate()
        newItem.goals = goal
        newItem.assists = assist
        newItem.minutes = m
        newItem.latitude = la
        newItem.longitude = lo
        newItem.temp = tep
        newItem.wind = win
        newItem.humidity = Double(hum ?? 0)
        newItem.matchpicture = i
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
    }

    func calcStats() -> (Int, Int, Double, [Double], [Bool]){
    
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
    // s.fetchResults
    
    
    do {
        let result = try managedObjectContext.fetch(request)
        for data in result as! [NSManagedObject] {
            let assists = (data.value(forKey: "assists") as! Double)
            let goals = (data.value(forKey: "goals") as! Double)
            let minutes = (data.value(forKey: "minutes") as! Double)
            let temp = (data.value(forKey: "temp") as? String ?? "")
            let wind = (data.value(forKey: "wind") as? String ?? "")
            
            totalGoals += (data.value(forKey: "goals") as!  Int)
            
            totalAssists += (data.value(forKey: "assists") as! Int)
            totalMinutes += minutes
            
            
            let t = Double(temp)
            let w = Double(wind)
            if t == nil {conditions.append(true)}
            else if t! >= 16.0 && t! <= 27.0 && w! <= 5.0 {          //ideal weather for outdoor soccer
                conditions.append(true)
            }else{
                conditions.append(false)
            }
            gameContribution = (goals + assists) / minutes
            gameContributions.append(gameContribution)
        }
    } catch {
        
        print("Failed")
    }
    return (totalGoals, totalAssists, totalMinutes, gameContributions, conditions)
}
    func result() -> (String,String){
       // calcStats()
        var countImpact: Int = 0
        var countConsistent : Int = 0
        var countInconsistent : Int = 0
        var noWeatherAffect : Int = 0
        var returnPlayerType = ""
        var returnWeatherAffect = ""
        for i in 0..<gameContributions.count{
            if gameContributions[i] > 0.05{         //play good
                countImpact += 1
                if conditions[i] == false{              //in bad
                    noWeatherAffect += 1
                }
            }else if gameContributions[i] > 0.01{   //play decent
                countConsistent += 1
                if conditions[i] == false{              //in bad
                    noWeatherAffect += 1
                }
                
            }else{                                 //play bad
                countInconsistent += 1
                if conditions[i] == true{              //in good weather
                    noWeatherAffect += 1
                }
            }
        }
        //1 = impact 2=consistent 3=inconsistent ----
        if max(countImpact, countConsistent, countInconsistent) == countImpact{
            if countImpact != 0{
                returnPlayerType = "an Impact Player"
               // resultLabel.text = "an Impact Player"
            }
            
        }else if max(countImpact, countConsistent, countInconsistent) == countConsistent{
            returnPlayerType = "Consistent"
            //resultLabel.text = "Consistent"
        }else{
            returnPlayerType = "ineffective"
            //resultLabel.text = "ineffective"
        }
        
        if noWeatherAffect > conditions.count/2{           //
            returnWeatherAffect = "Does play a factor"
            //weatherResultLabel.text = "Does play a factor"
        }else if conditions.count>0{
            returnWeatherAffect = "Does notplay a factor"
            //weatherResultLabel.text = "Does not play a factor"
        }else{
            //returnWeatherAffect = "Pleas Enter Stats"
            //emptyLabel.text = "Please enter Stats by clicking on the soccer ball at the home page."
        }
        
        return (returnPlayerType, returnWeatherAffect)
    }
    
    
}
    


