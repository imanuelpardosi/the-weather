//
//  SideMenu.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 22/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if allTemperature.count > 0 {
            print(allWeatherType)
            self.collectionView.reloadData()
        }
    }
}

extension SideMenuVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(allCities)
        return allCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCell
        
        cell?.city.text = allCities[indexPath.item]
        if allTemperature.count > 0 {
            cell?.temperature.text = allTemperature[indexPath.item]
        }
        if allWeatherType.count > 0 {
            cell?.weatherImage.image = UIImage(named: "\(allWeatherType[indexPath.item])")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        setCurrentPage = indexPath.item
        self.sideMenuViewController!.hideMenuViewController()
    }
}
