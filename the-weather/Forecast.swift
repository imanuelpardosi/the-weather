//
//  Forecast.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 01/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import Foundation
import UIKit

class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    var _mornTemp: String!
    var _dayTemp: String!
    var _eveTemp: String!
    var _nightTemp: String!
    var _humidity: String!
    var _speed: String!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    var mornTemp: String {
        if _mornTemp == nil {
            _mornTemp = ""
        }
        return _mornTemp
    }
    
    var dayTemp: String {
        if _dayTemp == nil {
            _dayTemp = ""
        }
        return _dayTemp
    }
    
    var eveTemp: String {
        if _eveTemp == nil {
            _eveTemp = ""
        }
        return _eveTemp
    }
    
    var nightTemp: String {
        if _nightTemp == nil {
            _nightTemp = ""
        }
        return _nightTemp
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = ""
        }
        return _humidity
    }
    
    var speed: String {
        if _speed == nil {
            _speed = ""
        }
        return _speed
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                let kelvinToFahrenheitPreDevision = (min * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._lowTemp = "\(kelvinToFahrenheit)°"
            }
            if let max = temp["max"] as? Double {
                let kelvinToFahrenheitPreDevision = (max * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._highTemp = "\(kelvinToFahrenheit)°"
            }
            
            if let morn = temp["morn"] as? Double {
                let kelvinToFahrenheitPreDevision = (morn * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._mornTemp = "\(kelvinToFahrenheit)°"
            }
            if let day = temp["day"] as? Double {
                let kelvinToFahrenheitPreDevision = (day * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._dayTemp = "\(kelvinToFahrenheit)°"
            }
            if let eve = temp["eve"] as? Double {
                let kelvinToFahrenheitPreDevision = (eve * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._eveTemp = "\(kelvinToFahrenheit)°"
            }
            if let night = temp["night"] as? Double {
                let kelvinToFahrenheitPreDevision = (night * (9/5) - 459.67)
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                self._nightTemp = "\(kelvinToFahrenheit)°"
            }
        }
        
        if let humidity = weatherDict["humidity"] as? Double {
            self._humidity = "\(humidity)"
        }
        
        if let speed = weatherDict["speed"] as? Double {
            self._speed = "\(speed)"
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

