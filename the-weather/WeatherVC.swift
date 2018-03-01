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
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
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
        
        let dayLabel1 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "SUNDAY"
        dayLabel1.textAlignment = .center
        dayLabel1.center.x = self.view.center.x
        dayLabel1.attributedText = dayLabel.attributedText
        
        let dayLabel2 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "MONDAY"
        dayLabel2.textAlignment = .center
        dayLabel2.center.x = self.view.center.x + scrollViewWidth
        dayLabel2.attributedText = dayLabel.attributedText
        
        let dayLabel3 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "TUESDAY"
        dayLabel3.textAlignment = .center
        dayLabel3.center.x = self.view.center.x + scrollViewWidth * 2
        dayLabel3.attributedText = dayLabel.attributedText
        
        let timeLabel1 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "MORNING"
        timeLabel1.textAlignment = .center
        timeLabel1.center.x = self.view.center.x
        timeLabel1.attributedText = dayLabel.attributedText
        
        let timeLabel2 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "DAY"
        timeLabel2.textAlignment = .center
        timeLabel2.center.x = self.view.center.x + scrollViewWidth
        timeLabel2.attributedText = dayLabel.attributedText
        
        let timeLabel3 = UILabel(frame: CGRect(x: 0, y: 13, width: 150, height: 25))
        dayLabel.text = "NIGHT"
        timeLabel3.textAlignment = .center
        timeLabel3.center.x = self.view.center.x + scrollViewWidth * 2
        timeLabel3.attributedText = dayLabel.attributedText
        
        self.mainScrollView.addSubview(imgOne)
        self.mainScrollView.addSubview(imgTwo)
        self.mainScrollView.addSubview(imgThree)
        self.mainScrollView.addSubview(imgFour)
        
        self.mainScrollView.addSubview(weatherType1)
        self.mainScrollView.addSubview(weatherType2)
        
        self.dayScrollView.addSubview(dayLabel1)
        self.dayScrollView.addSubview(dayLabel2)
        self.dayScrollView.addSubview(dayLabel3)
        
        self.timeScrollView.addSubview(timeLabel1)
        self.timeScrollView.addSubview(timeLabel2)
        self.timeScrollView.addSubview(timeLabel3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 4, height: self.mainScrollView.frame.height)

        self.dayScrollView.contentSize = CGSize(width: self.dayScrollView.frame.width * 3, height: self.dayScrollView.frame.height)
        
        self.timeScrollView.contentSize = CGSize(width: self.timeScrollView.frame.width * 3, height: self.timeScrollView.frame.height)
        
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
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                }
            }
            completed()
        }
    }
    
    func updateMainUI() {
        
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
            cityLabel.text = "GERMANY"
        } else {
            cityLabel.text = "JAKARTA"
//            UIView.animate(withDuration: 1.0, animations: { () -> Void in
//                self.startButton.alpha = 1.0
//            })
        }
    }
    
    func scrollViewDidScroll(_ scrolled: UIScrollView) {
        
        if scrolled === mainScrollView {
            print("1")
            mainScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === dayScrollView {
            print("2")
            dayScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === timeScrollView {
            print("3")
            timeScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        }
    }
}

