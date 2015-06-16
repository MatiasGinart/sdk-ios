//
//  PromosService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

public class PromosService : MercadoPagoService {
	
	// TODO: Agregar public key y modificar URL
	public func getPromos(url : String = "/v1/payment_methods/deals", method : String = "GET", public_key: String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
		self.request(url, params: "public_key=" + public_key, body: nil, method: method, success: success, failure: failure)
	}
	
}