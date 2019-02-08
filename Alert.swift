//
//  Alert.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/17/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import Foundation
import UIKit

class Alert : NSObject{
    
    static func showBasicAlert(on vc: ViewController, with title: String, message: String , actionName: String) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let delete = UIAlertAction(title: actionName, style: .default, handler: { action in
            let s = GameStats()
            s.deleteAll()
            vc.self.matchTable.reloadData()
            vc.self.matchTable.tableFooterView = UIView(frame: .zero)
        })
        
        let ok = UIAlertAction(title: actionName, style: .default, handler: nil)
        
        if actionName == "Delete All"{
            alert.addAction(delete)
        }else{
            alert.addAction(ok)
        }
        
        alert.addAction(cancel)
        
        vc.present(alert, animated: true)
    }
    
    
}

