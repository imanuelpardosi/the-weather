//
//  Constant.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 01/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?"
let LATITUTE = "lat="
let LONGITUDE = "&lon="
let COUNT = "&cnt=7"
let MODE = "&mode=json"
let APP_ID = "&appid="
let APP_KEY = "42a1771a0b787bf12e734ada0cfc80cb"

//let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.shareInstance.latitude!)&lon=\(Location.shareInstance.longitude!)&cnt=10&mode=json&appid=42a1771a0b787bf12e734ada0cfc80cb"

typealias DownloadComplete = () -> ()
