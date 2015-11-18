//
//  usefulExtensions.swift
//  mnazari_lab6
//
//  Created by Mirabutaleb Nazari on 1/20/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import Foundation

var formatDouble2 = "0.2"
var formatInt0 = "0"


extension Int {
	func format(f: String) -> String {
		return NSString(format: "%\(f)d", self) as String
	}
}

extension Double {
	func format(f: String) -> String {
		return NSString(format: "%\(f)f", self) as String
	}
}