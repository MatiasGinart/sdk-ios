//
//  MercadoPagoService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 5/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class MercadoPagoService : NSObject {

    var baseURL : String!
    init (baseURL : String) {
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
        
        NSURLConnection.sendAsynchronousRequest(request, queue:
            NSOperationQueue.mainQueue(), completionHandler: {(response:
                NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                
                if error == nil {
                    success(jsonResult: NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil))
                }
                else {
                    if failure != nil {
                        failure!(error: error)
                    }
                }
        })
    }
}