//
//  ExamplesViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ExamplesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tableview : UITableView!
    
    let examples : [String] = ["Formulario simple", "Tarjetas guardadas", "Cuotas y Bancos", "Medios Off y Descuentos",
    "Interfaz de usuario por defecto"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: "ExamplesViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MercadoPago SDK"
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: examples[indexPath.row])
        cell.textLabel!.text = examples[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType(rawValue: UITableViewCellAccessoryType.DetailDisclosureButton.rawValue)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.row {
        case 0:
            self.showViewController(MercadoPago.startPaymentMethodsViewController(ExamplesUtils.MERCHANT_PUBLIC_KEY, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card"], callback: { (paymentMethod: PaymentMethod) -> Void in
                self.showViewController(ExamplesUtils.startCardActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: paymentMethod, callback: {(token: Token?) -> Void in
                    self.createPayment(token!.id, paymentMethod: paymentMethod, installments: 1, cardIssuerId: nil, discount: nil)
                }), sender: self)}), sender: self)
        case 1:
            self.showViewController(ExamplesUtils.startSimpleVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card"], callback: {(paymentMethod: PaymentMethod, token: Token?) -> Void in
                    self.createPayment(token!.id, paymentMethod: paymentMethod, installments: 1, cardIssuerId: nil, discount: nil)
            } ), sender: self)
            
        case 2:
            self.showViewController(ExamplesUtils.startAdvancedVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, amount: ExamplesUtils.AMOUNT, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card"], callback: {(paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int?) -> Void in
                self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuerId: issuerId, discount: nil)
            }), sender: self)
        case 3:
            self.showViewController(ExamplesUtils.startFinalVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, amount: ExamplesUtils.AMOUNT, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card", "ticket", "atm"], callback: {(paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int?) -> Void in
                self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuerId: issuerId, discount: nil)
            }), sender: self)
        case 4:
            self.showViewController(MercadoPago.startVaultViewController(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, amount: ExamplesUtils.AMOUNT, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card", "ticket", "atm"], callback: {(paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int?) -> Void in
                    self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuerId: issuerId, discount: nil)
            }), sender: self)
        default:
            println("Otra opcion")
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        var message : String? = nil
        switch indexPath.row {
        case 0:
            message = "Formulario simple con entendimiento del medio de pago."
        case 1:
            message = "Flujo de pagos que permite seleccionar las tarjetas guardadas del usuario."
        case 2:
            message = "Flujo de pagos que considera solicitar cuotas."
        case 3:
            message = "Flujo de pagos que considera solicitar cuotas."
        case 4:
            message = "Flujo de pagos que considera solicitar cuotas."
        default:
            message = "Invalid option"
        }

        let alert = UIAlertView()
        alert.title = "Ejemplo \(indexPath.row + 1) Info"
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()

    }

    func createPayment(token: String?, paymentMethod: PaymentMethod, installments: Int?, cardIssuerId: Int64?, discount: Discount?) {
        if token != nil {
            ExamplesUtils.createPayment(token!, installments: installments, cardIssuerId: cardIssuerId, paymentMethod: paymentMethod, callback: { (payment: Payment) -> Void in
                self.showViewController(MercadoPago.startCongratsViewController(payment, paymentMethod: paymentMethod), sender: self)
            })
        } else {
            println("no tengo token")
        }
    }
    
    func getDiscount() {
        
    }

}
