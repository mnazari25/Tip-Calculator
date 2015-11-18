//
//  SplitTypeViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/14/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class SplitTypeViewController: UIViewController {

	//MARK: - Outlets
	@IBOutlet weak var evenSplitButtonOutlet: UIButton!
	@IBOutlet weak var itemSplitButtonOutlet: UIButton!
	
	
	//MARK: - Variables
	var passedTip : TipInfo?
	
	//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

		evenSplitButtonOutlet.layer.cornerRadius = 6.0
		itemSplitButtonOutlet.layer.cornerRadius = 6.0
		
    }
	
	//MARK: - IBActions
	@IBAction func splitType(sender: UIButton) {
		
		switch sender.tag {
			
		case 0:
			let alert = UIAlertController(title: "Party Count", message: "Please enter the number of people in your party.", preferredStyle: .Alert)
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Number of party members"
				textField.keyboardType = UIKeyboardType.NumberPad
				
			})
			
			/* On even split requests number of people and captures results on done button */
			alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
				
				let textField = alert.textFields![0] as UITextField
				
				if let numCount = Int((textField.text)!){
					
					self.passedTip?.timesSplit = numCount
					self.passedTip?.isMutliple = true
					textField.text = ""
					if numCount != 0 {
						
						self.performSegueWithIdentifier("toTipVC", sender: self)
						
					} else {
						
						/* Error if user enters 0 people in party */
						let errorAlert = UIAlertController(title: "Invalid Input", message: "Seriously, you have 0 people in your party. Come on! Please enter the actual number of people in your party.", preferredStyle: UIAlertControllerStyle.Alert)
						errorAlert.addAction(UIAlertAction(title: "Ok fine.", style: .Default, handler: { (action) -> Void in
							
							errorAlert.dismissViewControllerAnimated(false, completion: nil)
							self.presentViewController(alert, animated: true, completion: nil)
							
						}))
						self.presentViewController(errorAlert, animated: true, completion: nil)
						
					}
					
					
				} else {
					
					/* Not a number inputted */
					/* Uses number keyboard so this should not occur unless in simulator or external keyboard used */
					let errorAlert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number.", preferredStyle: UIAlertControllerStyle.Alert)
					errorAlert.addAction(UIAlertAction(title: "Ok fine.", style: .Default, handler: { (action) -> Void in
						
						errorAlert.dismissViewControllerAnimated(false, completion: nil)
						self.presentViewController(alert, animated: true, completion: nil)
						
					}))
					
				}
				
			}))
			
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			
			self.presentViewController(alert, animated: true, completion: nil)
			
		case 1:
			performSegueWithIdentifier("toItemSplitVC", sender: sender)
		default:
			print("again not sure how you got here")
			
		}
		
	}
	
	/* Handles successful segue initiation */ 
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let tipVC = segue.destinationViewController as? TipViewController {
			
			tipVC.passedTip = self.passedTip
			tipVC.myMessage = "How much would you like to tip on your bill?\nEnter 0% if you don't want to add any gratuity."
			tipVC.fromItemVC = false
		} 
		
		if let itemSplitVC = segue.destinationViewController as? ItemizedSplitViewController {
			
			itemSplitVC.passedTip = self.passedTip
			
		}
		
	}
	

}
