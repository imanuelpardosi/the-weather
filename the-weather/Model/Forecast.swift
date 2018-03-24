//
//  Forecast.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 01/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import Foundation
import UIKit
import TemperatureConverter

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
    var _clouds: String!
    var _pressure: String!
    
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
    
    var clouds: String {
        if _clouds == nil {
            _clouds = ""
        }
        return _clouds
    }
    
    var pressure: String {
        if _pressure == nil {
            _pressure = ""
        }
        return _pressure
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: min)
                self._lowTemp = "\(Int(tempConvert.celsius))°"
            }
            if let max = temp["max"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: max)
                self._highTemp = "\(Int(tempConvert.celsius))°"
            }
            
            if let morn = temp["morn"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: morn)
                self._mornTemp = "\(Int(tempConvert.celsius))°"
            }
            if let day = temp["day"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: day)
                self._dayTemp = "\(Int(tempConvert.celsius))°"
            }
            if let eve = temp["eve"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: eve)
                self._eveTemp = "\(Int(tempConvert.celsius))°"
            }
            if let night = temp["night"] as? Double {
                let tempConvert = TemperatureConverter(from: .kelvin, value: night)
                self._nightTemp = "\(Int(tempConvert.celsius))°"
            }
        }
        
        if let humidity = weatherDict["humidity"] as? Double {
            self._humidity = "\(humidity)%"
        }
        
        if let speed = weatherDict["speed"] as? Double {
            self._speed = "\(speed) m/s"
        }
        
        if let clouds = weatherDict["clouds"] as? Double {
            self._clouds = "\(clouds)%"
        }
        
        if let pressure = weatherDict["pressure"] as? Double {
            self._pressure = "\(Int(pressure)) hpa"
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
