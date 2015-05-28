//
//  MPToolbar.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 27/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class MPToolbar : UIToolbar {

	var textFieldContainer : UITextField?
	var keyboardDelegate: KeyboardDelegate?
	
	public init(prevEnabled: Bool, nextEnabled: Bool, delegate: KeyboardDelegate, textFieldContainer: UITextField) {

		super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
		
		self.keyboardDelegate = delegate
		self.textFieldContainer = textFieldContainer
		
		self.barStyle = UIBarStyle.Default
		self.translucent = true
		self.sizeToFit()
		var items : [UIBarButtonItem] = []
		
		//  Create a done button to show on keyboard to resign it. Adding a selector to resign it.
		let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Bordered, target: self, action: "done")
		
		let prev = UIBarButtonItem(image: UIImage(named: "IQButtonBarArrowLeft", inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection: nil), style: UIBarButtonItemStyle.Plain, target: self, action: "prev")
		
		let fixed = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
		fixed.width = 23
		
		let next = UIBarButtonItem(image: UIImage(named: "IQButtonBarArrowRight", inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection: nil), style: UIBarButtonItemStyle.Plain, target: self, action: "next")
		
		prev.enabled = prevEnabled
		next.enabled = nextEnabled
		
		items.append(prev)
		items.append(fixed)
		items.append(next)
		
		//  Create a fake button to maintain flexibleSpace between doneButton and nilButton. (Actually it moves done button to right side.
		let nilButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		
		items.append(nilButton)
		items.append(doneButton)
		
		//  Adding button to toolBar.
		self.items = items
		
		switch textFieldContainer.keyboardAppearance {
		case UIKeyboardAppearance.Dark:
			self.barStyle = UIBarStyle.Black
		default:
			self.barStyle = UIBarStyle.Default
		}
		
		textFieldContainer.inputAccessoryView = self
		
		
	}
	
	func prev() {
		keyboardDelegate?.prev(textFieldContainer)
	}
	
	func next() {
		keyboardDelegate?.next(textFieldContainer)
	}
	
	func done() {
		keyboardDelegate?.done(textFieldContainer)
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}