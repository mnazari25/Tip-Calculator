//
//  EditFormViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/26/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit
import Photos

class EditFormViewController: UIViewController {
	
	//MARK: - Outlets
	@IBOutlet weak var cameraButtonOutlet: UIImageView!
	@IBOutlet weak var removeImageButtonOutlet: UIButton!
	@IBOutlet weak var messageLabel: UILabel!
	
	@IBOutlet weak var activityBackgroundView: UIView!
	@IBOutlet weak var activityWheel: UIActivityIndicatorView!
	
	@IBOutlet weak var scroller: UIScrollView!
	
	@IBOutlet weak var receiptField: UITextField!
	@IBOutlet weak var subtotalField: UITextField!
	@IBOutlet weak var taxLabel: UILabel!
	@IBOutlet weak var taxField: UITextField!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var tipField: UITextField!
	@IBOutlet weak var serviceField: UITextField!
	@IBOutlet weak var totalField: UITextField!
	@IBOutlet weak var notesField: UITextView!
	

	//MARK: - Variables
	var passedTip : TipInfo?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		scroller.scrollEnabled = true
		scroller.contentSize = CGSizeMake(329, 850)
		
		cameraButtonOutlet.layer.cornerRadius = 6.0
		cameraButtonOutlet.layer.masksToBounds = true
		cameraButtonOutlet.contentMode = UIViewContentMode.ScaleToFill
		
