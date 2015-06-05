
//
//  MercadoPago.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MercadoPago : NSObject {
    
    public class var PUBLIC_KEY : String {
        return "public_key"
    }
    public class var PRIVATE_KEY : String {
        return "private_key"
    }
    
    public class var ERROR_KEY_CODE : Int {
        return -1
    }
    
    public class var ERROR_API_CODE : Int {
        return -2
    }
    
    public class var ERROR_UNKNOWN_CODE : Int {
        return -3
    }
	
	public class var ERROR_NOT_INSTALLMENTS_FOUND : Int {
		return -4
	}
	
	public class var ERROR_PAYMENT : Int {
		return -4
	}
	
    let BIN_LENGTH : Int = 6
	
    let MP_API_BASE_URL : String = "https://api.mercadopago.com"
    public var privateKey : String?
    public var publicKey : String?
    
    public var paymentMethodId : String?
    public var paymentTypeId : String?
    
    public init (publicKey: String) {
        self.publicKey = publicKey
    }
    
    public init (keyType: String?, key: String?) {
        if keyType != nil && key != nil {
            if keyType != MercadoPago.PUBLIC_KEY && keyType != MercadoPago.PRIVATE_KEY {
                fatalError("keyType must be 'public_key' or 'private_key'.")
            } else {
                if keyType == MercadoPago.PUBLIC_KEY {
                    self.publicKey = key
                } else if keyType == MercadoPago.PUBLIC_KEY {
                    self.privateKey = key
                }
            }
        } else {
            fatalError("keyType and key cannot be nil.")
        }
    }
    
    public class func startCustomerCardsViewController(cards: [Card], callback: (selectedCard: Card?) -> Void) -> CustomerCardsViewController {
        return CustomerCardsViewController(cards: cards, callback: callback)
    }
    
    public class func startNewCardViewController(keyType: String, key: String, paymentMethod: PaymentMethod, requireSecurityCode: Bool, callback: (cardToken: CardToken) -> Void) -> NewCardViewController {
        return NewCardViewController(keyType: keyType, key: key, paymentMethod: paymentMethod, requireSecurityCode: requireSecurityCode, callback: callback)
    }
    
    public class func startPaymentMethodsViewController(merchantPublicKey: String, supportedPaymentTypes: [String], callback:(paymentMethod: PaymentMethod) -> Void) -> PaymentMethodsViewController {
        return PaymentMethodsViewController(merchantPublicKey: merchantPublicKey, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    public class func startIssuersViewController(merchantPublicKey: String, paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) -> IssuersViewController {
        return IssuersViewController(merchantPublicKey: merchantPublicKey, paymentMethod: paymentMethod, callback: callback)
    }
    
    public class func startInstallmentsViewController(payerCosts: [PayerCost], amount: Double, callback: (payerCost: PayerCost?) -> Void) -> InstallmentsViewController {
        return InstallmentsViewController(payerCosts: payerCosts, amount: amount, callback: callback)
    }
    
    public class func startCongratsViewController(payment: Payment, paymentMethod: PaymentMethod) -> CongratsViewController {
        return CongratsViewController(payment: payment, paymentMethod: paymentMethod)
    }
	
	public class func startPromosViewController(merchantPublicKey: String) -> PromoViewController {
		return PromoViewController(publicKey: merchantPublicKey)
	}
	
    public class func startVaultViewController(merchantPublicKey: String, merchantBaseUrl: String?, merchantGetCustomerUri: String?, merchantAccessToken: String?, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, tokenId: String?, issuerId: Int64?, installments: Int) -> Void) -> VaultViewController {
        
        return VaultViewController(merchantPublicKey: merchantPublicKey, merchantBaseUrl: merchantBaseUrl, merchantGetCustomerUri: merchantGetCustomerUri, merchantAccessToken: merchantAccessToken, amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    public func createNewCardToken(cardToken : CardToken, success: (token : Token?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            cardToken.device = Device()
            let service : GatewayService = GatewayService(baseURL: MP_API_BASE_URL)
            service.getToken(public_key: self.publicKey!, cardToken: cardToken, success: {(jsonResult: AnyObject?) -> Void in
                var token : Token? = nil
                if let tokenDic = jsonResult as? NSDictionary {
                    if tokenDic["error"] == nil {
                        token = Token.fromJSON(tokenDic)
                        success(token: token)
                    } else {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.createNewCardToken", code: MercadoPago.ERROR_API_CODE, userInfo: tokenDic as [NSObject : AnyObject]))
                        }
                    }
                }
            }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.createNewCardToken", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
    }
    
    public func createToken(savedCardToken : SavedCardToken, success: (token : Token?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            savedCardToken.device = Device()
            
            let service : GatewayService = GatewayService(baseURL: MP_API_BASE_URL)
            service.getToken(public_key: self.publicKey!, savedCardToken: savedCardToken, success: {(jsonResult: AnyObject?) -> Void in
                var token : Token? = nil
                if let tokenDic = jsonResult as? NSDictionary {
                    if tokenDic["error"] == nil {
                        token = Token.fromJSON(tokenDic)
                        success(token: token)
                    } else {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.createToken", code: MercadoPago.ERROR_API_CODE, userInfo: tokenDic as [NSObject : AnyObject]))
                        }
                    }
                }
            }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.createToken", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
    }
    
    public func getPaymentMethods(success: (paymentMethods: [PaymentMethod]?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
            service.getPaymentMethods(public_key: self.publicKey!, success: {(jsonResult: AnyObject?) -> Void in
                if let errorDic = jsonResult as? NSDictionary {
                    if errorDic["error"] != nil {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.getPaymentMethods", code: MercadoPago.ERROR_API_CODE, userInfo: errorDic as [NSObject : AnyObject]))
                        }
                    }
                } else {
                    var paymentMethods = jsonResult as? NSArray
                    var pms : [PaymentMethod] = [PaymentMethod]()
                    if paymentMethods != nil {
                        for i in 0..<paymentMethods!.count {
                            if let pmDic = paymentMethods![i] as? NSDictionary {
                                pms.append(PaymentMethod.fromJSON(pmDic))
                            }
                        }
                    }
                    success(paymentMethods: pms)
                }
            }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.getPaymentMethods", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
    }
    
    public func getIdentificationTypes(success: (identificationTypes: [IdentificationType]?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            let service : IdentificationService = IdentificationService(baseURL: MP_API_BASE_URL)
            service.getIdentificationTypes(public_key: self.publicKey, privateKey: self.privateKey, success: {(jsonResult: AnyObject?) -> Void in
                
                if let error = jsonResult as? NSDictionary {
                    if (error["status"]! as? Int) == 404 {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.getIdentificationTypes", code: MercadoPago.ERROR_API_CODE, userInfo: error as [NSObject : AnyObject]))
                        }
                    }
                } else {
                    var identificationTypesResult = jsonResult as? NSArray?
                    var identificationTypes : [IdentificationType] = [IdentificationType]()
                    if identificationTypesResult != nil {
                        for var i = 0; i < identificationTypesResult!!.count; i++ {
                            if let identificationTypeDic = identificationTypesResult!![i] as? NSDictionary {
                                identificationTypes.append(IdentificationType.fromJSON(identificationTypeDic))
                            }
                        }
                    }
                    success(identificationTypes: identificationTypes)
                }
                }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.getIdentificationTypes", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
    }
    
    public func getInstallments(bin: String, amount: Double, issuerId: Int64?, paymentTypeId: String, success: (installments: [Installment]?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
            service.getInstallments(public_key: self.publicKey!, bin: bin, amount: amount, issuer_id: issuerId, payment_type_id: paymentTypeId, success: {(jsonResult: AnyObject?) -> Void in
                
                if let errorDic = jsonResult as? NSDictionary {
                    if errorDic["error"] != nil {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.getInstallments", code: MercadoPago.ERROR_API_CODE, userInfo: errorDic as [NSObject : AnyObject]))
                        }
                    }
                } else {
                    var paymentMethods = jsonResult as? NSArray
                    var installments : [Installment] = [Installment]()
                    if paymentMethods != nil && paymentMethods?.count > 0 {
                        if let dic = paymentMethods![0] as? NSDictionary {
                            installments.append(Installment.fromJSON(dic))
                        }
						success(installments: installments)
					} else {
						var error : NSError = NSError(domain: "mercadopago.sdk.getIdentificationTypes", code: MercadoPago.ERROR_NOT_INSTALLMENTS_FOUND, userInfo: ["message": "NOT_INSTALLMENTS_FOUND".localized + "\(amount)"])
						failure?(error: error)
					}
                }
            }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.getInstallments", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
        
    }
    
    public func getIssuers(paymentMethodId : String, success: (issuers: [Issuer]?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        if self.publicKey != nil {
            let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
            service.getIssuers(public_key: self.publicKey!, payment_method_id: paymentMethodId, success: {(jsonResult: AnyObject?) -> Void in
                if let errorDic = jsonResult as? NSDictionary {
                    if errorDic["error"] != nil {
                        if failure != nil {
                            failure!(error: NSError(domain: "mercadopago.sdk.getIssuers", code: MercadoPago.ERROR_API_CODE, userInfo: errorDic as [NSObject : AnyObject]))
                        }
                    }
                } else {
                    var issuersArray = jsonResult as? NSArray
                    var issuers : [Issuer] = [Issuer]()
                    if issuersArray != nil {
                        for i in 0..<issuersArray!.count {
                            if let issuerDic = issuersArray![i] as? NSDictionary {
                                issuers.append(Issuer.fromJSON(issuerDic))
                            }
                        }
                    }
                    success(issuers: issuers)
                }
            }, failure: failure)
        } else {
            if failure != nil {
                failure!(error: NSError(domain: "mercadopago.sdk.getIssuers", code: MercadoPago.ERROR_KEY_CODE, userInfo: ["message": "Unsupported key type for this method"]))
            }
        }
    }
	
	public func getPromos(success: (promos: [Promo]?) -> Void, failure: ((error: NSError) -> Void)?) {
		// TODO: Está hecho para MLA fijo porque va a cambiar la URL para que dependa de una API y una public key
		let service : PromosService = PromosService(baseURL: "https://www.mercadopago.com")
		service.getPromos(success: { (jsonResult) -> Void in
			var promosArray = jsonResult as? NSArray?
			var promos : [Promo] = [Promo]()
			if promosArray != nil {
				for var i = 0; i < promosArray!!.count; i++ {
					if let promoDic = promosArray!![i] as? NSDictionary {
						promos.append(Promo.fromJSON(promoDic))
					}
				}
			}
			success(promos: promos)
		}, failure: failure)

	}

    public class func isCardPaymentType(paymentTypeId: String) -> Bool {
        if paymentTypeId == "credit_card" || paymentTypeId == "debit_card" || paymentTypeId == "prepaid_card" {
            return true
        }
        return false
    }
	
    public class func getBundle() -> NSBundle? {
        var bundle : NSBundle? = nil
        var privatePath = NSBundle.mainBundle().privateFrameworksPath
        if privatePath != nil {
            var path = privatePath!.stringByAppendingPathComponent("MercadoPagoSDK.framework")
            return NSBundle(path: path)
        }
        return nil
    }
	
	public class func screenBoundsFixedToPortraitOrientation() -> CGRect {
		var screenSize : CGRect = UIScreen.mainScreen().bounds
		if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
			return CGRectMake(0.0, 0.0, screenSize.height, screenSize.width)
		}
		return screenSize
	}
	
    public class func showAlertViewWithError(error: NSError?, nav: UINavigationController?) {
        let msgDefault = "An error occurred while processing your request. Please try again."
        var msg : String? = msgDefault
        
        if error != nil {
            msg = error!.userInfo!["message"] as? String
        }
        
        let alert = UIAlertController()
        alert.title = "MercadoPago Error"
		alert.message = "Error = \(msg != nil ? msg! : msgDefault)"
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                nav!.popViewControllerAnimated(true)
            case .Cancel:
                println("cancel")
            case .Destructive:
                println("destructive")
            }
        }))
        nav!.presentViewController(alert, animated: true, completion: nil)
        

    }
    
}