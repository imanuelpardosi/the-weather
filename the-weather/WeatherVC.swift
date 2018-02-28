//
//  ViewController.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 28/02/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeScrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 175)
        let scrollViewWidth: CGFloat = self.mainScrollView.frame.width
        let scrollViewHeight: CGFloat = self.mainScrollView.frame.height
        
        let imgOne = UIImageView(frame: CGRect(x: self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgOne.image = UIImage(named: "CloudLighting")
        let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgTwo.image = UIImage(named: "LightRain")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth * 2 + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgThree.image = UIImage(named: "Rainy")
        let imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3 + self.mainScrollView.center.x - 50, y: weatherType.frame.maxY + 25, width: 100, height: 100))
        imgFour.image = UIImage(named: "Windy")
        
        let weatherType1 = UILabel()
        weatherType1.text = "CLOUDY"
        weatherType1.textAlignment = .center
        weatherType1.frame = weatherType.frame
        weatherType1.center.x = self.view.center.x
        
        let weatherType2 = UILabel()
        weatherType2.text = "WINDY"
        weatherType2.textAlignment = .center
        weatherType2.frame = weatherType.frame
        weatherType2.center.x = self.view.center.x + scrollViewWidth
        
        let timeLabel2 = UILabel()
        timeLabel2.text = "DAY"
        timeLabel2.textAlignment = .center
        timeLabel2.frame = timeLabel.frame
        timeLabel2.center.x = self.view.center.x + self.timeScrollView.frame.width
        
        self.mainScrollView.addSubview(imgOne)
        self.mainScrollView.addSubview(imgTwo)
        self.mainScrollView.addSubview(imgThree)
        self.mainScrollView.addSubview(imgFour)
        
        self.mainScrollView.addSubview(weatherType1)
        self.mainScrollView.addSubview(weatherType2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * 4, height: self.mainScrollView.frame.height)
        print(self.timeScrollView.frame.width)
        self.timeScrollView.contentSize = CGSize(width: self.timeScrollView.frame.width * 4, height: self.timeScrollView.frame.height)
        print(self.timeScrollView.frame.width)
        
        
        self.mainScrollView.delegate = self
        self.dayScrollView.delegate = self
        self.timeScrollView.delegate = self
        self.pageControl.currentPage = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WeatherVC
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView === mainScrollView {
            print("1")
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        } else if scrollView === dayScrollView {
            print("2")
            dayScrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        } else if scrollView == timeScrollView {
            print("3")
            timeScrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
}

