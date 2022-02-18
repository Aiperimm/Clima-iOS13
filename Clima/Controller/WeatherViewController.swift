//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self// text friel should report back to ViewContrl
    }
    
}

// MARK: - UITextFieldDelegate//

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // <-- this code will tell the seacrh we are done with editing!and u can dissmiss the keyboard.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  // <-- text field will say to ViewContrl, the user pressed the return key in the keyboard..
        searchTextField.endEditing(true) // <-- this code will tell the seacrh we are done with editing!and u can dissmiss the keyboard.
        return true  // we have to returnn true because this func expects a boolean output
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something" // its reminding user to type here
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) { // <-- this code says to ViewContrl that user stopped editing
        //  use searchTextField.text to get weather for that city.
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}
    // MARK: - WeatherManagerDelegate
    
    extension WeatherViewController: WeatherManagerDelegate {
        
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            }
        }
        func didFailWithError(error: Error) {
            print(error)
        }
    }


// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
