//
//  InstallmentsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class InstallmentsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var publicKey : String?
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    
    var payerCosts : [PayerCost]!
    var amount : Double = 0
    var callback : ((payerCost: PayerCost?) -> Void)?
    
    init(payerCosts: [PayerCost]?, amount: Double, callback: (payerCost: PayerCost?) -> Void) {
        super.init(nibName: "InstallmentsViewController", bundle: nil)
        self.payerCosts = payerCosts
        self.amount = amount
        self.callback = callback
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: "InstallmentsViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cuotas"

        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        var installmentNib = UINib(nibName: "InstallmentTableViewCell", bundle: nil)
        self.tableView.registerNib(installmentNib, forCellReuseIdentifier: "installmentCell")
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payerCosts == nil ? 0 : payerCosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pccell : InstallmentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("installmentCell") as InstallmentTableViewCell
        
        let payerCost : PayerCost = self.payerCosts![indexPath.row]
        pccell.fillWithPayerCost(payerCost, amount: amount)
        
        return pccell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(payerCost: self.payerCosts![indexPath.row])
    }
   
}