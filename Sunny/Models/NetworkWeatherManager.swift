//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by marinapolyakova on 14.01.2023.
//  
//

import Foundation
import CoreLocation


class NetworkWeatherManager{
    
    
    enum RequestType{
        case cityName(city: String)
        case coordinate(latitude : CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    
    func fetchCurrentWeather(forRequestType requestType: RequestType){
        var urlString = ""
        
        switch requestType{
            
        case .cityName(city: let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(latitude: let latitude, longitude: let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        perfomRequest(withURLString: urlString)
    }
    
    
    
    func perfomRequest(withURLString urlString: String){
        guard let url = URL(string: urlString) else {return}
 
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather =  self.parseJSON(withData: data){
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do{
          let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        }catch let error as NSError{
            print(error.localizedDescription)
            
        }
        return nil
    }
    
}


