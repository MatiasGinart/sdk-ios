//
//  UIDevice+Additions.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

enum UIDeviceFamily : Int {
	case UIDeviceFamilyiPhone = 0, UIDeviceFamilyiPod, UIDeviceFamilyiPad, UIDeviceFamilyAppleTV, UIDeviceFamilyUnknown
}

extension UIDevice {

	var cameraAvailable: Bool {
		return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
	}
	
	var videoCameraAvailable: Bool {
		let picker : UIImagePickerController = UIImagePickerController()
		var sourceTypes : Array? = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)
		if sourceTypes == nil {
			return false
		}
		return true // TODO:! contains(sourceTypes, kUTTypeMovie)
	}
	
	var frontCameraAvailable: Bool {
		#if __IPHONE_4_0
		return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
		#else
		return false
		#endif
	}
	
	var cameraFlashAvailable: Bool {
		#if __IPHONE_4_0
			return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
			#else
			return false
		#endif
	}
	
	var canMakePhoneCalls: Bool {
		return UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://")!)
	}
	
	var retinaDisplayCapable: Bool {
		var scale : CGFloat = CGFloat(1.0)
		let screen : UIScreen = UIScreen.mainScreen()
		if screen.respondsToSelector(Selector("scale")) {
			scale = screen.scale
		}
		
		if scale == 2.0 {
			return true
		} else {
			return false
		}
	}
	
	var canSendSMS: Bool {
		#if __IPHONE_4_0
			return MFMessageComposeViewController.canSendText()
		#else
			return UIApplication.sharedApplication().canOpenURL(NSURL(string: "sms://")!)
		#endif
	}
	
	var totalDiskSpace: NSNumber? {
		var fattributes : NSDictionary = NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory(), error: nil)!
		return fattributes.objectForKey(NSFileSystemSize) as? NSNumber
	}
	
	var freeDiskSpace: NSNumber? {
		var fattributes : NSDictionary = NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory(), error: nil)!
		return fattributes.objectForKey(NSFileSystemFreeSize) as? NSNumber
	}
	
	var platform: String {
		var size : Int = 0
		sysctlbyname("hw.machine", nil, &size, nil, 0)
		var machine = [CChar](count: Int(size), repeatedValue: 0)
		sysctlbyname("hw.machine", &machine, &size, nil, 0)
		return String.fromCString(machine)!
	}
	
	var hwmodel: String {
		var size : Int = 0
		sysctlbyname("hw.model", nil, &size, nil, 0)
		var model = [CChar](count: Int(size), repeatedValue: 0)
		sysctlbyname("hw.model", &model, &size, nil, 0)
		return String.fromCString(model)!
	}
	
	var totalMemory: Int {
		var size : Int = 0
		sysctlbyname("hw.physmem", nil, &size, nil, 0)
		var physmem : Int = 0
		sysctlbyname("hw.physmem", &physmem, &size, nil, 0)
		return physmem
	}
	
	var cpuCount: Int {
		var size : Int = 0
		sysctlbyname("hw.ncpu", nil, &size, nil, 0)
		var ncpu : Int = 0
		sysctlbyname("hw.ncpu", &ncpu, &size, nil, 0)
		return ncpu
	}
	
	var deviceFamily: UIDeviceFamily {
		let platform = self.platform
		if platform.hasPrefix("iPhone") {
			return UIDeviceFamily.UIDeviceFamilyiPhone
		}
		if platform.hasPrefix("iPod") {
			return UIDeviceFamily.UIDeviceFamilyiPod
		}
		if platform.hasPrefix("iPad") {
			return UIDeviceFamily.UIDeviceFamilyiPad
		}
		if platform.hasPrefix("AppleTV") {
			return UIDeviceFamily.UIDeviceFamilyAppleTV
		}
		
		return UIDeviceFamily.UIDeviceFamilyUnknown
	}
	
}