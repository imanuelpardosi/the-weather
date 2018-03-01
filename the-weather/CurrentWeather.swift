//
//  CurrentWeather.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 01/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        
        print(currentWeatherURL)
        Alamofire.request(currentWeatherURL).responseJSON { (response) in
            print(response)
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name
                    print(self._cityName)
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main
                        print(self._weatherType)
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFahrenheitPreDevision = (currentTemperature * (9/5) - 459.67)
                        let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDevision/10))
                        self._currentTemp = kelvinToFahrenheit
                        print(self._currentTemp)
                    }
                }
                completed()
            }
        }
    }
}
