//
//  SideMenu.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 22/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController, WeatherDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let weatherVC: WeatherVC = WeatherVC()
    var arrCity: [String] = [String]()
    var arrTemp: [String] = [String]()
    
    override func viewDidLoad() {
        weatherVC.weatherDelegate = self
        
        arrCity = weatherVC.getCities()
        arrCity.removeLast()
    }
    
    func doSomething() {
        print("something")
    }
    
    func sendTemperature(temp: [String]) {
        print("temp: \(temp)")
        arrTemp = temp
        //self.collectionView.reloadData()
    }
}

extension SideMenuVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCell
        
        cell?.city.text = arrCity[indexPath.row]
        if arrTemp.count > 0 {
            cell?.temperature.text = arrTemp[indexPath.row]
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2 - 5
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
