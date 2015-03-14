//
//  GatewayService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class GatewayService : MercadoPagoService {
    
    func getToken(url : String = "/card_tokens", method : String = "POST", public_key : String, savedCardToken : SavedCardToken, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(url, params: "public_key=" + public_key, body: savedCardToken.toJSONString(), method: method, success: success, failure: failure)
    }
    
    func getToken(url : String = "/card_tokens", method : String = "POST", public_key : String, cardToken : CardToken, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(url, params: "public_key=" + public_key, body: cardToken.toJSONString(), method: method, success: success, failure: failure)
    }
}