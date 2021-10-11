//
//  WeatherManager.swift
//  Clima
//
//  Created by majid mohmed on 9/12/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func weather(weather:WeatherData)
   
}
struct WeatherManager {
    
    var delegate:WeatherDelegate?

    let urlst = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=b9ee0f5db2232f70c382f93502852963"
    
    
     func fetchData(cityName:String) {
        let urlString = "\(urlst)&q=\(cityName)"
        requestData(urlStr: urlString)
    }
  
    func fetchData(latitide:CLLocationDegrees,longitude:CLLocationDegrees )  {
           let urlString = "\(urlst)&lat=\(latitide)&lon=\(longitude)"
        print(urlString)
             requestData(urlStr: urlString)
    }
        func requestData(urlStr:String) {
            // 1- create url
            if let url = URL(string: urlStr) {
                    // 2- Create urlSession
                    let session = URLSession(configuration: .default)
                    // 3- give session a task
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            print("Error fetching Data. \(error!)")
                            return
                        }
                        if let safeData = data {
                            if let dataString = String(data: safeData, encoding: .utf8) {
                                 print(dataString)
                            }else {
                                print("Can't convert Data to sting ...")
                            }
                           
                            let decoder = JSONDecoder()
                            do {
                             let dataDecoded = try decoder.decode(WeatherData.self, from: safeData)
                                
                                self.delegate?.weather(weather: dataDecoded)
                                print("decoded data her .......")
                                print(dataDecoded)
                                /*
                                print(dataDecoded.main.temp)
                                print(dataDecoded.weather.description)
                                */
                            }catch {
                                print("can't decoded data...\(error)")
                            }
                         
                        }
                    }
                    // 4= resume task
                    task.resume()
                }
                
            }
        
        
    
}
