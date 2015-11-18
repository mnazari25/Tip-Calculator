//
//  ItemizedSplitViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/15/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class ItemizedSplitViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	
	//MARK: - Outlets
	@IBOutlet weak var personName: UITextField!
	@IBOutlet weak var daCollectionView: UICollectionView!
	@IBOutlet weak var nextButtonOutlet: UIButton!
	@IBOutlet weak var doneButtonOutlet: UIButton!
	@IBOutlet weak var doneButtonBackground: UIView!
	@IBOutlet weak var editPeopleButtonOutlet: UIButton!
	
	//MARK: - Variables
	var items = 1;
	var passedTip : TipInfo?
	var thisPersonTip = TipInfo()
	var taxPercent : Double = 0
	var inputtedItems = [String]()
	var inputtedItemCosts = [Double]()
	var itemTupleArray : [(name: String, cost: Double)] = []
	var partyPeople : Dictionary<String , (array: [(name: String, cost: Double)], info: TipInfo)> = Dictionary<String , (array: [(name: String, cost: Double)], info: TipInfo)>()
	var currentField : UITextField?
	
	
	//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		nextButtonOutlet.layer.cornerRadius = 6.0
		editPeopleButtonOutlet.layer.cornerRadius = 6.0
		
		if let tip = passedTip {
			
			taxPercent = tip.figureTaxPercent()
			
		}
		
    }
	
	
	
	/* Used to dismiss text field on touching the outside view */
	/* doesn't work when tapping collection view */
//	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//		if let field = currentField {
//			
//			field.resignFirstResponder()
//			
//		}
//	}
	
	/* Determines if a user has already been added */
	/* Not currently implemented but will set edit party members to true */
	override func viewWillAppear(animated: Bool) {
		
		let partyDict = partyPeople
		
		if partyDict.count > 0 {
			
			editPeopleButtonOutlet.hidden = false
			
		} else if partyDict.count <= 0 {
			
			// editPeopleButtonOutlet.hidden = true
			
		}
	
	}
	
	/* collection view set up */
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return items
		
	}
	
	// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		if let cell = daCollectionView.dequeueReusableCellWithReuseIdentifier("cellReuse", forIndexPath: indexPath) as?itemizedCollectionViewCell {
			
			cell.itemCostField.delegate = self
			cell.itemField.delegate = self
			
			cell.itemField.tag = indexPath.row
			cell.itemCostField.tag = indexPath.row
			
			if inputtedItems.count != indexPath.row && inputtedItemCosts.count != indexPath.row{
				
				cell.itemField.text = inputtedItems[indexPath.row]
				cell.itemCostField.text = "\(inputtedItemCosts[indexPath.row].format(formatDouble2))"
				
			} else {
				
				cell.itemField.text = ""
				cell.itemCostField.text = ""
				
			}

			cell.itemField.placeholder = "Item \(indexPath.row + 1) name"
			
			return cell
			
		} else {
			
			return UICollectionViewCell()
			
		}
		
	}
	
	/* Handles adding additional cells to collection view */
	@IBAction func addItemButton(sender: UIButton) {
		
		if inputtedItemCosts.count == inputtedItems.count && (inputtedItemCosts.count != 0 && inputtedItems.count != 0) && inputtedItemCosts.count == daCollectionView.numberOfItemsInSection(0) && inputtedItems.count == daCollectionView.numberOfItemsInSection(0){
			
			items += 1
			daCollectionView.reloadData()
			
		}
		
		
	}
	
	/* custom done button for number pad keyboard */
	@IBAction func doneButton(sender: UIButton) {
		
		if let textField = currentField {
			
			textField.resignFirstResponder()
			
		}
		
	}
	
	/* Handles next button functionality */
	/* Checks to make sure all fields have been entered with valid information */
	@IBAction func nextButton(sender: UIButton) {
		
		/* makes sure at least one full item has been entered with name and cost */
		if inputtedItems.count == 0 || inputtedItemCosts.count == 0{
			
			let alert = UIAlertController(title: "No items entered", message: "You must enter at least one item for this person.", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title:"Ok", style: .Cancel, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			
		} else {
			
			let person = (personName.text)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			
			if person == "" {
				
				let alert = UIAlertController(title: "No name entered", message: "You must enter a name for this person.", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title:"Ok", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
				
			} else {
				
				itemTupleArray = []
				
				for var i = 0; i < min(inputtedItems.count, inputtedItemCosts.count); i++ {
					
					itemTupleArray.insert((inputtedItems[i], inputtedItemCosts[i]), atIndex: i)
					
				}
				
				let itemsSubtotal = inputtedItemCosts.reduce(0, combine: {$0 + $1})
				thisPersonTip.taxPercent = taxPercent
				thisPersonTip.subtotal = itemsSubtotal
				thisPersonTip.calculateTax()
				
				let oldValue = partyPeople.updateValue((itemTupleArray, thisPersonTip), forKey: personName.text!)
				
				if let savedValue = oldValue {
					
					partyPeople[personName.text!]!.info.tip = savedValue.info.tip
					
				}
				
				performSegueWithIdentifier("toTipVC", sender: sender)
				
			}
			
		}
		
	}
	
	/* Handles successful segue initiation */ 
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let tipVC = segue.destinationViewController as? TipViewController {
			
			let tipToPass = self.partyPeople[personName.text!]!
			
			tipVC.passedTip = tipToPass.info
			tipVC.totalBillInfo = self.passedTip
			tipVC.partyPeopleDict = self.partyPeople
			tipVC.partyPersonValue = self.partyPeople[personName.text!]
			tipVC.personKey = self.personName.text
			tipVC.myMessage = "How much would you \(personName.text) like to tip on their bill?\nEnter 0% if you don't want to add any gratuity."
			tipVC.fromItemVC = true 
			
		}
		
	}
	
	/* Captures data on return to this view controller via add person button on tip view controller */
	@IBAction func unwindFromTipVC(segue : UIStoryboardSegue) {
		
		let tipVC = segue.sourceViewController as! TipViewController
		partyPeople.updateValue(tipVC.partyPersonValue!, forKey: tipVC.personKey!)
		thisPersonTip = TipInfo()
		inputtedItemCosts = []
		inputtedItems = []
		itemTupleArray = []
		items = 1
		daCollectionView.reloadData()
		personName.placeholder = "Person \(partyPeople.count + 1) Name"
		personName.text = ""
		
	}

}


