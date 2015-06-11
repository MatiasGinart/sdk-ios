//
//  MercadoPagoService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 5/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MercadoPagoService : NSObject {

    var baseURL : String!
    public init (baseURL : String) {
        super.init()
        self.baseURL = baseURL
    }
    
    public func request(uri: String, params: String?, body: AnyObject?, method: String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        var url = baseURL + uri
        if params != nil {
            url += "?" + params!
        }
        
        var finalURL: NSURL = NSURL(string: url)!
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = finalURL
        request.HTTPMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if body != nil {
            request.HTTPBody = (body as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
        }

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		
		NSURLConnection.sendAsynchronousRequest(request, queue:
            NSOperationQueue.mainQueue(), completionHandler: {(response:
                NSURLResponse!,data: NSData!,error: NSError!) -> Void in
				
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                // Puede que viniera status code de error pero no un NSError
                var hasError = (error != nil)
                var statusCode = 200
                if !hasError && response is NSHTTPURLResponse {
                    let httpResponse = response as! NSHTTPURLResponse
                    statusCode = httpResponse.statusCode
                    hasError = (statusCode < 200 || statusCode >= 400)
                }

				if !hasError {
                    success(jsonResult: NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil))
                }
                else {
                    if failure != nil {
                        if error != nil {
                            failure!(error: error)
                        } else {
                            failure!(error: NSError(domain: "mercadoPago", code: statusCode, userInfo: nil))
                        }
                    }
                }
        })
    }
}