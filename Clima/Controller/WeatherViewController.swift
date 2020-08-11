//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManger.requestWhenInUseAuthorization() //pop up, plist
        // does not return anything, it calls locationManager (didUpdateLocations) method once it finds lcoation
        // this is why we must implement didUpdateLocation and didFailWithError
        locationManger.requestLocation()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManger.requestLocation()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
    }
    
    // trap user in edit mode
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type city name"
            return false
        }
    }
    
    // detects when the text field ends editing, good place to grab what user typed in before we reset the text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController:WeatherManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    // called in WeatherManager after we are done parsing JSON data and get back a WeatherModel
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempStr
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

//MARK: - CLLocationManagerDelegate

// these two methods get called with the requestLocation call automatically
extension WeatherViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude:lat, longitute:lon)  // updates the UI through didUpdateWeather
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

