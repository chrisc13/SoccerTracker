//
//  Weather.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/13/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import Foundation
struct Root: Codable {
    let weatherObservation: WeatherObservation
}
struct WeatherObservation: Codable {
    let elevation: Int?
    let lng: Double?
    let observation: String?
    let ICAO: String?
    let clouds: String?
    let dewPoint: String?
    let cloudsCode: String?
    let datetime: String?
    let countryCode: String?
    let temperature: String?
    let humidity: Int?
    let stationName: String?
    let weatherCondition: String?
    let windDirection: Int?
    let hectoPascAltimeter: Int?
    let windSpeed: String?
    let lat: Double?
   
    
    
}
//var serverData = String ()
var temperature: String? = nil


func getJson(lat:Double, long: Double, completion: @escaping (String, String, Int) -> ()){
   
    let flag = DispatchSemaphore(value: 0)
    
    let first = "http://api.geonames.org/findNearByWeatherJSON?"
  
    let la = "lat="+lat.description+"&"
    let lo = "lng="+long.description+"&username="
    //enter username below m9
    let last = "chrisc03774"
    
    
    let jSonUrlString = first+la+lo+last
    
    //guard let url = URL(string: jSonUrlString) else {return}
    
    if let url = URL(string: jSonUrlString){
        
        URLSession.shared.dataTask(with: url ){ (data, response, err) in
            
            guard let data = data  else {return}
            
            do {
                let result = try JSONDecoder().decode(Root.self, from: data)
             
                flag.signal()
           completion(result.weatherObservation.temperature!,result.weatherObservation.windSpeed!,result.weatherObservation.humidity!)
             
            }
            catch let jsonErr {
                print("Error", jsonErr)
                
            }
            }.resume()
        flag.wait()
    }
    
}
    

