//
//  MercadoPago.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class MercadoPago {
    
    class var PUBLIC_KEY : String {
        return "public_key"
    }
    class var PRIVATE_KEY : String {
        return "private_key"
    }
    
    let BIN_LENGTH : Int = 6
    
    let VAULT_BASE_URL : String = "https://pagamento.mercadopago.com"
    let MP_API_BASE_URL : String = "https://api.mercadopago.com"
    var privateKey : String?
    var publicKey : String?
    
    var paymentMethodId : String?
    var paymentTypeId : String?
    
    init (publicKey: String) {
        self.publicKey = publicKey
    }
    
    init (keyType: String?, key: String?) {
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
    
    class func startCustomerCardsViewController(cards: [Card], callback: (selectedCard: Card?) -> Void) -> CustomerCardsViewController {
        return CustomerCardsViewController(cards: cards, callback: callback)
    }
    
    class func startNewCardViewController(keyType: String, key: String, paymentMethod: PaymentMethod, requireSecurityCode: Bool, callback: (cardToken: CardToken) -> Void) -> NewCardViewController {
        return NewCardViewController(keyType: keyType, key: key, paymentMethod: paymentMethod, requireSecurityCode: requireSecurityCode, callback: callback)
    }
    
    class func startPaymentMethodsViewController(merchantPublicKey: String, supportedPaymentTypes: [String], callback:(paymentMethod: PaymentMethod) -> Void) -> PaymentMethodsViewController {
        return PaymentMethodsViewController(merchantPublicKey: merchantPublicKey, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    class func startIssuersViewController(merchantPublicKey: String, paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) -> IssuersViewController {
        return IssuersViewController(merchantPublicKey: merchantPublicKey, paymentMethod: paymentMethod, callback: callback)
    }
    
    class func startInstallmentsViewController(payerCosts: [PayerCost], amount: Double, callback: (payerCost: PayerCost?) -> Void) -> InstallmentsViewController {
        return InstallmentsViewController(payerCosts: payerCosts, amount: amount, callback: callback)
    }
    
    class func startCongratsViewController(payment: Payment, paymentMethod: PaymentMethod) -> CongratsViewController {
        return CongratsViewController(payment: payment, paymentMethod: paymentMethod)
    }
    
    class func startVaultViewController(merchantPublicKey: String, merchantBaseUrl: String, merchantGetCustomerUri: String?, merchantAccessToken: String, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, token: Token?, cardIssuerId: Int?, installments: Int?) -> Void) -> VaultViewController {
        return VaultViewController(merchantPublicKey: merchantPublicKey, merchantBaseUrl: merchantBaseUrl, merchantGetCustomerUri: merchantGetCustomerUri, merchantAccessToken: merchantAccessToken, amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    func createNewCardToken(cardToken : CardToken, success: (token : Token?) -> Void, failure: ((error: NSError) -> Void)?) {
        cardToken.device = Device()
        let service : GatewayService = GatewayService(baseURL: VAULT_BASE_URL)
        service.getToken(public_key: self.publicKey!, cardToken: cardToken, success: {(jsonResult: AnyObject?) -> Void in
            var token : Token? = nil
            if let tokenDic = jsonResult as? NSDictionary {
                token = Token.fromJSON(tokenDic)
            }
            success(token: token)
            }, failure: failure)
    }
    
    func createToken(savedCardToken : SavedCardToken, success: (token : Token?) -> Void, failure: ((error: NSError) -> Void)?) {
        
        savedCardToken.device = Device()
        
        let service : GatewayService = GatewayService(baseURL: VAULT_BASE_URL)
        service.getToken(public_key: self.publicKey!, savedCardToken: savedCardToken, success: {(jsonResult: AnyObject?) -> Void in
            var token : Token? = nil
            if let tokenDic = jsonResult as? NSDictionary {
                token = Token.fromJSON(tokenDic)
            }
            success(token: token)
            }, failure: failure)
    }
    
    func getPaymentMethods(success: (paymentMethods: [PaymentMethod]?) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
        service.getPaymentMethods(public_key: self.publicKey!, success: {(jsonResult: AnyObject?) -> Void in
            var paymentMethods = jsonResult as NSArray?
            var pms : [PaymentMethod] = [PaymentMethod]()
            if paymentMethods != nil {
                for i in 0..<paymentMethods!.count {
                    if let pmDic = paymentMethods![i] as? NSDictionary {
                        pms.append(PaymentMethod.fromJSON(pmDic))
                    }
                }
            }
            success(paymentMethods: pms)
            }, failure: failure)
    }
    
    func getIdentificationTypes(success: (identificationTypes: [IdentificationType]?) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : IdentificationService = IdentificationService(baseURL: MP_API_BASE_URL)
        service.getIdentificationTypes(public_key: self.publicKey, privateKey: self.privateKey, success: {(jsonResult: AnyObject?) -> Void in
        
            if let error = jsonResult as? NSDictionary {
                if (error["status"]! as Int) == 404 {
                    failure!(error: NSError())
                }
            } else {
                var identificationTypesResult = jsonResult as NSArray?
                var identificationTypes : [IdentificationType] = [IdentificationType]()
                if identificationTypesResult != nil {
                    for i in 0..<identificationTypesResult!.count {
                        if let identificationTypeDic = identificationTypesResult![i] as? NSDictionary {
                            identificationTypes.append(IdentificationType.fromJSON(identificationTypeDic))
                        }
                    }
                }
                success(identificationTypes: identificationTypes)
            }
        }, failure: failure)
    }
    
    func getInstallments(bin: String, amount: Double, issuerId: Int?, paymentTypeId: String, success: (installments: [Installment]?) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
        service.getInstallments(public_key: self.publicKey!, bin: bin, amount: amount, issuer_id: issuerId, payment_type_id: paymentTypeId, success: {(jsonResult: AnyObject?) -> Void in
            var paymentMethods = jsonResult as NSArray?
            var installments : [Installment] = [Installment]()
            if paymentMethods != nil {
                if let dic = paymentMethods![0] as? NSDictionary {
                    installments.append(Installment.fromJSON(dic))
                }
            }
            success(installments: installments)
            }, failure: failure)
        
    }
    
    func getIssuers(paymentMethodId : String, success: (issuers: [Issuer]?) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : PaymentService = PaymentService(baseURL: MP_API_BASE_URL)
        service.getIssuers(public_key: self.publicKey!, payment_method_id: paymentMethodId, success: {(jsonResult: AnyObject?) -> Void in
            var issuersArray = jsonResult as NSArray?
            var issuers : [Issuer] = [Issuer]()
            if issuersArray != nil {
                for i in 0..<issuersArray!.count {
                    if let issuerDic = issuersArray![i] as? NSDictionary {
                        issuers.append(Issuer.fromJSON(issuerDic))
                    }
                }
            }
            success(issuers: issuers)
            }, failure: failure)
    }
    
    class func isCardPaymentType(paymentTypeId: String) -> Bool {
        if paymentTypeId == "credit_card" || paymentTypeId == "debit_card" || paymentTypeId == "prepaid_card" {
            return true
        }
        return false
    }
    
}