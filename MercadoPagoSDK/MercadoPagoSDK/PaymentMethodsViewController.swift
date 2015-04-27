//
//  PaymentMethodsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class PaymentMethodsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [PaymentMethod]!
    var supportedPaymentTypes: [String]!
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    var callback : ((paymentMethod : PaymentMethod) -> Void)?
    
    init(merchantPublicKey: String, supportedPaymentTypes: [String], callback:(paymentMethod: PaymentMethod) -> Void) {
        super.init(nibName: "PaymentMethodsViewController", bundle: bundle)
        self.publicKey = merchantPublicKey
        self.supportedPaymentTypes = supportedPaymentTypes
        self.callback = callback
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Medio de pago".localized
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...".localized)
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
            }, failure: { (error: NSError?) -> Void in
                MercadoPago.showAlertViewWithError(error, nav: self.navigationController)
        })
        
        var paymentMethodNib = UINib(nibName: "PaymentMethodTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pmcell : PaymentMethodTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("paymentMethodCell") as! PaymentMethodTableViewCell
        
        let paymentMethod : PaymentMethod = items[indexPath.row]
        pmcell.setLabel(paymentMethod.name)
        pmcell.setImageWithName("icoTc_" + paymentMethod.id)
        
        return pmcell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.callback!(paymentMethod: self.items![indexPath.row])
    }
}