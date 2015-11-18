//
//  ResultsViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/13/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UINavigationControllerDelegate {

	//MARK: - Outlets
	
	@IBOutlet weak var mealTotalLabel: UILabel!
	@IBOutlet weak var jokeLabel: UILabel!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var saveReceiptButtonOutlet: UIButton!
	@IBOutlet weak var calculateNewButtonOutlet: UIButton!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var subtotalAmount: UILabel!
	@IBOutlet weak var taxAmount: UILabel!
	@IBOutlet weak var tipAmount: UILabel!
	@IBOutlet weak var serviceChargeAmount: UILabel!
	@IBOutlet weak var totalAmount: UILabel!
	@IBOutlet weak var daTableView: UITableView!
	
	//MARK: - Variables
	var passedTip : TipInfo?
	var partyPeopleDict : [String: (array: [(name: String, cost: Double)], info: TipInfo)]? // itemized splitting only
	var peopleNames = [String]() // itemized splitting only to hold key names
	var peopleTips = [TipInfo]() // itemized splitting only to hold tip info values
	var fromItemVC : Bool = false // determines if itemized split
	
	// joke array
	var jokeList : [String] = [
	"Here's a tip! Never, under any circumstances, take a sleeping pill and a laxative on the same night.",
	"Here's a tip! Never moon a werewolf...",
	"Here's a tip! Never pet a burning dog!",
	"Here's a tip! Lose weight quickly by eating raw pork or rancid tuna. The subsequent food poisoning/diarrhea will enable you to lose 12 pounds in only 2 days.",
	"Here's a tip! Save on electricity by turning off all the lights in your house and walking around wearing a miner's hat.",
	"Here's a tip! Save on gasoline by pushing your car to your destination. Invariably passersby will think you\'ve broken down and help.",
	"Here's a tip! Drill a one inch diameter hole in your refrigerator door. This will allow you to check that the light goes off when the door is closed.",
	"Here's a tip! Old telephone directories make ideal personal address books. Simply cross out the names and address of people you don't know.",
	"Here's a tip! At work, put decaf in the coffee maker for 3 weeks. Once everyone has gotten over their caffeine addictions, switch to espresso.",
	"Here's a tip! Buy a television set exactly like your neighbors. Then annoy them by standing outside their window and changing their channel using your identical remote control.",
	"Here's a tip! Fool other drivers into thinking you have an expensive car phone by holding an old TV or video remote control up to your ear and occasionally swerving across the road.",
	"Here's a tip! Putting just the right amount of gin in your goldfish bowl makes the fishes' eyes bulge and causes them to swim in an amusing manner.",
	"Here's a tip! When the money comes out the ATM, scream \"I won!\" \"I won!\" \"3rd time this week!\"",
	"Here's a tip! No time for a bath? Wrap yourself in masking tape and remove the dirt by simply peeling it off.",
	"Here's a tip! Tip to reduce weight: First turn your head to the right and then turn it to the left. Repeat the exercise everytime you are offered something to eat.",
	"Here's a tip! To save money on expensive binoculars stand closer to what you are looking at.",
	"Here's a tip! Don't eat yellow snow!",
	"Here's a tip! Don't yell at your kids! Lean in real close and whisper, it's much scarier that way.",
	"Here's a tip! Carry things with you at all times to make yourself look busy and noone will bother you.",
	"Here's a tip! Always keep several \"Get Well\" cards on your table at home. That way when you have a visitor they will assume you have been sick and excuse the mess.",
	"Here's a tip! No matter how responsible he seems; never give your gun to a monkey.",
	"Here's a tip! If your gun misfires, never look down the barrel to inspect it. Have someone else do that for you.",
	"Here's a tip! Don't be ugly.",
	"Here's a tip! Butter is slippery. To help increase bloodflow you can lubricrate arteries and veins by eating 1 stick of butter a day.",
	"Here's a tip! Weight loss tip: Use super glue as lip gloss or chapstick.",
	"Here's a tip! Never make eye contact while eating a banana.",
	"Here's a tip! If confetti doesn't fall out of your underwear, you didn't party hard enough!"
	]
	
	
	//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/* sets joke label to random joke from array */
		let randomNum = arc4random_uniform(UInt32(jokeList.count))
		jokeLabel.text = jokeList[Int(randomNum)]
		
		// sets up UI styling
		backgroundView.layer.cornerRadius = 6.0
		saveReceiptButtonOutlet.layer.cornerRadius = 6.0
		calculateNewButtonOutlet.layer.cornerRadius = 6.0
		
		/* Determines if itemized split or not and updates UI accordingly */
		if fromItemVC == false {
			
			saveReceiptButtonOutlet.hidden = false
			updateLabels()
			
		} else {
			
			saveReceiptButtonOutlet.hidden = true
			daTableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellReuse")
			daTableView.tableFooterView = UIView(frame: CGRectZero)
			buildTable()
			
		}
		
    }
	
	//MARK: - Functions
	
	/* Update labels function used for single person tip and even split tipping */
	func updateLabels() {
		
		daTableView.hidden = true
		
		/* Takes passed tip information and set UI labels with appropriate data */
		if let tip = passedTip {
			
			if tip.isMutliple == true {
				
				saveReceiptButtonOutlet.hidden = true
				mealTotalLabel.text = "Total cost to each person"
				tip.splitBillEven()
				
			} else {
				
				saveReceiptButtonOutlet.hidden = false
				mealTotalLabel.text = "Meal Total"
				
			}
			
			let tipPercent = tip.tip * 100
			
			tipLabel.text = "\(Int(round(tipPercent)))% Tip"
			subtotalAmount.text = "$\(tip.subtotal.format(formatDouble2))"
			taxAmount.text = "$\(tip.tax.format(formatDouble2))"
			tipAmount.text = "$\(tip.tipAmount.format(formatDouble2))"
			totalAmount.text = "$\(tip.total.format(formatDouble2))"
			serviceChargeAmount.text = "$\(tip.serviceCharge.format(formatDouble2))"
			
		}
		
	}
	
	/* Function to build table for itemized splitting */
	func buildTable(){
		
		/* Uses dictionary information to build tableview */
		if let partyPeople = partyPeopleDict {
			
			daTableView.hidden = false
			for (key,value) in partyPeople {
				
				peopleNames.append(key)
				peopleTips.append(value.info)
				
			}
			
			daTableView.reloadData()
			
		} else {
			
			daTableView.hidden = true
			
		}
		
	}
	
	@IBAction func calculateNewTip(sender: AnyObject) {
		
		self.navigationController?.popToRootViewControllerAnimated(true)
		
	}
	
	/* Receipt saving only available in single person tip */
	@IBAction func saveReceipt(sender: UIButton) {
		
		/* Checks network connection and handles it according to result */
		if network.isConnectedToNetwork() {
			
			saveReceiptButtonOutlet.hidden = true
			
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
			
			/* If user is logged in requests a receipt name for saved receipt */
			if loggedIn {
				
				alert.title = "Save Receipt"
				alert.message = "Please enter a name for this receipt."
				alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
					
					textField.placeholder = "Receipt Name"
					
				})
				
				/* On alert done button captures user input and initiates cloud saving process */
				alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
					
					if network.isConnectedToNetwork() {
						
						let receiptNameField = alert.textFields![0] as UITextField
						
						if receiptNameField.text == "" {
							
							receiptNameField.text = "Restaurant Receipt"
							
						}
						
						self.passedTip?.restaurantName = receiptNameField.text
						
						let user = PFUser.currentUser()
						
						let receipt = PFObject(className:"Receipts")
						receipt["Name"] = self.passedTip?.restaurantName
						receipt["Subtotal"] = self.passedTip?.subtotal
						receipt["Tax"] = self.passedTip?.tax
						receipt["TipAmount"] = self.passedTip?.tipAmount
						receipt["Tip"] = self.passedTip?.tip
						receipt["SC"] = self.passedTip?.serviceCharge
						receipt["Total"] = self.passedTip?.total
						receipt["user"] = user
						receipt.saveInBackgroundWithBlock({
							PFBooleanResultBlock -> Void in
							let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
							
							/* Determines success or error of cloud saving and alerts user accordingly. */
							if (PFBooleanResultBlock.0) {
								
								alert.title = "Saved!"
								alert.message = "Your receipt has been saved to the cloud."
								self.presentViewController(alert, animated: true, completion: nil)
								
							} else {
								
								alert.title = "Error"
								alert.message = "Sorry. There was a problem saving this receipt. Please check your connection and try again."
								self.presentViewController(alert, animated: true, completion: nil)
								self.saveReceiptButtonOutlet.hidden = false
								
							}
							
							
						})

						
					} else {
						/* No network alert */
						let alert = network.alert()
						self.presentViewController(alert, animated: true, completion: nil)
						
					}
					
					
				}))
				
				alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
					
					self.saveReceiptButtonOutlet.hidden = false
					
				}))
				
				self.presentViewController(alert, animated: true, completion: nil)
				
			} else {
				
				/* Not logged in alert */
				self.saveReceiptButtonOutlet.hidden = false
				alert.title = "Member Feature"
				alert.message = "You must be logged in to use this feature. Please either sign in or register for an account."
				alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
				
			}
			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
		
}

/* Handles table view building */ 
extension ResultsViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if let partyPeople = partyPeopleDict {
			
			daTableView.hidden = false
			return partyPeople.count
			
		} else {
			
			daTableView.hidden = true
			return 1
			
		}
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return 75
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if let partyPeople = partyPeopleDict {
			
			let cell = daTableView.dequeueReusableCellWithIdentifier("cellReuse") as! TableViewCell
			let currentTip = peopleTips[indexPath.row]
			
			let tipPercent = currentTip.tip * 100
			let serviceChargeSplit = passedTip!.serviceCharge / Double(partyPeople.count)
			let newTotal = currentTip.total + serviceChargeSplit
			
			cell.name.text = peopleNames[indexPath.row]
			cell.tipAmount.text = "\(Int(round(tipPercent)))% Tip : $\(currentTip.tipAmount.format(formatDouble2))"
			cell.serviceAmount.text = "Service Charge : $\(serviceChargeSplit.format(formatDouble2))"
			cell.totalAmount.text = "Total Amount : $\(newTotal.format(formatDouble2))"
			
			return cell
			
		} else {
			
			return UITableViewCell()
			
		}
	
	}
	
}

