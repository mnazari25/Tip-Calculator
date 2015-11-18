//
//  tipInfo.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/12/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import Foundation

class TipInfo {
	
	var restaurantName : String?
	var notes : String?
	var subtotal : Double
	var tax : Double
	var taxPercent : Double = 0
	var serviceCharge : Double
	var tip : Double
	var tipAmount : Double
	var total : Double
	var beforeTax : Bool
	var timesSplit = 0
	var isMutliple = false
	
	// For Cloud Storage
	var objectID : String?
	var savedReceiptImage : UIImage?
	
	init(subtotal : Double = 0.0, tax : Double = 0.0, serviceCharge : Double = 0.0, tip : Double = 0.15, tipAmount : Double = 0.0, total : Double = 0.0, beforeTax : Bool = false){
		
		self.subtotal = subtotal
		self.tax = tax
		self.serviceCharge = serviceCharge
		self.tip = tip
		self.tipAmount = tipAmount
		self.total = total
		self.beforeTax = beforeTax
		
	}
	
	// single person tip
	func calculateTip() -> Double{
		
		total = (subtotal + tax)
		
		if beforeTax {
			
			tipAmount = (total - tax) * tip
			
		} else {
			
			tipAmount = total * tip
			
		}
		
		total = total + tipAmount + serviceCharge
		
		return tipAmount
		
	}
	
}


// Multi Person Tip Functionality
extension TipInfo {
	
	func splitBillEven(){
		
		if timesSplit != 0 {
			
			subtotal = subtotal / Double(timesSplit)
			tax = tax / Double(timesSplit)
			if tipAmount != 0 {
				
				tipAmount = tipAmount / Double(timesSplit)
				
			}
			serviceCharge = serviceCharge / Double(timesSplit)
			total = total / Double(timesSplit)
			
		}
		
	}
	
	func backToNormal() {
		
		if timesSplit != 0{
			
			subtotal = subtotal * Double(timesSplit)
			tax = tax * Double(timesSplit)
			tipAmount = tipAmount * Double(timesSplit)
			serviceCharge = serviceCharge * Double(timesSplit)
			total = total * Double(timesSplit)
			
		}
		
	}

	
	func figureTaxPercent() -> Double{
		
		if tax != 0 {
			
			taxPercent = tax / subtotal
			
		}
		
		return taxPercent
		
	}
	
	func calculateTax() -> Double {
		
		if taxPercent != 0 {
			
			tax = subtotal * taxPercent
			
		}
		
		return tax
		
	}
	
}

