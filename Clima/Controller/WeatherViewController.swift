//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    var weatherManger = WeatherManager()
    
    let locationMangager = CLLocationManager()
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangager.delegate = self
        textField.delegate = self
        weatherManger.delegate = self
        locationMangager.requestLocation()
        locationMangager.requestWhenInUseAuthorization()
        weatherManger.fetchData(cityName: "london")
        
    }
    
    
    @IBAction func seachButton(_ sender: Any) {
        
        weatherManger.fetchData(cityName: textField.text!)
        DispatchQueue.main.async {
            
        }
        
        textField.endEditing(true)
    }
    
    
    @IBAction func locationButton(_ sender: UIButton) {
          locationMangager.requestLocation()
    }
    
    
}
//MARK: - textfieldDelegate
extension WeatherViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManger.fetchData(cityName: textField.text!)
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
//MARK: - weatherDelegate
extension WeatherViewController:WeatherDelegate {
    func weather(weather: WeatherData) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.name
            self.temperatureLabel.text = "\(weather.main.temp)"
            self.conditionImageView.image = UIImage(systemName:  weather.conditionName)
        }
        
    }
}


//MARK: - CLLocasionManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("good location")
        
        if let location = locations.last {
            locationMangager.stopUpdatingLocation()
            let lat =  location.coordinate.latitude
            let lon = location.coordinate.longitude
          
            weatherManger.fetchData(latitide: lat, longitude: lon)
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
