//
//  ViewController.swift
//  TryAPI
//
//  Created by Karina Widyastuti on 06/08/20.
//  Copyright © 2020 Karina Widyastuti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherAPI()
    }
 
    func fetchWeatherAPI(){
        guard let apiURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=439d4b804bc8187953eb36d2a8c26a02") else {return}
        
        URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data else {return}
            
            do{
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(weatherAPI.self, from: data)
                
                let description = weatherData.weather?[0].description ?? "0"
                DispatchQueue.main.async {
                    self.labelDesc.text = "\(description)"
                }
                
                let temp = weatherData.main?.temp ?? 0
                DispatchQueue.main.async {
                    self.labelTemp.text = "\(temp)"
                }
                
                print(weatherData.main?.temp)
                print(weatherData.weather?.description)
                
            } catch let err{
                print("Error: ", err)
            }
            
        }.resume()
    }
}

struct weatherAPI: Codable {
    let main: Main?
    let weather: [Weather]?
    
    private enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}

struct Main: Codable {
    let temp: Float?
    let humidity: Int?
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}

struct Weather: Codable {
    let description: String?

    private enum CodingKeys: String, CodingKey {
    case description
}

}
