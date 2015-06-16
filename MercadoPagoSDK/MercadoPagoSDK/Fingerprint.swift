//
//  Fingerprint.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class Fingerprint : NSObject {
    
    public var fingerprint : [String : AnyObject]?
    
    public override init () {
        super.init()
        self.fingerprint = deviceFingerprint()
    }
    
    public func toJSONString() -> String {
        return JSON(self.fingerprint!).toString()
    }
    
    public func deviceFingerprint() -> [String : AnyObject] {
        var device : UIDevice = UIDevice.currentDevice()
        var dictionary : [String : AnyObject] = [String : AnyObject]()
		dictionary["os"] = "iOS"
		let devicesId : [AnyObject]? = devicesID()
        if devicesId != nil {
            dictionary["vendor_ids"] = devicesId!
        }
        
        if !String.isNullOrEmpty(device.hwmodel) {
            dictionary["model"] = device.hwmodel
        }
        
        dictionary["os"] = "iOS"
        
        if !String.isNullOrEmpty(device.systemVersion) {
            dictionary["system_version"] = device.systemVersion
        }
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var width = NSString(format: "%.0f", screenSize.width)
        var height = NSString(format: "%.0f", screenSize.height)
        
        dictionary["resolution"] =  "\(width)x\(height)"
        
        dictionary["ram"] = device.totalMemory
        dictionary["disk_space"] = device.totalDiskSpace
        dictionary["free_disk_space"] = device.freeDiskSpace
        
		var moreData = [String : AnyObject]()
        
        moreData["feature_camera"] = device.cameraAvailable
        moreData["feature_flash"] = device.cameraFlashAvailable
        moreData["feature_front_camera"] = device.frontCameraAvailable
        moreData["video_camera_available"] = device.videoCameraAvailable
        moreData["cpu_count"] = device.cpuCount
        moreData["retina_display_capable"] = device.retinaDisplayCapable
        
        if device.userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            moreData["device_idiom"] = "Pad"
        } else {
            moreData["device_idiom"] = "Phone"
        }
        
        if device.canSendSMS {
            moreData["can_send_sms"] = 1
        } else {
            moreData["can_send_sms"] = 0
        }
        
        if device.canMakePhoneCalls {
            moreData["can_make_phone_calls"] = 1
        } else {
            moreData["can_make_phone_calls"] = 0
        }
        
        if NSLocale.preferredLanguages().count > 0 {
            moreData["device_languaje"] = NSLocale.preferredLanguages()[0]
        }
        
        if !String.isNullOrEmpty(device.model) {
            moreData["device_model"] = device.model
        }
        
        if !String.isNullOrEmpty(device.platform) {
            moreData["platform"] = device.platform
        }
        
        moreData["device_family"] = device.deviceFamily.rawValue
        
        if !String.isNullOrEmpty(device.name) {
            moreData["device_name"] = device.name
        }
        
        /*var simulator : Bool = false
        #if TARGET_IPHONE_SIMULATOR
            simulator = YES
        #endif
        
        if simulator {
            moreData["simulator"] = 1
        } else {
            moreData["simulator"] = 0
		}*/
		
		moreData["simulator"] = 0
		
        dictionary["vendor_specific_attributes"] = moreData
		
		return dictionary
		
    }
    
    public func devicesID() -> [AnyObject]? {
        let systemVersionString : String = UIDevice.currentDevice().systemVersion
        let systemVersion : Float = (systemVersionString.componentsSeparatedByString(".")[0] as NSString).floatValue
        if systemVersion < 6 {
            let uuid : String = NSUUID().UUIDString
            if !String.isNullOrEmpty(uuid) {
                
                var dic : [String : AnyObject] = ["name" : "uuid"]
                dic["value"] = uuid
                return [dic]
            }
        }
        else {
            let vendorId : String = UIDevice.currentDevice().identifierForVendor.UUIDString
            let uuid : String = NSUUID().UUIDString
            
            var dicVendor : [String : AnyObject] = ["name" : "vendor_id"]
            dicVendor["value"] = vendorId
            var dic : [String : AnyObject] = ["name" : "uuid"]
            dic["value"] = uuid
            return [dicVendor, dic]
        }
        return nil
    }
    
}