/* Handles text fields and determines when editing ends and captures values to be sent to appropiate array. */
extension ItemizedSplitViewController : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
		
	}

	func textFieldDidBeginEditing(textField: UITextField) {
		
		currentField = textField
		
		switch textField.keyboardType {
			
		case UIKeyboardType.DecimalPad:
			doneButtonBackground.hidden = false
			doneButtonOutlet.hidden = false
		default:
			doneButtonBackground.hidden = true
			doneButtonOutlet.hidden = true
			
		}
		
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		
		doneButtonBackground.hidden = true
		doneButtonOutlet.hidden = true
		
		let tag = textField.tag

		switch textField.keyboardType {
			
		case UIKeyboardType.DecimalPad:
			if let cost = textField.text!.double() {
				
				if inputtedItemCosts.count > tag {
					
					inputtedItemCosts.removeAtIndex(tag)
					
				}
				
				inputtedItemCosts.insert(cost, atIndex: tag)
				print("cost added")
				print(inputtedItemCosts.count)
				
			} else {
				
				if textField.text != "" {
					
					let alert = UIAlertController(title: "Invalid Cost", message: "Please enter a valid item cost.", preferredStyle: UIAlertControllerStyle.Alert)
					alert.addAction(UIAlertAction(title:"Ok", style: .Cancel, handler: nil))
					self.presentViewController(alert, animated: true, completion: nil)
					
				}
				
			}

		default:
			
			if textField.text != "" {
				
				if inputtedItems.count > tag {
					
					inputtedItems.removeAtIndex(tag)
					
				}
				inputtedItems.insert(textField.text!, atIndex: tag)
				
			}
			
		}
		
		
	}
	
}
