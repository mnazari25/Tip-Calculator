//
//  FirstViewController.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/10/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	//MARK: - Outlets
	@IBOutlet weak var singleImage: UIImageView!
	@IBOutlet weak var multiImage: UIImageView!
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		/* Modifies tab bar item color appearance */
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)], forState:.Normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState:.Selected)
		self.tabBarController?.tabBar.tintColor = UIColor.orangeColor()
		
		if let items = tabBarController?.tabBar.items  {
			
			for item in items {
				
				item.image = item.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
				
			}
			
		}
		
		
	    /* set title text and style for navigation bar */
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.grayColor(),NSFontAttributeName: UIFont(name: "Noteworthy", size: 22)!]
		self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
		self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
		
		/* Determines if user was logged in on last application open and assigns appropiate boolean value */ 
		let currentUser = PFUser.currentUser()
		if currentUser != nil {
			
			if network.isConnectedToNetwork() {
				
				loggedIn = true
				
			} else {
				
				loggedIn = false
				
			}
			
		}
		
	}
	
	//MARK: - IBActions
	
	/* Handles tip navigation segue */
	@IBAction func singlePersonTip(sender: AnyObject) {
		
		if let tapGesture = sender as? UITapGestureRecognizer {
			
			let myImageView = tapGesture.view as? UIImageView
			performSegueWithIdentifier("toInputVC", sender: myImageView)
			
		} else {
			
			performSegueWithIdentifier("toInputVC", sender: sender)
			
		}
		
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let inputVC = segue.destinationViewController as? InputViewController {
		
			if let mySender = sender as? UIView {
				
				// determines which selection was tapped and assigns appropiate information to be sent to input view controller
				switch mySender.tag {
					
				case 0 :
					
					inputVC.thisImage = UIImage(named: "singlePerson")
					inputVC.thisMessage = "Ok then, Lone Wolf. Please enter some information about your bill."
					inputVC.isMultiple = false
					
				case 1 :
					
					inputVC.thisImage = UIImage(named: "MultiplePerson")
					inputVC.thisMessage = "How come I wasn’t invited? Anyway, please enter the total bill amount for your awesome party."
					inputVC.isMultiple = true
					
				default:
					
					print("Not sure how you pulled this one off")
					
				}
				
			} else {
				
				print("This isn't a freaking view")
				
			}
			
		}
		
	}

}

