//
//  TipViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/12/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit



class TipViewController: UIViewController {

	
	//MARK: - Outlets
	@IBOutlet weak var tipMessage: UILabel!
	@IBOutlet weak var tipInput: UITextField!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var daSlider: UISlider!
	@IBOutlet weak var tipUpdate: UILabel!
	@IBOutlet weak var nextButtonOutlet: UIButton!
	@IBOutlet weak var addPersonButton: UIButton!
	@IBOutlet weak var daSegment: UISegmentedControl!
	
	//MARK: - Variables
	var myMessage : String?
	var passedTip : TipInfo? // will hold passed tip
	var totalBillInfo : TipInfo? // if itemized split this will hold total bill information
	var personKey : String? // itemized split person key for accessing dictionary
	var partyPersonValue : (array: [(name: String, cost: Double)], info: TipInfo)? // itemized splitting only
	var partyPeopleDict : [String: (array: [(name: String, cost: Double)], info: TipInfo)]? // itemized splitting only
	var firstTimeHere = true // bool to catch first visit to this view controller
	var fromItemVC = false // will determine if itemized split
	
	
	//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

		/* Sets up UI message text and element styles */
		if let thisMessage = myMessage {
			
			tipMessage.text = thisMessage
			
		} else {
			
			print("No message passed")
			
		}
		
		daSlider.maximumTrackTintColor = UIColor.grayColor()
		backgroundView.layer.cornerRadius = 6.0
		nextButtonOutlet.layer.cornerRadius = 6.0
		
		/* sets tip amount and calls function to update slider value and UI */
		if let tip = passedTip {
			
			daSlider.value = Float(tip.tip * 100)
			
		}
		tipSlider(daSlider)
		firstTimeHere = true // first time
		
    }
	
	override func viewDidAppear(animated: Bool) {
		
		if let tip = passedTip {
			
			/* Handles even split tips and sets value back to normal */
			/* This is important to determine if back button was pressed then data needs to be set back to normal */
			if tip.timesSplit != 0 && firstTimeHere != true {
				
				tip.backToNormal()
				
			}
			firstTimeHere = false // sets first time to false
			
		}
		
		/* Used to determine if this is an itemized split and updates UI accordingly */
		if fromItemVC == true {
			
			addPersonButton.layer.cornerRadius = 6.0
			addPersonButton.hidden = false
			
		} else {
			
			addPersonButton.layer.cornerRadius = 6.0
			addPersonButton.hidden = true
			
		}
		
	}
	
	//MARK: - IBActions
	
	/* Handles slider updating */
	@IBAction func tipSlider(sender: UISlider) {
		
		daSlider.value = ceilf(sender.value)
		
		/* Updates UI to match slider information */
		passedTip?.tip = Double(ceilf(sender.value) / 100)
		let tip = passedTip?.calculateTip()
		tipInput.text = "\(Int(daSlider.value))%"
		tipUpdate.text = "\(Int(daSlider.value))% Tip: $\(tip!.format(formatDouble2))"
		
		/* Switch to determine if slider value is equal to segmented control value and if it is highlights appropriate segment */
		switch daSlider.value {
			
		case 15.0:
			daSegment.selectedSegmentIndex = 0
		case 18.0:
			daSegment.selectedSegmentIndex = 1
		case 20.0:
			daSegment.selectedSegmentIndex = 2
		default:
			daSegment.selectedSegmentIndex = UISegmentedControlNoSegment
			
		}
	
	}
	
	/* handles segment changes */
	@IBAction func changeSegment(sender: UISegmentedControl) {
		
		switch sender.selectedSegmentIndex {
			
		case 0:
			daSlider.value = 15
		case 1:
			daSlider.value = 18
		case 2:
			daSlider.value = 20
		default:
			print("none selected")
			
		}
		
		tipSlider(daSlider) // calls slider update to update UI
		
	}
	
	/* Handles tipping before or after tax switch */
	@IBAction func tipBeforeTaxBool(sender: UISwitch) {
		
		/* Sets bool for beforeTax and updates UI by calling slider update function */
		if let tipBool = passedTip?.beforeTax {
			
			passedTip?.beforeTax = !tipBool
			tipSlider(daSlider)
			
		}
		
	}
	
	/* Add person */
	/* Only visible on itemized tip */
	@IBAction func addPerson(sender: UIButton) {

		/* Updates dictionary value to reflect changes */
		/* This will be sent back to itemized person input */
		if let partyPerson = partyPersonValue {
			
			partyPerson.info.tip = passedTip!.tip
			
		}
		self.navigationController?.popViewControllerAnimated(true)
		
	}
	
	/* Handles next button to results page */
	@IBAction func nextButton(sender: UIButton) {

		var totalPeopleCost = 0.0
		
		/* Determines if an itemized split */
		if fromItemVC {
			
			/* Checks to make sure inputted items subtotal matches subtotal for total bill before allowing segue */
			for (_,value) in partyPeopleDict! {
				
				print(value.array)
				
				for item in value.array {
					
					totalPeopleCost += item.cost
					
				}
				
			}
			
			print(totalPeopleCost)
			
			if totalPeopleCost == totalBillInfo?.subtotal {
				
				partyPeopleDict!.updateValue(partyPersonValue!, forKey: personKey!)
				performSegueWithIdentifier("toResultsVC", sender: sender)
				
			} else {
				
				let alert = UIAlertController(title: "Items don't add up!", message: "The subtotal amount of the items entered does not match the whole bill subtotal. Please check the information you entered. \nBill Subtotal: $\(totalBillInfo!.subtotal.format(formatDouble2))\nItems Subtotal: $\(totalPeopleCost.format(formatDouble2))", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title:"Ok", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
				
			}
			
		} else {
			
			performSegueWithIdentifier("toResultsVC", sender: sender)
			
		}
		
	}
	
	/* Handles data passing on successful segue initiation */ 
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let resultsVC = segue.destinationViewController as? ResultsViewController {
			
			if let total = totalBillInfo {
				
				resultsVC.passedTip = total
				resultsVC.partyPeopleDict = self.partyPeopleDict
				
			} else {
				
				resultsVC.passedTip = self.passedTip
				
			}
			resultsVC.fromItemVC = self.fromItemVC
			
			
		}
		
	}
	
}
