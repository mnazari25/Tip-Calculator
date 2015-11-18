//
//  ManageAccountViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/15/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

var loggedIn = false

class ManageAccountViewController: UIViewController {

	@IBOutlet weak var loginButtonOutlet: UIButton!
	@IBOutlet weak var registerButtonOutlet: UIButton!
	@IBOutlet weak var logoutButton: UIButton!
	@IBOutlet weak var editThemeButton: UIButton!
	@IBOutlet weak var changePassButton: UIButton!
	@IBOutlet weak var backgroundView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		loginButtonOutlet.layer.cornerRadius = 6.0
		registerButtonOutlet.layer.cornerRadius = 6.0
		logoutButton.layer.cornerRadius = 6.0
		changePassButton.layer.cornerRadius = 6.0
		editThemeButton.layer.cornerRadius = 6.0
		backgroundView.layer.cornerRadius = 6.0
		
		let currentUser = PFUser.currentUser()
		if currentUser != nil {
			
			loggedIn = true
			self.loginButtonOutlet.hidden = true
			self.registerButtonOutlet.hidden = true
			self.logoutButton.hidden = false
			self.logoutButton.enabled = true
			
		} else {
			
			changePassButton.hidden = true
			
		}
		
    }
	
	/* Change password */
	/* Not currently working password is read only from parse and results as nil. */
	@IBAction func changePass(sender: AnyObject) {
		
		if network.isConnectedToNetwork() {
			
			if loggedIn {
				
				let alert = UIAlertController(title: "Login", message: "Please enter your username and password.", preferredStyle: .Alert)
				
				alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
					
					textField.placeholder = "Old Password"
					textField.secureTextEntry = true
					
				})
				
				alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
					
					textField.placeholder = "New Password"
					textField.secureTextEntry = true
					
				})
				
				alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
					
					textField.placeholder = "Confirm Password"
					textField.secureTextEntry = true
					
				})
				
				alert.addAction(UIAlertAction(title: "Change Password", style: .Default, handler: { (action) -> Void in
					
					let oldField = alert.textFields![0] as UITextField
					let newPassField = alert.textFields![1] as UITextField
					let confirmNewPassField = alert.textFields![2] as UITextField
					
					let currentUser = PFUser.currentUser()
					
					if oldField.text == "\(currentUser!.password)" {
						
						if newPassField.text == confirmNewPassField.text  && newPassField.text != ""{
							
							currentUser!.password = newPassField.text
							let alert = UIAlertController(title: "Password Updated.", message: nil, preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
							
						} else {
							
							let alert = UIAlertController(title: "New passwords don't match.", message: "Please check your input.", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
								
								self.dismissViewControllerAnimated(false , completion: { () -> Void in
									
									self.presentViewController(alert, animated: true, completion: nil)
									
								})
								
							}))
							
							self.presentViewController(alert, animated: true , completion: nil)
							
						}
						
					} else {
						
						let alert = UIAlertController(title: "Current password doesn't match", message: "The password you entered for the current password doesn't match our records. Please check your input and try again.", preferredStyle: .Alert)
						alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
							
							self.dismissViewControllerAnimated(false , completion: { () -> Void in
								
								self.presentViewController(alert, animated: true, completion: nil)
								
							})
							
						}))
						
						self.presentViewController(alert, animated: true , completion: nil)
						
					}
					
					
				}))
				
				alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
				
				self.presentViewController(alert, animated: true, completion: nil)
				
			}
			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
	
	/* Log in functionality */
	@IBAction func loginButton(sender: AnyObject) {
		
		if network.isConnectedToNetwork() {
			
			let alert = UIAlertController(title: "Login", message: "Please enter your username and password.", preferredStyle: .Alert)
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Username"
				
			})
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Password"
				textField.secureTextEntry = true
				
			})
			
			alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
				
				let userField = alert.textFields![0] as UITextField
				let passField = alert.textFields![1] as UITextField
				
				self.loginUser(userField.text!, password:passField.text!, alert: alert)
				
			}))
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			
			self.presentViewController(alert, animated: true, completion: nil)

			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
	
	/* Register functionality  */ 
	@IBAction func registerButton(sender: AnyObject) {
		
		if network.isConnectedToNetwork() {
			
			let alert = UIAlertController(title: "Registration", message: "Please fill in the following fields to complete registration", preferredStyle: .Alert)
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Username"
				
			})
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Password"
				textField.secureTextEntry = true
				
			})
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Confirm Password"
				textField.secureTextEntry = true
				
			})
			
			alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
				
				textField.placeholder = "Email Address"
				
			})
			
			alert.addAction(UIAlertAction(title: "Register", style: .Default, handler: { (action) -> Void in
				
				self.loginButtonOutlet.enabled = false
				self.registerButtonOutlet.enabled = false
				
				let userField = alert.textFields![0] as UITextField
				let passField = alert.textFields![1] as UITextField
				let confirmPassField = alert.textFields![2] as UITextField
				let emailField = alert.textFields![3] as UITextField
				
				if passField.text == confirmPassField.text {
					
					let newUser = PFUser()
					newUser.username = userField.text
					newUser.password = passField.text
					newUser.email = emailField.text
					
					newUser.signUpInBackgroundWithBlock{
						
						(PFBooleanResultBlock) -> Void in
						if PFBooleanResultBlock.1 == nil {
							
							self.loginUser(userField.text!, password: passField.text!, alert: alert)
							
						} else {
							
							self.loginButtonOutlet.enabled = true
							self.registerButtonOutlet.enabled = true
							print("failed")
							
						}
						
					}
					
					
				}
				
			}))
			
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			
			self.presentViewController(alert, animated: true, completion: nil)
			
		} else {
			
			let alert = network.alert()
			self.presentViewController(alert, animated: true, completion: nil)
			
		}
		
	}
	
	@IBAction func logoutButtonAction(sender: UIButton) {
		
		let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
		alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in

			loggedIn = false
			
			PFUser.logOut()
			self.logoutButton.hidden = true
			self.logoutButton.enabled = false
			self.loginButtonOutlet.hidden = false
			self.registerButtonOutlet.hidden = false
			self.loginButtonOutlet.enabled = true
			self.registerButtonOutlet.enabled = true
			self.changePassButton.hidden = true
		
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		self.presentViewController(alert, animated: true, completion: nil)
		
	}
	
	func loginUser (user: String, password: String, alert: UIAlertController) {
	
		PFUser.logInWithUsernameInBackground(user, password: password) {
			PFUserResultBlock -> Void in
			if PFUserResultBlock.0 != nil {
				loggedIn = true
				self.loginButtonOutlet.hidden = true
				self.registerButtonOutlet.hidden = true
				self.logoutButton.hidden = false
				self.logoutButton.enabled = true
				self.changePassButton.hidden = false
				
			} else {
				
				let errorAlert = UIAlertController(title: "Invalid Input", message: "Please check your username and password.", preferredStyle: UIAlertControllerStyle.Alert)
				errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
					
					errorAlert.dismissViewControllerAnimated(false, completion: nil)
					self.presentViewController(alert, animated: true, completion: nil)
					
				}))
				self.presentViewController(errorAlert, animated: true, completion: nil)
				
			}
		}
		
	}
	
}
