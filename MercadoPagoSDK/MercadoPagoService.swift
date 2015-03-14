//
//  MercadoPagoService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 5/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class MercadoPagoService {

    var baseURL : String
    init (baseURL : String) {
        self.baseURL = baseURL
    }
    
    func request(uri: String, params: String?, body: AnyObject?, method: String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        var url = baseURL + uri
        if params != nil {
            url += "?" + params!
        }
        
        var finalURL: NSURL = NSURL(string: url)!
        println("URL = " + url)
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = finalURL
        request.HTTPMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if body != nil {
            println("BODY = " + (body as NSString))
            request.HTTPBody = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        var urlConnection: NSURLConnection = NSURLConnection(request: request,
            delegate: self)!
        
        NSURLConnection.sendAsynchronousRequest(request, queue:
            NSOperationQueue.mainQueue(), completionHandler: {(response:
                NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                
                if error == nil {
                    print("RESPONSE = ")
                    println(NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil))
                    success(jsonResult: NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil))
                }
                else {
                    failure!(error: error)
                }
        })
    }
}