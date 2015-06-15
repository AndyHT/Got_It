//
//  DeviceVersion.swift
//  Got
//
//  Created by 一川 on 6/15/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit

class DeviceVersion {
    var version:Float
    
    init () {
        let ver = UIDevice.currentDevice().systemVersion
        version = NSNumberFormatter().numberFromString(ver)!.floatValue
    }
    
}