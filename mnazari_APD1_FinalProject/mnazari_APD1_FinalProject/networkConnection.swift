//
//  networkConnection.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/27/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import Foundation

class network {
	
	/* Used to check network connection */
	
	// Checks network connection by requesting url connection and returning a boolean with success or failure result
	class func isConnectedToNetwork()->Bool{
		
		var Status:Bool = false
		let url = NSURL(string: "http://google.com/")
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "HEAD"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
		request.timeoutInterval = 10.0
		
		var response: NSURLResponse?
		
		_ = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
		
		if let httpResponse = response as? NSHTTPURLResponse {
			if httpResponse.statusCode == 200 {
				Status = true
			}
		}
		
		return Status
	}
	
	/* standard alert for no connection for reuse */ 
	class func alert() -> UIAlertController{
		
		let alert = UIAlertController(title: "Check Connection", message: "We can't seem to connect to the internet. Please check your settings.", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
		
		return alert
		
	}

}


