//
//  ObjectDataSource.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/17/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import UIKit
import CoreData

class ObjectDataSource: NSObject, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        let s = GameStats()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
        
        var fetchResults = ((try? s.managedObjectContext.fetch(fetchRequest)) as? [StatsEntity])!
        
        if editingStyle == .delete{
            // delete the selected object from the managed
            // object context
            s.managedObjectContext.delete(fetchResults[indexPath.row])
            // remove it from the fetch results array
            fetchResults.remove(at:indexPath.row)
            
            do {
                // save the updated managed object context
                try s.managedObjectContext.save()
            } catch {
            }
            // reload the table after deleting a row
            let notificationNme = NSNotification.Name("NotificationIdf")
            NotificationCenter.default.post(name: notificationNme, object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = GameStats()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
        
        let fetchResults = ((try? s.managedObjectContext.fetch(fetchRequest)) as? [StatsEntity])!
        return fetchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 110
        let s = GameStats()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MatchTableViewCell
        cell.layer.borderWidth = 1.0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsEntity")
        
        let fetchResults = ((try? s.managedObjectContext.fetch(fetchRequest)) as? [StatsEntity])!
        
        cell.dateLabel?.text = fetchResults[indexPath.row].date
        //goals
        cell.goalsLabel?.text = fetchResults[indexPath.row].goals.description
        //assists
        cell.assistLabel?.text = fetchResults[indexPath.row].assists.description
        //minutes
        cell.minLabel?.text = fetchResults[indexPath.row].minutes.description
        
        if let picture = fetchResults[indexPath.row].matchpicture {
            cell.matchImage.image = UIImage(data: picture as Data)
        } else {
            cell.matchImage.image = UIImage(named: "maybe.jpg")
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor .darkGray
        cell.selectedBackgroundView = backgroundView
    
        return cell
    }
   
}
