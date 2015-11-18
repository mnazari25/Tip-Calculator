//
//  SecondViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/10/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: - Outlets
	@IBOutlet weak var daTableView: UITableView!
	
	//MARK: - Variables
	var mySampleArray = [AnyObject]()
	var tipInfos = [TipInfo]()
	var selectedReceipt = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.grayColor(),NSFontAttributeName: UIFont(name: "Noteworthy", size: 22)!]
		
		self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
		self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
		
	}
	
	override func viewDidAppear(animated: Bool) {
	
		/* If network available attempts to gather data from cloud and populate table view */
		if network.isConnectedToNetwork() {
			
			getData()
			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
	
	/* Handles cloud retrieval and setting up array for table view data */
	func getData() {
		
		let currentUser = PFUser.currentUser()
		tipInfos = []
		
		if currentUser != nil {
			
			let query = PFQuery(className: "Receipts")
			query.whereKey("user", equalTo: currentUser!)
			mySampleArray = query.findObjects()!
			
			for item in mySampleArray {
				
				let thisTip = TipInfo()
				thisTip.restaurantName = item["Name"] as? String
				thisTip.subtotal = item["Subtotal"] as! Double
				thisTip.tax = item["Tax"] as! Double
				thisTip.tipAmount = item["TipAmount"] as! Double
				thisTip.tip = item["Tip"] as! Double
				thisTip.serviceCharge = item["SC"] as! Double
				thisTip.total = item["Total"] as! Double
				
				if let notes = item["Notes"] as? String  {
					
					thisTip.notes = notes
					
				}
				
				if let userImageFile = item["picture"] as? PFFile {
					
					userImageFile.getDataInBackgroundWithBlock {
						
						(PFDataResultBlock) -> Void in
						
						if PFDataResultBlock.1 == nil {
							
							thisTip.savedReceiptImage = UIImage(data: PFDataResultBlock.0!)
							
						} else {
							
							print("error")
							
						}
						
					}
					
				}
				
				thisTip.objectID = item.objectId
				
				tipInfos.append(thisTip)
				
			}
			
			daTableView.reloadData()
			
		} else {
			
			mySampleArray = []
			
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
			alert.title = "Member Feature"
			alert.message = "You must be logged in to use this feature. Please either sign in or register for an account."
			alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)

			daTableView.reloadData()
			
		}
		
	}

	
	/* Table view set up */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mySampleArray.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("cellReuse")! as UITableViewCell
		
		cell.textLabel?.text = mySampleArray[indexPath.row]["Name"] as? String
		
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		selectedReceipt = indexPath.row
		performSegueWithIdentifier("toDetailVC", sender: self)
		
	}
	
	
	/* Handles successful segue initiation */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let detailVC = segue.destinationViewController as? DetailViewController {
			
			detailVC.passedTip = tipInfos[selectedReceipt]

		}
		
	}
	
}

