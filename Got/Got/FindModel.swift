//
//  FindModel.swift
//  Got
//
//  Created by 一川 on 6/11/15.
//  Copyright (c) 2015 huoteng. All rights reserved.
//

import Foundation
import CoreLocation

class FindModel: NSObject {
    var title: String
    var date: NSDate
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init (title: String, date: NSDate, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.title = title
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}