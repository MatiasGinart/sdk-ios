//
//  CustomerCardsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class CustomerCardsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [PaymentMethodRow]!
    var cards : [Card]?
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : ((selectedCard: Card?) -> Void)?
    
    public init(cards: [Card]?, callback: (selectedCard: Card?) -> Void) {
        super.init(nibName: "CustomerCardsViewController", bundle: bundle)
        self.cards = cards
        self.callback = callback
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Medios de pago".localized

		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newCard")

        self.loadingView = UILoadingView(frame: MercadoPago.screenBoundsFixedToPortraitOrientation(), text: "Cargando...".localized)
        self.view.addSubview(self.loadingView)
        
        var paymentMethodNib = UINib(nibName: "PaymentMethodTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadCards()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pmcell : PaymentMethodTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("paymentMethodCell") as! PaymentMethodTableViewCell
        
        let paymentRow : PaymentMethodRow = items[indexPath.row]
        pmcell.setLabel(paymentRow.label!)
        pmcell.setImageWithName(paymentRow.icon!)
        
        return pmcell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(selectedCard: self.cards![indexPath.row])
    }
    
    public func loadCards() {
        self.items = [PaymentMethodRow]()
        for (card) in cards! {
            var paymentMethodRow = PaymentMethodRow()
            paymentMethodRow.card = card
            paymentMethodRow.label = card.paymentMethod!.name + " " + "terminada en".localized + " " + card.lastFourDigits!
            paymentMethodRow.icon = "icoTc_" + card.paymentMethod!._id
            self.items.append(paymentMethodRow)
        }
        self.tableView.reloadData()
        self.loadingView.removeFromSuperview()
    }
    
    public func newCard() {
        callback!(selectedCard: nil)
    }
}