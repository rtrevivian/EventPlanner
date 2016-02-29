//
//  MessageViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/21/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit
import MessageUI

class MessageViewController: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {
    
    lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "didTapDoneButton:")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "didTapCancelButton:")
//        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    
    func didTapdoneButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapDonelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Message view delegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        print("AA")
    }

}
