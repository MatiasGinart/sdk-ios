//
//  PaymentMethodsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class PaymentMethodsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [PaymentMethod]!
    var supportedPaymentTypes: [String]!
    
    var callback : ((paymentMethod : PaymentMethod) -> Void)?
    
    init(merchantPublicKey: String, supportedPaymentTypes: [String], callback:(paymentMethod: PaymentMethod) -> Void) {
        super.init(nibName: "PaymentMethodsViewController", bundle: nil)
        self.publicKey = merchantPublicKey
        self.supportedPaymentTypes = supportedPaymentTypes
        self.callback = callback
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Medio de pago"
        
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
        self.view.addSubview(self.loadingView)
        
        let mercadoPago : MercadoPago = MercadoPago(publicKey: self.publicKey!)
        mercadoPago.getPaymentMethods({(paymentMethods: [PaymentMethod]?) -> Void in
                self.items = [PaymentMethod]()
                if paymentMethods != nil {
                    var pms : [PaymentMethod] = [PaymentMethod]()
                    if self.supportedPaymentTypes != nil {
                        for pm in paymentMethods! {
                            for supported in self.supportedPaymentTypes! {
                                if supported == pm.paymentTypeId {
                                    pms.append(pm)
                                }
                            }
                        }
                    }
                    self.items = pms
                }
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            }, failure: nil)
        
        var paymentMethodNib = UINib(nibName: "PaymentMethodTableViewCell", bundle: nil)
        self.tableView.registerNib(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pmcell : PaymentMethodTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("paymentMethodCell") as PaymentMethodTableViewCell
        
        let paymentMethod : PaymentMethod = items[indexPath.row]
        pmcell.setLabel(paymentMethod.name)
        pmcell.setImageWithName("icoTc_" + paymentMethod.id)
        
        return pmcell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.callback!(paymentMethod: self.items![indexPath.row])
    }
}