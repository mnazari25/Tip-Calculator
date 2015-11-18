//
//  DetailViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/23/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	//MARK: - Outlets
	@IBOutlet weak var containerView: UIView!
	
	var passedTip : TipInfo?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if let tip = passedTip {
			
			print(tip.objectID)
			
		}
		
    }
	
	/* sends notification to edit form view controller when save button is pressed */
	@IBAction func saveItems(sender: AnyObject) {
		
		NSNotificationCenter.defaultCenter().postNotificationName("save", object: nil, userInfo: nil)
		
	}
	
	
	/* Handles successful segue initiation */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let containerVC = segue.destinationViewController as? EditFormViewController {
			
			containerVC.passedTip = self.passedTip
			
		}
		
	}

}
