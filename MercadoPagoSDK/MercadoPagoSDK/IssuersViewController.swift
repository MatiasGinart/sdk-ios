//
//  IssuersViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class IssuersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    var paymentMethod: PaymentMethod?
    var callback: ((issuer: Issuer) -> Void)?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [Issuer]!
    
    var bundle: NSBundle? = MercadoPago.getBundle()

    init(merchantPublicKey: String, paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) {
        super.init(nibName: "IssuersViewController", bundle: bundle)
        self.publicKey = merchantPublicKey
        self.paymentMethod = paymentMethod
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
        
        self.title = "Banco".localized
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        let mercadoPago : MercadoPago = MercadoPago(publicKey: self.publicKey!)
        mercadoPago.getIssuers(self.paymentMethod!._id, success: { (issuers: [Issuer]?) -> Void in
                self.items = issuers
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            }, failure: nil)
        
        self.loadingView = UILoadingView(frame: MercadoPago.screenBoundsFixedToPortraitOrientation(), text: "Cargando...".localized)
        self.view.addSubview(self.loadingView)
        
        var issuerNib = UINib(nibName: "IssuerTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(issuerNib, forCellReuseIdentifier: "issuerCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var issuerCell : IssuerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("issuerCell") as! IssuerTableViewCell
        
        let issuer : Issuer = items[indexPath.row]
        issuerCell.fillWithIssuer(issuer)
        return issuerCell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(issuer: self.items![indexPath.row])
    }
    
}