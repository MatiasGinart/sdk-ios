//
//  MPMockServer.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

class MPMockServer {
    // Mapa de URL_Method como key y como value tiene un mapa de MPMockURLInformation
    var urlDictionary : Dictionary<String, Array<MPMockURLInformation>>

    init() {
        self.urlDictionary = Dictionary()
    }

    func registerURL(mockURL : MPMockURLInformation) {
        let mapKey = self.getKeyForURL(mockURL.path, andMethod:mockURL.restMethod)
        
        var arrayToInsert : Array<MPMockURLInformation> = Array()
        if let array = self.urlDictionary[mapKey] {
            arrayToInsert += array
        }
        
        arrayToInsert.append(mockURL)
        self.urlDictionary.updateValue(arrayToInsert, forKey:mapKey)
    }

    private func keyInRulesForServiceKey(key :String) -> String? {
        let rulesArray = MPMockServiceRules.rules.keys.array
        for string in rulesArray as [String] {
            if (key.rangeOfString(string, options: .RegularExpressionSearch) != nil) {
                return string
            }
        }
        return nil
    }
    
    func stubNetworking() {
        let allKeys = self.urlDictionary.keys.array
        
        OHHTTPStubs.stubRequestsPassingTest({ (urlRequest : NSURLRequest) -> Bool in
            let key = self.getKeyFromRequest(urlRequest)
            println("SERVICIO A MOCKEAR= " + key)
            if contains(allKeys, key) {
                return true
            } else {
                return self.keyInRulesForServiceKey(key) != nil
            }
        }, withStubResponse: { (urlRequest : NSURLRequest) -> OHHTTPStubsResponse in
            let key = self.getKeyFromRequest(urlRequest)
            if self.urlDictionary[key] != nil {
                var array = self.urlDictionary[key]!
                let urlMockInformation = array[0]
                if urlMockInformation.timeInterval != nil {
                    sleep(urlMockInformation.timeInterval!)
                }
                let dataToReturn = urlMockInformation.service().getResponseDataForURLInformation(urlMockInformation)

                array.removeAtIndex(0)
                if count(array) == 0 {
                    self.urlDictionary.removeValueForKey(key)
                } else {
                    self.urlDictionary.updateValue(array, forKey: key)
                }
                
                return OHHTTPStubsResponse(data: dataToReturn, statusCode: urlMockInformation.statusCode, headers: ["Content-Type":"application/json"])
            } else {
                let rulesKey = self.keyInRulesForServiceKey(key)
                let serviceClass = MPMockServiceRules.rules[rulesKey!]!
                let serviceObject = serviceClass()
                return OHHTTPStubsResponse(data: serviceObject.getCommonData(), statusCode:200, headers: ["Content-Type":"application/json"])
            }
        })
        
    }

    private func getKeyForURL(url : String, andMethod method: MPOSHTTPMethod) -> String{
        return url + "_" + method.stringify()
    }

    private func getKeyFromRequest(request : NSURLRequest) -> String {
        let absoluteURLString = request.URL!.absoluteString
        let url: String

        if let absoluteURLStringWithoutQueryParams = absoluteURLString!.rangeOfString("?") {
            url = absoluteURLString!.substringWithRange(Range<String.Index>(start: absoluteURLString!.startIndex, end: absoluteURLString!.rangeOfString("?")!.startIndex))
        } else {
            url = absoluteURLString!
        }
        
        let httpMethod = request.HTTPMethod
        let httpMethodEnum : MPOSHTTPMethod
        if httpMethod == "GET" {
            httpMethodEnum = MPOSHTTPMethod.GET
        } else if httpMethod == "POST" {
            httpMethodEnum = MPOSHTTPMethod.POST
        } else if httpMethod == "PUT" {
            httpMethodEnum = MPOSHTTPMethod.PUT
        } else {
            httpMethodEnum = MPOSHTTPMethod.DELETE
        }
        
        return self.getKeyForURL(url, andMethod:httpMethodEnum)
    }

    func verifyAllCallsWereMade() -> Bool {
        return count(self.urlDictionary.keys.array) == 0
    }
}
