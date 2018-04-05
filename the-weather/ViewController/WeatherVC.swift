//
//  ViewController.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 28/02/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

protocol WeatherProtocol: class {
    func updateMainUI()
}

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
import JGProgressHUD

class WeatherVC: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, WeatherProtocol {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeScrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var minWeather: UILabel!
    @IBOutlet weak var maxWeather: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var clouds: UILabel!
    
    private var currentIndexDay: Int!
    private var currentIndexTime: Int!
    
    var forecasts = [Forecast]()
    var forecastsCurrentLocation = [Forecast]()
    var forecastsLondon = [Forecast]()
    var forecastsParis = [Forecast]()
    var forecastsBerlin = [Forecast]()
    var forecastsSearchCity = [Forecast]()
    
    var imgOne: UIImageView!
    var imgTwo: UIImageView!
    var imgThree: UIImageView!
    var imgFour: UIImageView!
    var imgFive: UIImageView!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var newWeatherTypeArr: [UILabel] = [UILabel]()
    var newDayLabelArr: [UILabel] = [UILabel]()
    var newTimeLabelArr: [UILabel] = [UILabel]()
    let dayTimes: [String] = ["MORNING", "DAY", "EVENING", "NIGHT"]
    var cities: [String] = ["MEDAN", "LONDON", "PARIS", "BERLIN", "SEARCH CITY"]
    let coordinate: [(Double, Double)] = [(0.0, 0.0), (51.5073509, -0.1277583), (48.856614, 2.3522219),(52.5200066, 13.404954)]
    
