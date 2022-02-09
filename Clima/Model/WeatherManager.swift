//
//  WeatherManager.swift
//  Clima
//
//  Created by Aiperim Akisheva on 2/3/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9de313c6c13d72e287e4a7d5611cb80e&units=metric"
    
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // step1. create a URL
        if let url = URL(string: urlString) {
            // step2. create a URLSession
            let session = URLSession(configuration: .default)
            
            // STEP3. GIVE THE SESSIAOn a task
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJASON(weatherData: safeData)
                    
                }
            }
            // step4. start the task
            task.resume()
            
        }
    }
    
    func parseJASON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
            
        } catch {
            print(error)
        }
    }
    
}





