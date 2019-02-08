//
//  ScaleSegue.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/16/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {

    override func perform() {
        scale()
    }
    func scale(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalcenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalcenter
        
        containerView?.addSubview(toViewController.view)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations:{ toViewController.view.transform = CGAffineTransform.identity}, completion: {success in fromViewController.present(toViewController, animated: false, completion: nil)
            
        })
        
    }
    
}
class unwindScaleSegue: UIStoryboardSegue{
    override func perform() {
        scale()
    }
    func scale(){
        let toViewController = self.destination
        let fromViewController = self.source
        fromViewController.view.superview?.insertSubview(toViewController.view , at: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations:{ fromViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)}, completion: {success in fromViewController.dismiss(animated: false, completion: nil)
            
            
        })
        
    }
    
    
}

