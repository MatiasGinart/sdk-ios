//
//  InstallmentsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class InstallmentsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    
    var payerCosts : [PayerCost]!
    var amount : Double = 0
    var callback : ((payerCost: PayerCost?) -> Void)?
    
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    init(payerCosts: [PayerCost]?, amount: Double, callback: (payerCost: PayerCost?) -> Void) {
        super.init(nibName: "InstallmentsViewController", bundle: bundle)
        self.payerCosts = payerCosts
        self.amount = amount
        self.callback = callback
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init() {
        super.init(nibName: "InstallmentsViewController", bundle: self.bundle)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cuotas"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        var installmentNib = UINib(nibName: "InstallmentTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(installmentNib, forCellReuseIdentifier: "installmentCell")
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payerCosts == nil ? 0 : payerCosts.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pccell : InstallmentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("installmentCell") as InstallmentTableViewCell
        
        let payerCost : PayerCost = self.payerCosts![indexPath.row]
        pccell.fillWithPayerCost(payerCost, amount: amount)
        
        return pccell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(payerCost: self.payerCosts![indexPath.row])
    }
   
}