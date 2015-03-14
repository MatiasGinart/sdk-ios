//
//  IssuersViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class IssuersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    var paymentMethod: PaymentMethod?
    var callback: ((issuer: Issuer) -> Void)?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [Issuer]!

    init(merchantPublicKey: String, paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) {
        super.init(nibName: "IssuersViewController", bundle: nil)
        self.publicKey = merchantPublicKey
        self.paymentMethod = paymentMethod
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
        
        self.title = "Bancos"
        
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        let mercadoPago : MercadoPago = MercadoPago(publicKey: self.publicKey!)

        mercadoPago.getIssuers(self.paymentMethod!.id, success: { (issuers: [Issuer]?) -> Void in
                self.items = issuers
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            }, failure: nil)
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
        self.view.addSubview(self.loadingView)
        
        var issuerNib = UINib(nibName: "IssuerTableViewCell", bundle: nil)
        self.tableView.registerNib(issuerNib, forCellReuseIdentifier: "issuerCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var issuerCell : IssuerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("issuerCell") as IssuerTableViewCell
        
        let issuer : Issuer = items[indexPath.row]
        issuerCell.fillWithIssuer(issuer)
        return issuerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(issuer: self.items![indexPath.row])
    }
    
}