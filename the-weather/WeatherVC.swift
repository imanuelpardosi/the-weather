//
//  ViewController.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 28/02/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeScrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let dayTimes: [String] = ["MORNING", "DAY", "EVENING", "NIGHT"]
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shareInstance.latitude = currentLocation.coordinate.latitude
            Location.shareInstance.longitude = currentLocation.coordinate.longitude
            
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
        
        self.mainScrollView.delegate = self
        self.dayScrollView.delegate = self
        self.timeScrollView.delegate = self
        self.pageControl.currentPage = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        let forecastUrl = URL(string: FORECAST_URL)
        Alamofire.request(forecastUrl!).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        if self.forecasts.count < 7 {
                            self.forecasts.append(forecast)
                        }
                        print(obj)
                    }
                }
            }
            completed()
        }
    }
    
    func updateMainUI() {
        print("datanya: \(self.forecasts.count)")
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 4, height: self.mainScrollView.frame.height)
        
        self.dayScrollView.contentSize = CGSize(width: self.dayScrollView.frame.width * CGFloat(self.forecasts.count), height: self.dayScrollView.frame.height)
        
        self.timeScrollView.contentSize = CGSize(width: self.timeScrollView.frame.width * 4, height: self.timeScrollView.frame.height)
        
        
        self.mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 175)
        let scrollViewWidth: CGFloat = self.mainScrollView.frame.width
        //let scrollViewHeight: CGFloat = self.mainScrollView.frame.height
        
        let imgOne = UIImageView(frame: CGRect(x: self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgOne.image = UIImage(named: "CloudLighting")
        let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgTwo.image = UIImage(named: "LightRain")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth * 2 + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgThree.image = UIImage(named: "Rainy")
        let imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3 + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgFour.image = UIImage(named: "Windy")
        
        let weatherType1 = UILabel()
        weatherType.text = "CLOUDY"
        weatherType1.textAlignment = .center
        weatherType1.frame = weatherType.frame
        weatherType1.center.x = self.view.center.x
        weatherType1.attributedText = weatherType.attributedText
        
        let weatherType2 = UILabel()
        weatherType.text = "WINDY"
        weatherType2.textAlignment = .center
        weatherType2.frame = weatherType.frame
        weatherType2.center.x = self.view.center.x + scrollViewWidth
        weatherType2.attributedText = weatherType.attributedText
        
        var newDayLabelArr: [UILabel] = [UILabel]()
        for i in 0..<forecasts.count {
            print("i: \(i) \(forecasts[i].date)")
            let newDayLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
            dayLabel.text = forecasts[i].date.uppercased()
            newDayLabel.textAlignment = .center
            newDayLabel.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
            newDayLabel.attributedText = dayLabel.attributedText
            newDayLabelArr.append(newDayLabel)
            
            self.dayScrollView.addSubview(newDayLabelArr[i])
        }
        
        var newTimeLabelArr: [UILabel] = [UILabel]()
        for i in 0..<dayTimes.count {
            let newTimeLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
            dayLabel.text = dayTimes[i]
            newTimeLabel.textAlignment = .center
            newTimeLabel.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
            newTimeLabel.attributedText = dayLabel.attributedText
            newTimeLabelArr.append(newTimeLabel)
            
            self.timeScrollView.addSubview(newTimeLabelArr[i])
        }
      
        self.mainScrollView.addSubview(imgOne)
        self.mainScrollView.addSubview(imgTwo)
        self.mainScrollView.addSubview(imgThree)
        self.mainScrollView.addSubview(imgFour)
        
        self.mainScrollView.addSubview(detailView)
        
        self.mainScrollView.addSubview(weatherType1)
        self.mainScrollView.addSubview(weatherType2)
    }
    
    func getCurrentTime() -> String {
        var currentHour:Int
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        currentHour = Int(dateFormatter.string(from: date as Date))!
        
        if currentHour <= 12 && currentHour >= 6 {
            return "morn"
        } else if currentHour <= 17 {
            return "day"
        } else if currentHour <= 20 {
            return "eve"
        } else {
            return "night"
        }
    }
}

extension WeatherVC
{
    func scrollViewDidEndDecelerating(_ scrolled: UIScrollView) {
        let pageWidth: CGFloat = mainScrollView.frame.width
        let currentPage: CGFloat = floor((mainScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        self.pageControl.currentPage = Int(currentPage);
    
        if Int(currentPage) == 0 {
            cityLabel.text = "LONDON"
        } else if Int(currentPage) == 1 {
            cityLabel.text = "PARIS"
        } else if Int(currentPage) == 2 {
            cityLabel.text = "BERLIN"
        } else {
            cityLabel.text = "JAKARTA"
//            UIView.animate(withDuration: 1.0, animations: { () -> Void in
//                self.startButton.alpha = 1.0
//            })
        }
    }
    
    func scrollViewDidScroll(_ scrolled: UIScrollView) {
        if scrolled === mainScrollView {
            mainScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === dayScrollView {
            dayScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === timeScrollView {
            timeScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
            self.pageControl.currentPage = 3
        }
    }
}