		/* Listener for save button event notification */
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "savePressed:", name: "save", object: nil)
		
		/* UI set up */
		if let tip = passedTip {
			
			let taxPercent = tip.figureTaxPercent()
			
			tipLabel.text = "\((tip.tip * 100).format(formatDouble2))% Tip"
			taxLabel.text = "\((taxPercent * 100).format(formatDouble2))% Tax"
			
			if let image = tip.savedReceiptImage {
				
				cameraButtonOutlet.image = image
				removeImageButtonOutlet.hidden = false
				messageLabel.text = "Tap image to change photo."
				
			} else {
				
				removeImageButtonOutlet.hidden = true
				messageLabel.text = "Tap image to set a photo."
				
			}
			
			receiptField.text = tip.restaurantName
			subtotalField.text = "\(tip.subtotal.format(formatDouble2))"
			taxField.text = "\(tip.tax.format(formatDouble2))"
			tipField.text = "\(tip.tipAmount.format(formatDouble2))"
			serviceField.text = "\(tip.serviceCharge.format(formatDouble2))"
			totalField.text = "\(tip.total.format(formatDouble2))"
			
			if let notes = tip.notes {
				
				notesField.text = notes
				
			}
			
		} else {
			
			print("tip not passed")
			
		}
		
    }
	
	/* Handles removing saved receipt image */
	@IBAction func removeImage(sender: AnyObject) {
		
		if let tip = passedTip {
			
			tip.savedReceiptImage = nil
			let defaultImage = UIImage(named: "Camera")
			cameraButtonOutlet.image = defaultImage
			removeImageButtonOutlet.hidden = true
			messageLabel.text = "Tap image to set a photo."
			
			let pictureData = NSData(data: UIImagePNGRepresentation(defaultImage!)!)
			_ = PFFile(name: "Camera.png", data: pictureData)
			
			let query = PFQuery(className: "Receipts")
			query.getObjectInBackgroundWithId(tip.objectID!) {
				PFObjectResultBlock -> Void in
				if PFObjectResultBlock.1 != nil {
					print(PFObjectResultBlock.1)
				} else {
					
					PFObjectResultBlock.0!["picture"] = NSNull()
					PFObjectResultBlock.0!.saveInBackground()
					
				}
				
			}

			
		}
		
	}
	
	/* Runs when notification is sent from save button and handles updating object values in the cloud */
	func savePressed(notification : NSNotification) {
		
		if network.isConnectedToNetwork() {

			let user = PFUser.currentUser()
			
			if let tip = passedTip {
				activityBackgroundView.hidden = false
				activityWheel.startAnimating()
				
				let receipt = PFQuery(className: "Receipts")
				receipt.getObjectInBackgroundWithId(tip.objectID!) {
					PFObjectResultBlock -> Void in
					if PFObjectResultBlock.1 != nil {
						print(PFObjectResultBlock.1!)
					} else {
						
						PFObjectResultBlock.0!["Name"] = self.receiptField.text
						PFObjectResultBlock.0!["Subtotal"] = self.subtotalField.text!.double()
						PFObjectResultBlock.0!["Tax"] = self.taxField.text!.double()
						PFObjectResultBlock.0!["TipAmount"] = self.tipField.text!.double()
						PFObjectResultBlock.0!["Tip"] = self.tipField.text!.double()
						PFObjectResultBlock.0!["SC"] = self.serviceField.text!.double()
						PFObjectResultBlock.0!["Total"] = self.totalField.text!.double()
						PFObjectResultBlock.0!["Notes"] = self.notesField.text
						PFObjectResultBlock.0!["user"] = user
						PFObjectResultBlock.0!.saveInBackgroundWithBlock({
							PFBooleanResultBlock -> Void in
							let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
								
								self.dismissViewControllerAnimated(true , completion: { () -> Void in
									self.dismissViewControllerAnimated(true , completion: nil)
								})
								
							}))
							
							if (PFBooleanResultBlock.0) {
								
								self.activityBackgroundView.hidden = true
								self.activityWheel.stopAnimating()
								
								alert.title = "Updated Receipt!"
								alert.message = "Your receipt has been saved to the cloud."
								self.presentViewController(alert, animated: true, completion: nil)
								
							} else {
								
								self.activityBackgroundView.hidden = true
								self.activityWheel.stopAnimating()
								
								alert.title = "Error"
								alert.message = "Sorry. There was a problem saving this receipt. Please check your connection and try again."
								self.presentViewController(alert, animated: true, completion: nil)
								
							}
							
							
						})
						
					}
					
				}
					
			}
			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
	

	/* Handles photo input for receipt image */
	
    ////* NOTE *////
	/* Taking a photo does not work on a simulator and on devices that do not a have a built in camera. */
	/* I have handled this by alerting the user that this is the case. The only option on those types of devices
		is to choose an existing photo using the image library. */
	
	@IBAction func openPhotoLibrary(sender: UITapGestureRecognizer) {
		
		let photoPicker = UIImagePickerController()
		photoPicker.delegate = self
		
		let actionSheet = UIAlertController(title: "Please select your preferred method.", message: nil, preferredStyle: .ActionSheet)
		
		actionSheet.addAction(UIAlertAction(title: "Take new photo", style: .Default, handler: { (action) -> Void in
			
			if UIImagePickerController.isSourceTypeAvailable(.Camera) {
				
				photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
				photoPicker.allowsEditing = true
				
				self.presentViewController(photoPicker, animated: true, completion: nil)
				
			} else {
				
				let alert = UIAlertController(title: "Service not available", message: "This service is not available for simulators and devices without a camera. Please choose an existing photo or try a different device.", preferredStyle: .Alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
				
			}
			
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Choose from library", style: .Default, handler: { (action) -> Void in
			
			print("From library")
			photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			
			self.presentViewController(photoPicker, animated: true, completion: nil)
			
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
		
		self.presentViewController(actionSheet, animated: true , completion: nil)
		
	}
	
}

/* Extension to handle image selection or photo being taken */
/* Saves either result to the cloud */ 
extension EditFormViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
	
		if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			cameraButtonOutlet.image = picture
			removeImageButtonOutlet.hidden = false
			messageLabel.text = "Tap image to change photo."
			
			let pictureData = NSData(data: UIImagePNGRepresentation(picture)!)
			let parseFile = PFFile(name: "receipt.png", data: pictureData)
			
			let query = PFQuery(className:"Receipts")
			query.getObjectInBackgroundWithId(passedTip!.objectID!) {
				PFObjectResultBlock -> Void in
				if PFObjectResultBlock.1 != nil {
					print(PFObjectResultBlock.1)
				} else {
					
					PFObjectResultBlock.0!["picture"] = parseFile
					PFObjectResultBlock.0!.saveInBackground()
					
				}
			}
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
		}
		
	}
	
}
