//
//  ViewController.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 28/02/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

enum CITY {
    case current
    case London
    case Paris
    case Berlin
    case search
}

import UIKit
import CoreLocation
import Alamofire
import GooglePlaces

class WeatherVC: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeScrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    private var currentIndexDay: Int!
    private var currentIndexTime: Int!
    
    var forecasts = [Forecast]()
    var forecastsCurrentLocation = [Forecast]()
    var forecastsLondon = [Forecast]()
    var forecastsParis = [Forecast]()
    var forecastsBerlin = [Forecast]()
    var forecastsSearchCity = [Forecast]()
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var newWeatherTypeArr: [UILabel] = [UILabel]()
    var newDayLabelArr: [UILabel] = [UILabel]()
    var newTimeLabelArr: [UILabel] = [UILabel]()
    let dayTimes: [String] = ["MORNING", "DAY", "EVENING", "NIGHT"]
    var cities: [String] = ["JAKARTA", "LONDON", "PARIS", "BERLIN", ""]
    let coordinate: [(Double, Double)] = [(0.0, 0.0), (51.5073509, -0.1277583), (48.856614, 2.3522219),(52.5200066, 13.404954)]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationAuthStatus()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        self.mainScrollView.delegate = self
        self.dayScrollView.delegate = self
        self.timeScrollView.delegate = self
        self.pageControl.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnMenuOnClick(_ sender: Any) {
    
    }
    
    @IBAction func btnSearchOnClick(_ sender: Any) {
        print("search")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.show(newViewController, sender: self)
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shareInstance.latitude = currentLocation.coordinate.latitude
            Location.shareInstance.longitude = currentLocation.coordinate.longitude

            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let placeArray = placemarks
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    if let city = placeMark.addressDictionary?["City"] as? NSString {
                        self.cities[0] = city.uppercased
                        self.navigationItem.title = self.cities[0]
                        print(city)
                    }
                }
            })

            self.downloadForecastData(lat: Location.shareInstance.latitude, long: Location.shareInstance.longitude, city: .current) {
                self.downloadForecastData(lat: self.coordinate[1].0, long: self.coordinate[1].1, city: .London) {
                    self.downloadForecastData(lat: self.coordinate[2].0, long: self.coordinate[2].1, city: .Paris) {
                        self.downloadForecastData(lat: self.coordinate[3].0, long: self.coordinate[3].1, city: .Berlin) {
                            self.forecasts = self.forecastsCurrentLocation
                            self.updateMainUI()
                        }
                    }
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(lat: Double, long: Double, city: CITY, completed: @escaping DownloadComplete) {
        var data = [Forecast]()
        let forecastUrl = URL(string: "\(BASE_URL)\(LATITUTE)\(lat)\(LONGITUDE)\(long)\(COUNT)\(MODE)\(APP_ID)\(APP_KEY)")
        print(forecastUrl)
        Alamofire.request(forecastUrl!).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let newForecast = Forecast(weatherDict: obj)
                        if data.count < 7 {
                            data.append(newForecast)
                        }
                        print(obj)
                    }
                }
            }
            
            if city == .current {
                self.forecastsCurrentLocation = data
            } else if city == .London {
                self.forecastsLondon = data
            } else if city == .Paris {
                self.forecastsParis = data
            } else if city == .Berlin {
                self.forecastsBerlin = data
            } else if city == .search {
                self.forecastsSearchCity = data
            }
            completed()
        }
    }
    
    func setupScrollViewSize() {
        print("count search city: \(forecastsSearchCity.count)")
        if forecastsSearchCity.count == 0 {
            self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 4, height: self.mainScrollView.frame.height)
        } else {
            self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 5, height: self.mainScrollView.frame.height)
        }
        self.dayScrollView.contentSize = CGSize(width: self.dayScrollView.frame.width * CGFloat(self.forecasts.count), height: self.dayScrollView.frame.height)
        self.timeScrollView.contentSize = CGSize(width: self.timeScrollView.frame.width * 4, height: self.timeScrollView.frame.height)
    }
    
    func updateMainUI() {
        print("datanya: \(self.forecasts.count)")
        
        weatherType.frame.origin.y = 25
        self.setupScrollViewSize()
        self.setCurrentWeather()
        
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
        let imgFive = UIImageView(frame: CGRect(x: scrollViewWidth * 4 + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgFive.image = UIImage(named: "Rainy")
        
        
        for i in 0..<pageControl.numberOfPages {
            if i == 0 {
                let newWeatherType = UILabel()
                weatherType.text = forecastsCurrentLocation[0].weatherType.uppercased()
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
                newWeatherType.attributedText = weatherType.attributedText
                
                self.newWeatherTypeArr.append(newWeatherType)
                self.mainScrollView.addSubview(newWeatherTypeArr[i])
            } else if i == 1 {
                let newWeatherType = UILabel()
                weatherType.text = forecastsLondon[0].weatherType.uppercased()
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
                newWeatherType.attributedText = weatherType.attributedText
                
                self.newWeatherTypeArr.append(newWeatherType)
                self.mainScrollView.addSubview(newWeatherTypeArr[i])
            } else if i == 2 {
                let newWeatherType = UILabel()
                weatherType.text = forecastsParis[0].weatherType.uppercased()
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
                newWeatherType.attributedText = weatherType.attributedText
                
                self.newWeatherTypeArr.append(newWeatherType)
                self.mainScrollView.addSubview(newWeatherTypeArr[i])
            } else if i == 3 {
                let newWeatherType = UILabel()
                weatherType.text = forecastsBerlin[0].weatherType.uppercased()
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
                newWeatherType.attributedText = weatherType.attributedText
                
                self.newWeatherTypeArr.append(newWeatherType)
                self.mainScrollView.addSubview(newWeatherTypeArr[i])
            } else if i == 4 {
                print(" forecastsSearchCity[0].weatherType.uppercased(): \( forecastsSearchCity[0].weatherType.uppercased())")
                let newWeatherType = UILabel()
                weatherType.text = forecastsSearchCity[0].weatherType.uppercased()
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * 1.5)
                newWeatherType.attributedText = weatherType.attributedText
                
                self.newWeatherTypeArr.append(newWeatherType)
                self.mainScrollView.addSubview(newWeatherTypeArr[i])
            }
        }
        
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
        self.mainScrollView.addSubview(imgFive)
        
        self.mainScrollView.addSubview(detailView)
    }
    
    func setWeatherType() {
        if Int(pageControl.currentPage) == 0 {
            weatherType.text = forecastsCurrentLocation[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
        } else if Int(pageControl.currentPage) == 1 {
            weatherType.text = forecastsLondon[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
        } else if Int(pageControl.currentPage) == 2 {
            weatherType.text = forecastsParis[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
        } else if Int(pageControl.currentPage) == 3 {
            weatherType.text = forecastsBerlin[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
        }  else if Int(pageControl.currentPage) == 4 {
            weatherType.text = forecastsSearchCity[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
        }
    }
    
    func setCurrentWeather() {
        let currentHour = getCurrentTime()
        
        if currentIndexTime != nil {
            if currentIndexTime == 0 {
                currentWeatherLabel.text = forecasts[currentIndexDay].mornTemp
            } else if currentIndexTime == 1 {
                currentWeatherLabel.text = forecasts[currentIndexDay].dayTemp
            } else if currentIndexTime == 2 {
                currentWeatherLabel.text = forecasts[currentIndexDay].eveTemp
            } else if currentIndexTime == 3 {
                currentWeatherLabel.text = forecasts[currentIndexDay].nightTemp
            }
        } else {
            print(currentHour)
            if currentHour <= 12 && currentHour >= 6 {
                currentWeatherLabel.text = forecasts[0].mornTemp
            } else if currentHour <= 17 && currentHour >= 13 {
                currentWeatherLabel.text = forecasts[0].dayTemp
                let bottomOffset: CGPoint = CGPoint(x: self.timeScrollView.frame.width * 1, y: 0)
                self.timeScrollView?.setContentOffset(bottomOffset, animated: true)
            } else if currentHour <= 20 && currentHour >= 18 {
                currentWeatherLabel.text = forecasts[0].eveTemp
                let bottomOffset: CGPoint = CGPoint(x: self.timeScrollView.frame.width * 2, y: 0)
                self.timeScrollView?.setContentOffset(bottomOffset, animated: true)
            } else {
                currentWeatherLabel.text = forecasts[0].nightTemp
                let bottomOffset: CGPoint = CGPoint(x: self.timeScrollView.frame.width * 3, y: 0)
                self.timeScrollView?.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    func getCurrentTime() -> Int {
        var currentHour:Int
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        currentHour = Int(dateFormatter.string(from: date as Date))!
        
        return currentHour
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place)
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        
        self.downloadForecastData(lat: place.coordinate.latitude, long: place.coordinate.longitude, city: .search) {
            self.pageControl.numberOfPages = 5
            self.pageControl.currentPage = 4
            
            let offset: CGPoint = CGPoint(x: self.mainScrollView.frame.width * 5, y: 0)
            self.mainScrollView?.setContentOffset(offset, animated: true)
            
            self.cities[4] = place.name.uppercased()
            
            self.updateMainUI()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WeatherVC
{
    func scrollViewDidEndDecelerating(_ scrolled: UIScrollView) {
        let pageWidth: CGFloat = mainScrollView.frame.width
        let currentPage: CGFloat = floor((mainScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        self.pageControl.currentPage = Int(currentPage);
        
        let curIdxDayScrollView = floor((dayScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        self.currentIndexDay = Int(curIdxDayScrollView)
        
        let curIdxTimeScrollView = floor((timeScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        self.currentIndexTime = Int(curIdxTimeScrollView)
        
        if Int(currentPage) == 0 {
            forecasts = forecastsCurrentLocation
            
        } else if Int(currentPage) == 1 {
            forecasts = forecastsLondon
        } else if Int(currentPage) == 2 {
            forecasts = forecastsParis
        } else if Int(currentPage) == 3 {
            forecasts = forecastsBerlin
        } else if Int(currentPage) == 4 {
            forecasts = forecastsSearchCity
        }
    
        self.navigationItem.title = cities[Int(currentPage)]
        
        self.setCurrentWeather()
        self.setWeatherType()
    }
    
    func scrollViewDidScroll(_ scrolled: UIScrollView) {
        if scrolled === mainScrollView {
            mainScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === dayScrollView {
            dayScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        } else if scrolled === timeScrollView {
            timeScrollView.contentOffset = CGPoint(x: scrolled.contentOffset.x, y: 0)
        }
    }
}
