//
//  InputViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/12/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
	
	
	//MARK: - Outlets
	@IBOutlet weak var personImage: UIImageView!
	@IBOutlet weak var messageText: UILabel!
	@IBOutlet weak var subtotalField: UITextField!
	@IBOutlet weak var taxField: UITextField!
	@IBOutlet weak var serviceChargeField: UITextField!
	@IBOutlet weak var nextButtonOutlet: UIButton!
	@IBOutlet weak var doneButtonOutlet: UIButton!
	@IBOutlet weak var doneBackground: UIView!
	@IBOutlet weak var inputBackground: UIView!
	
	//MARK: - Variables
	var thisImage : UIImage?
	var thisMessage : String?
	
	var isMultiple : Bool = false // determines if this is a multi person tip or not
	
	// empty strings to hold input values
	var subtotalString = ""
	var taxString = ""
	var serviceString = ""
	
	var currentField : UITextField? // stores current text field that is selected

	
	//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.navigationBarHidden = false
		
		// sets up UI image and text
		if let newImage = thisImage {
			
			personImage.image = newImage
			
		}
		
		if let newMessage = thisMessage {

			messageText.text = newMessage
			
		}
		
		nextButtonOutlet.layer.cornerRadius = 6.0
		
    }
	
	override func viewDidAppear(animated: Bool) {
		
		// when view appears enters into text editing automatically
		subtotalField.becomeFirstResponder()
		
	}

	
	//MARK: - Functions
	
	@IBAction func returnButton(sender: UIButton) {

		let alert = UIAlertController(title: "Invalid Entry", message: "Please make sure that all the information entered is correct.", preferredStyle: .Alert)
		
		alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
		
		
		// trims all whitespace from entered field text and assigns value to temporary string holder
		subtotalString = (subtotalField.text)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		taxString = (taxField.text!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		serviceString = (serviceChargeField.text!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		
		// sets text field value to match new string without whitespace
		subtotalField.text = subtotalString
		taxField.text = taxString
		serviceChargeField.text = serviceString
		
		// checks to see if service charge field has no value or if it cannot be converted to a double value
		if serviceString != "" &&
			serviceString.double() == nil {
			
			self.presentViewController(alert, animated: true, completion: nil)
			return
				
		} else if serviceString == ""{
			
			serviceString = "0"
			serviceChargeField.text = serviceString
			
		}
		
		// checks if all fields are convertible to double value
		// failure will result in an alert to the user
		if let subtotal = subtotalString.double() {
			
			if let _ = taxString.double() {
				
				if let _ = serviceString.double() {
					
					// makes sure that a subtotal greater than 0 has been entered
					if subtotal != 0 {
						
						if isMultiple {
							
							self.performSegueWithIdentifier("toMultiVC", sender: sender)
							
						} else {
							
							self.performSegueWithIdentifier("toTipVC", sender: sender)
							
						}

					} else {
						
						/* Alerts user for the nice try of entering 0 into the subtotal field. Also, corrects them in the error of their ways. */
						let subtotalAlert = UIAlertController(title: "Subtotal Error", message: "Your tip on a 0 dollar subtotal is 0 dollars. Now go away! You must have a subtotal amount greater than 0.", preferredStyle: .Alert)
						subtotalAlert.addAction(UIAlertAction(title: "Ok, Fine", style: .Cancel, handler: nil))
						self.presentViewController(subtotalAlert, animated: true, completion: nil)
						
					}
					
				} else {
					
					self.presentViewController(alert, animated: true, completion: nil)
					return
					
				}
				
				
			} else {
				
				self.presentViewController(alert, animated: true, completion: nil)
				return
				
			}
			
			
		} else {
			
			self.presentViewController(alert, animated: true, completion: nil)
			return
			
		}
		
		
	}
	
	/* Handles tapping the screen to dismiss text field when text field is active */
	@IBAction func dismissField(sender: UITapGestureRecognizer) {
	
		if let field = currentField{
			
			field.resignFirstResponder()
			
		}
		
	}
	
	/* Handles text field custom button for number pad done button */
	@IBAction func Done(sender: UIButton) {
		
		if let field = currentField {
			
			field.resignFirstResponder()
			
			switch field.tag {
				
			case 0:
				taxField.becomeFirstResponder()
			case 1:
				serviceChargeField.becomeFirstResponder()
			default:
				returnButton(sender)
				
			}
			
		}
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		// creates tip class object to be passed ahead to next view controller
		let passingClass = TipInfo(subtotal: subtotalString.double()!, tax: taxString.double()!, serviceCharge: serviceString.double()!)
		
		// checks the type of tip that is being calculated and assigns information accordingly
		if !isMultiple {
			
			if let tipVC = segue.destinationViewController as? TipViewController {
				
				tipVC.myMessage = "How much would you like to tip on your bill?\nEnter 0% if you don't want to add any gratuity."
				tipVC.passedTip = passingClass
				tipVC.fromItemVC = false
				
			}
			
		} else {
			
			if let splitVC = segue.destinationViewController as? SplitTypeViewController {
				
				splitVC.passedTip = passingClass
				
			}
			
		}
	
	}

	
}

// text field handling
extension InputViewController : UITextFieldDelegate {
	
	/* Sets appropiate button text depending on which text field is active */
	func textFieldDidBeginEditing(textField: UITextField) {
		
		switch textField.tag {
			
		case 0,1:
			doneButtonOutlet.setAttributedTitle(NSAttributedString(string: "Next"), forState: .Normal)
		case 2:
			doneButtonOutlet.setAttributedTitle(NSAttributedString(string: "Done"), forState: .Normal)
		default:
			print("Come on!")
			
		}
		
		/* Hides appropiate UI elements */
		inputBackground.hidden = false
		doneButtonOutlet.hidden = false
		doneBackground.hidden = false
		currentField = textField
		
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		
		/* Unhides appropiate UI elements */ 
		inputBackground.hidden = true
		doneButtonOutlet.hidden = true
		doneBackground.hidden = true 
		currentField = nil
		
	}
	
}
















