//
//  OverlaySampleViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/24/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class OverlayRootViewController: UIViewController {
    
    let detailTransitioningDelegate = OverlayTransitioningDelegate()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as! OverlayViewController
        detailViewController.transitioningDelegate = detailTransitioningDelegate
        detailViewController.modalPresentationStyle = .Custom
    }
    
}

class OverlayViewController: UIViewController {
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

