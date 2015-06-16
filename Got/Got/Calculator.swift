//
//  Calculator.swift
//  Got
//
//  Created by 一川 on 6/15/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import Foundation
import CoreLocation

class Calculator {
    
    let earthRadius = 6378137.0
    
    //根据经纬度来计算距离和角度
    
    //计算距离
    func calculateDistance(targetLocation: CLLocation, currentLocation: CLLocation) -> Double{
        let latA = targetLocation.coordinate.latitude
        let lonA = targetLocation.coordinate.longitude
        
        let latB = currentLocation.coordinate.latitude
        let lonB = currentLocation.coordinate.longitude
        
        let radLatA = rad(latA)
        let radLatB = rad(latB)
        let a = radLatA - radLatB
        let b = rad(lonA) - rad(lonB)
        
        var distance = 2 * sin(sqrt(pow(sin(a)/2, 2.0) + cos(radLatA) * cos(radLatB) * pow(sin(b/2), 2.0)))
        distance = distance * earthRadius
        distance = round(distance * 10000) / 10000
        
        return distance
    }
    
    func rad(d: Double) -> Double {
        return d * M_PI/180.0
    }
    
    //计算角度
    func calculateAngle(targetLocation: CLLocation, currentLocation: CLLocation) {
        
    }
}