    var isDataDownloaded: Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherType.addCharactersSpacing(value: 10)

        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2566935718, green: 0.3841508329, blue: 0.4642606378, alpha: 1),
             NSAttributedStringKey.font: Font.setCustomFont(fontType: .HindMedium, fontSize: 20)]
        
        weatherVC = self
        self.view.showBlurLoader()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mainScrollView.delegate = self
        self.dayScrollView.delegate = self
        self.timeScrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func getCities() -> [String] {
        var removeLast = cities
        removeLast.removeLast()
        return removeLast
    }
    
    func getTemperature() -> [String] {
        var result: [String] = [String]()
        let currentHour = self.getCurrentTime()
        
        if currentHour <= 12 && currentHour >= 6 {
            result.append(forecastsCurrentLocation[0].mornTemp)
            result.append(forecastsLondon[0].mornTemp)
            result.append(forecastsParis[0].mornTemp)
            result.append(forecastsBerlin[0].mornTemp)
        } else if currentHour <= 16 && currentHour >= 13 {
            result.append(forecastsCurrentLocation[0].dayTemp)
            result.append(forecastsLondon[0].dayTemp)
            result.append(forecastsParis[0].dayTemp)
            result.append(forecastsBerlin[0].dayTemp)
        } else if currentHour <= 20 && currentHour >= 17 {
            result.append(forecastsCurrentLocation[0].eveTemp)
            result.append(forecastsLondon[0].eveTemp)
            result.append(forecastsParis[0].eveTemp)
            result.append(forecastsBerlin[0].eveTemp)
        } else {
            result.append(forecastsCurrentLocation[0].nightTemp)
            result.append(forecastsLondon[0].nightTemp)
            result.append(forecastsParis[0].nightTemp)
            result.append(forecastsBerlin[0].nightTemp)
        }
        
        return result
    }
    
    func getWeatherType() -> [String] {
        var result: [String] = [String]()
        let currentHour = self.getCurrentTime()
        
        if currentHour <= 10 && currentHour >= 4 {
            result.append(forecastsCurrentLocation[0].weatherType)
            result.append(forecastsLondon[0].weatherType)
            result.append(forecastsParis[0].weatherType)
            result.append(forecastsBerlin[0].weatherType)
        } else if currentHour <= 16 && currentHour >= 11 {
            result.append(forecastsCurrentLocation[0].weatherType)
            result.append(forecastsLondon[0].weatherType)
            result.append(forecastsParis[0].weatherType)
            result.append(forecastsBerlin[0].weatherType)
        } else if currentHour <= 20 && currentHour >= 17 {
            result.append(forecastsCurrentLocation[0].weatherType)
            result.append(forecastsLondon[0].weatherType)
            result.append(forecastsParis[0].weatherType)
            result.append(forecastsBerlin[0].weatherType)
        } else {
            result.append(forecastsCurrentLocation[0].weatherType)
            result.append(forecastsLondon[0].weatherType)
            result.append(forecastsParis[0].weatherType)
            result.append(forecastsBerlin[0].weatherType)
        }
        
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if !isDataDownloaded {
            isDataDownloaded = true
            currentLocation = locations[0]
            
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
                        allCities = self.getCities()
                        self.navigationItem.title = self.cities[0]
                        print(city)
                    }
                }
            })
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "LOADING"
            hud.textLabel.font = UIFont(name: "Helvetica", size: 15)
            hud.textLabel.textColor = #colorLiteral(red: 0.4834194183, green: 0.4834313393, blue: 0.483424902, alpha: 1)
            hud.show(in: self.view)
            
            self.downloadForecastData(lat: Location.shareInstance.latitude, long: Location.shareInstance.longitude, city: .current) {
                self.downloadForecastData(lat: self.coordinate[1].0, long: self.coordinate[1].1, city: .London) {
                    self.downloadForecastData(lat: self.coordinate[2].0, long: self.coordinate[2].1, city: .Paris) {
                        self.downloadForecastData(lat: self.coordinate[3].0, long: self.coordinate[3].1, city: .Berlin) {
                            allTemperature = self.getTemperature()
                            allWeatherType = self.getWeatherType()
                            self.forecasts = self.forecastsCurrentLocation
                            hud.dismiss(afterDelay: 0.3)
                            self.updateMainUI()
                            self.view.removeBluerLoader()
                        }
                    }
                }
            }
        }
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

        Alamofire.request(forecastUrl!).responseJSON { response in
            let result = response.result
            
            if result.isSuccess {
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
            } else {
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = "NO NETWORK CONNECTION."
                hud.textLabel.font = UIFont(name: "Helvetica", size: 15)
                hud.textLabel.textColor = #colorLiteral(red: 0.4834194183, green: 0.4834313393, blue: 0.483424902, alpha: 1)
                hud.show(in: self.view)
            }
        }
    }
    
    func setupScrollViewSize() {
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 5, height: self.mainScrollView.frame.height)
        self.dayScrollView.contentSize = CGSize(width: self.dayScrollView.frame.width * CGFloat(self.forecasts.count), height: self.dayScrollView.frame.height)
        self.timeScrollView.contentSize = CGSize(width: self.timeScrollView.frame.width * 4, height: self.timeScrollView.frame.height)
    }
    
    func updateMainUI() {
        var weatherIconTopConstraint: CGFloat = 20.0
        var iconSize: CGFloat = 100
        var increaseX: CGFloat = 0
        print("self.modelIdentifier(): \(self.modelIdentifier())")
        if self.modelIdentifier().contains("iPhone8,4") || self.modelIdentifier().contains("iPhone6") {
            weatherType.frame.origin.y = 0
            weatherIconTopConstraint = 0
            iconSize = 70
            increaseX = 15
        } else if self.modelIdentifier().contains("iPhone10,3") || self.modelIdentifier().contains("iPhone10,5") || self.modelIdentifier().contains("iPhone9,2") || self.modelIdentifier().contains("iPhone7,1") || self.modelIdentifier().contains("iPhone8,2") {
            weatherType.frame.origin.y = 30
            iconSize = 170
            increaseX = -35
        }
            
        
        if setCurrentPage == nil {
            self.pageControl.currentPage = 0
        } else {
            self.pageControl.currentPage = setCurrentPage
            self.navigationItem.title = self.cities[Int(setCurrentPage)]
            let offset: CGPoint = CGPoint(x: self.mainScrollView.frame.width * CGFloat(setCurrentPage), y: 0)
            self.mainScrollView?.setContentOffset(offset, animated: true)
            
            if Int(setCurrentPage) == 0 {
                forecasts = forecastsCurrentLocation
            } else if Int(setCurrentPage) == 1 {
                forecasts = forecastsLondon
            } else if Int(setCurrentPage) == 2 {
                forecasts = forecastsParis
            } else if Int(setCurrentPage) == 3 {
                forecasts = forecastsBerlin
            } else if Int(setCurrentPage) == 4 {
                forecasts = forecastsSearchCity
            }
        }
       
        self.setupScrollViewSize()
        self.setCurrentWeather()
       
        self.mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 175)
        let scrollViewWidth: CGFloat = self.mainScrollView.frame.width
        //let scrollViewHeight: CGFloat = self.mainScrollView.frame.height
        
        imgOne = UIImageView(frame: CGRect(x: self.mainScrollView.center.x - 50 + increaseX, y: weatherType.frame.maxY + weatherIconTopConstraint, width: iconSize, height: iconSize))
        imgOne.image = UIImage(named: "\(forecastsCurrentLocation[0].weatherType)")
        imgOne.contentMode = .scaleAspectFit
        
        imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth + self.mainScrollView.center.x - 50 + increaseX, y: weatherType.frame.maxY + weatherIconTopConstraint, width: iconSize, height: iconSize))
        imgTwo.image = UIImage(named: "\(forecastsLondon[0].weatherType)")
        imgTwo.contentMode = .scaleAspectFit
        
        imgThree = UIImageView(frame: CGRect(x:scrollViewWidth * 2 + self.mainScrollView.center.x - 50 + increaseX, y: weatherType.frame.maxY + weatherIconTopConstraint, width: iconSize, height: iconSize))
        imgThree.image = UIImage(named: "\(forecastsParis[0].weatherType)")
        imgThree.contentMode = .scaleAspectFit
        
        imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3 + self.mainScrollView.center.x - 50 + increaseX, y: weatherType.frame.maxY + weatherIconTopConstraint, width: iconSize , height: iconSize))
        imgFour.image = UIImage(named: "\(forecastsBerlin[0].weatherType)")
        imgFour.contentMode = .scaleAspectFit
        
        imgFive = UIImageView(frame: CGRect(x: scrollViewWidth * 4 + self.mainScrollView.center.x - 50 + increaseX, y: weatherType.frame.maxY + weatherIconTopConstraint, width: iconSize, height: iconSize))
        imgFive.image = UIImage(named: "\(forecastsBerlin[0].weatherType)")
        imgFive.contentMode = .scaleAspectFit
        
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
                let newWeatherType = UILabel()
                weatherType.text = "HOW'S YOUR FAVORITE CITY?"
                newWeatherType.adjustsFontSizeToFitWidth = true
                newWeatherType.numberOfLines = 1
                newWeatherType.minimumScaleFactor = 0.2
                newWeatherType.lineBreakMode = NSLineBreakMode.byWordWrapping
                
                newWeatherType.textAlignment = .center
                newWeatherType.frame = weatherType.frame
                newWeatherType.center.x = self.view.center.x + (scrollViewWidth * CGFloat(i))
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
            imgOne.image = UIImage(named: "\(forecastsCurrentLocation[currentIndexDay].weatherType)")
        } else if Int(pageControl.currentPage) == 1 {
            weatherType.text = forecastsLondon[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
            imgTwo.image = UIImage(named: "\(forecastsLondon[currentIndexDay].weatherType)")
        } else if Int(pageControl.currentPage) == 2 {
            weatherType.text = forecastsParis[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
            imgThree.image = UIImage(named: "\(forecastsParis[currentIndexDay].weatherType)")
        } else if Int(pageControl.currentPage) == 3 {
            weatherType.text = forecastsBerlin[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
            imgFour.image = UIImage(named: "\(forecastsBerlin[currentIndexDay].weatherType)")
        }  else if Int(pageControl.currentPage) == 4 {
            print(forecastsSearchCity[currentIndexDay].weatherType.uppercased())
            weatherType.text = forecastsSearchCity[currentIndexDay].weatherType.uppercased()
            newWeatherTypeArr[Int(pageControl.currentPage)].attributedText = weatherType.attributedText
            imgFive.image = UIImage(named: "\(forecastsSearchCity[currentIndexDay].weatherType)")
            
            print(newWeatherTypeArr[Int(pageControl.currentPage)].frame)
        }
    }
    
    func setCurrentWeather() {
        let currentHour = getCurrentTime()
        
        if currentIndexTime != nil {
            minWeather.text = forecasts[currentIndexDay].lowTemp
            maxWeather.text = forecasts[currentIndexDay].highTemp
            wind.text = forecasts[currentIndexDay].speed
            humidity.text = forecasts[currentIndexDay].humidity
            pressure.text = forecasts[currentIndexDay].pressure
            clouds.text = forecasts[currentIndexDay].clouds
            
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
            
            minWeather.text = forecasts[0].lowTemp
            maxWeather.text = forecasts[0].highTemp
            wind.text = forecasts[0].speed
            humidity.text = forecasts[0].humidity
            pressure.text = forecasts[0].pressure
            clouds.text = forecasts[0].clouds
            
            if currentHour <= 10 && currentHour >= 4 {
                currentWeatherLabel.text = forecasts[0].mornTemp
            } else if currentHour <= 16 && currentHour >= 11 {
                currentWeatherLabel.text = forecasts[0].dayTemp
                let bottomOffset: CGPoint = CGPoint(x: self.timeScrollView.frame.width * 1, y: 0)
                self.timeScrollView?.setContentOffset(bottomOffset, animated: true)
            } else if currentHour <= 20 && currentHour >= 17 {
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
        let today=Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        
        return components.hour!
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
            self.cities[4] = place.name.uppercased()
            
            let offset: CGPoint = CGPoint(x: self.mainScrollView.frame.width * 4, y: 0)
            self.mainScrollView?.setContentOffset(offset, animated: true)
            
            self.navigationItem.title = self.cities[Int(self.pageControl.currentPage)]
            self.forecasts = self.forecastsSearchCity
            self.currentIndexDay = 0
            
            self.setCurrentWeather()
            self.setWeatherType()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
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
        
        if forecasts.count != 0 {
            self.setCurrentWeather()
            self.setWeatherType()
        } else {
            minWeather.text = "0°"
            maxWeather.text = "0°"
            wind.text = "0.0 m/s"
            humidity.text = "0%"
            pressure.text = "0.0 hpa"
            clouds.text = "0%"
            currentWeatherLabel.text = "0°"
        }
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

extension UIView {
    func showBlurLoader() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func removeBluerLoader() {
        self.subviews.flatMap {  $0 as? UIVisualEffectView }.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UILabel {
    func addCharactersSpacing(value: CGFloat) {
        if let textString = text {
            let attrs: [NSAttributedStringKey : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }
}
