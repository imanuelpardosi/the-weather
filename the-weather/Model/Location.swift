//
//  Location.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 01/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import CoreLocation

class Location {
    static var shareInstance = Location()
    
    var latitude: Double!
    var longitude: Double!
    
    private init() {
        
    }
}

