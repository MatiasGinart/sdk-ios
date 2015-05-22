//
//  PromosTyCViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

public class PromosTyCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak private var tableView : UITableView!
	
	var promos : [Promo]!
	
	var bundle : NSBundle? = MercadoPago.getBundle()
	
	public init(promos: [Promo]) {
		super.init(nibName: "PromosTyCViewController", bundle: self.bundle)
		self.promos = promos
	}
	
	public init() {
		super.init(nibName: "PromosTyCViewController", bundle: self.bundle)
	}
	
	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Promociones".localized
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
		
		self.tableView.registerNib(UINib(nibName: "PromoTyCDetailTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "PromoTyCDetailTableViewCell")
		
		self.tableView.estimatedRowHeight = 44.0
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.tableView.reloadData()

    }
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.promos.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return self.tyCCellAtIndexPath(indexPath)
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.heightForTyCCellAtIndexPath(indexPath)
	}
	
	func heightForTyCCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
		
		var sizingCell : PromoTyCDetailTableViewCell? = nil
		var onceToken : dispatch_once_t = 0
		dispatch_once(&onceToken) {
			sizingCell = self.tableView.dequeueReusableCellWithIdentifier("PromoTyCDetailTableViewCell") as? PromoTyCDetailTableViewCell
		}
		
		self.configureTyCCell(sizingCell!, atIndexPath: indexPath)
		return self.calculateHeightForConfiguredSizingCell(sizingCell!)
		
	}
	
	func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
		sizingCell.setNeedsLayout()
		sizingCell.layoutIfNeeded()
		let size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
		return size.height + 1
	}
	
	func tyCCellAtIndexPath(indexPath: NSIndexPath) -> PromoTyCDetailTableViewCell {
		var cell = self.tableView.dequeueReusableCellWithIdentifier("PromoTyCDetailTableViewCell", forIndexPath: indexPath) as! PromoTyCDetailTableViewCell
		self.configureTyCCell(cell, atIndexPath: indexPath)
		return cell
	}
	
	func configureTyCCell(cell: PromoTyCDetailTableViewCell, atIndexPath: NSIndexPath) {
		let promo = self.promos[atIndexPath.row]
		self.setTyCForCell(cell, promo: promo)
	}
	
	func setTyCForCell(cell: PromoTyCDetailTableViewCell, promo: Promo) {
		cell.setLabelWithIssuerName(promo.issuer!.name!, legals: promo.legals)
	}

}
