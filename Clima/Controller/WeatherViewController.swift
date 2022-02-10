//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        
        searchTextField.delegate = self// text friel should report back to ViewContrl
    }

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

