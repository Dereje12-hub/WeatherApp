//
//  HomepageViewController.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//

import UIKit
import SwiftUI

class HomepageViewController: UIViewController
{
    @IBOutlet weak var textfieldWeather: UITextField!
    @IBOutlet weak var buttonSearchWeather: UIButton!
    @IBOutlet weak var labelCityName: UILabel!

    @IBOutlet weak var labelTempC: UILabel!
    @IBOutlet weak var labelTempF: UILabel!
    
    @IBOutlet weak var labelLongitude: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherType: UILabel!
    
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var pressureImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var dayCycleImageView: UIImageView!
    
    
    //@IBOutlet weak var weatherCollectionView: UICollectionView!
    
    
    let city = UserDefaults.standard            //MARK: userdefault to hold city name

    let getLocation = Location()                //MARK: getting user location

    var lat: Double = 0.0
    var lon: Double = 0.0
    
    private var viewModel : WeatherViewModel!      //MARK: viewModel object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfieldWeather.delegate = self
        //weatherCollectionView.delegate = self
        //weatherCollectionView.dataSource = self
        viewModel = WeatherViewModel()                   //MARK: Initialize the object
       //setUPView()
        if city.value(forKey: "City") == nil {
            defaultLocation()                           //MARK: Get default location for lat and lon
        }
        else {
        //getWeatherByCityName
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if (6...18).contains(Calendar.current.component(.hour, from: Date())) {
            let image = UIImage(named: "day")
            self.dayCycleImageView.image = image
        } else {
            let image = UIImage(named: "night")
            self.dayCycleImageView.image = image
        }
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        
        
        if city.value(forKey: "City") == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                print("lat => \(self!.lat)")
                 // Default Atlanta location lon: , lat: 33.749
                self?.viewModel?.getWeatherByLocation(lat: self?.lat ?? 33.749, lon: self?.lon ?? -84.388)             //MARK: getWeatherByLocation
                //viewModel?.getWeeklyWeatherByLocation(lat: self.lat, lon: self.lon)             //MARK: getWeeklyWeatherByLocation
                self!.updateUI()                                                                   //MARK: update UI
                //perform(#selector(updateUIUsingLocation), with: nil, afterDelay: 2)
            }
        }
        else{
            
            viewModel?.getWeatherByCityName(cityName: city.string(forKey: "City")!)        //MARK: getWeatherByCity
            getLatLong()
           // viewModel?.getWeeklyWeatherByLocation(lat: self.lat, lon: self.lon)             //MARK: getWeeklyWeatherByLocation
          
            updateUI()                                                                      //MARK: update UI
           //perform(#selector(updateUIUsingLocation), with: nil, afterDelay: 2)
        }
        
    }
    
    //Function to to set the location
    func defaultLocation() {
        getLocation.run {
            if let location = $0 {
                self.lat = location.coordinate.latitude
                self.lon = location.coordinate.longitude
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
            }
            else {
                print("Get Locations failed \(String(describing: self.getLocation.didFailWithError))")
            }
        }
    }
    
    
    @IBAction func buttonSearchWeatherTapped(_ sender: Any) {
        
        let inputCity = textfieldWeather.text

        if let searchCity  = inputCity{                    //MARK: Unwrap optionals

            if searchCity.count == 0 {                         //MARK: Notify to user the search bar is empty
                print("search bar is empty")
            }
            //else if viewModel.isError {
            else if !isUSCity(userInput: searchCity) {             //MARK: check the userInput string is not US String
                                                                    //MARK: Navigate to SwiftUI to show the input is not found in db
                //Create the object
                let swiftUIScreen = UIHostingController(rootView: SwiftUIErrorView(navigateController: nil))
                
                //MARK: UIHostingController will gives us one screen that is embeded as rootView and we will be able to navigate using navigation controller
                 self.navigationController?.pushViewController(swiftUIScreen, animated: true)

                print("Input is not found in the db!")
                viewModel.isError = false
                //return
            } else {
                viewModel?.getWeatherByCityName(cityName: searchCity)
                updateUI()
                city.set(searchCity, forKey: "City")
            }
            
            textfieldWeather.text = ""                                  //MARK: Clear the search text field
        }
    
    }
    
    
    func updateUI(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            
            self.labelCityName.text = self.viewModel.weatherList.first?.name ?? "N/A"
            let tempinDC = (self.viewModel.weatherList.first?.main.temp ?? 0) - 273
            let tempinF = tempinDC * 9/5 + 32
            self.labelTempC.text = String( "\(round(tempinDC * 100) / 100.0) °C" )
            self.labelTempF.text = String( "\(round(tempinF * 100) / 100.0) °F" )
            self.labelLatitude.text = String("lat = \(self.viewModel.weatherList.first?.coord.lat ?? 0.0)")
            self.labelLongitude.text = String("lon = \(self.viewModel.weatherList.first?.coord.lon ?? 0.0)")
            let weatherIcon = "https://openweathermap.org/img/wn/\(self.viewModel.weatherList.first?.weather.first?.icon ?? "0")@4x.png"
            self.weatherIcon.load(urlString: weatherIcon)
            self.weatherType.text = String(self.viewModel.weatherList.first?.weather.first?.main ?? "N/A")
            //let windIcon = "https://openweathermap.org/img/wn/\(self.viewModel.weatherList[0].wind.)@4x.png"
           // self.windImage.load(urlString: windIcon)
            self.windLabel.text = String(self.viewModel.weatherList.first?.wind.speed ?? 0.0)

            //let pressureIcon = "https://openweathermap.org/img/wn/\(self.viewModel.weatherList[0].main.pressure)@4x.png"
           // self.pressureImage.load(urlString: pressureIcon)
            self.pressureLabel.text = String(self.viewModel.weatherList.first?.main.pressure ?? 0)

            //let humidityIcon = "https://openweathermap.org/img/wn/\(self.viewModel.weatherList[0].main.pressure)@4x.png"
           // self.humidityImage.load(urlString: pressureIcon)
            self.humidityLabel.text = String(self.viewModel.weatherList.first?.main.humidity ?? 0)
            
        }
    }
    
    func getLatLong(){
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.lat = self.viewModel.weatherList.first?.coord.lat ?? 0.0        //MARK: Set the lat for the city previously safed
            self.lon = self.viewModel.weatherList.first?.coord.lon ?? 0.0        //MARK: Set the lon for the city previously safed
            
        }
    }
    
    
    func isUSCity(userInput: String) -> Bool {
    
        var isCity:Bool = false
        
        let userlowercase = userInput.lowercased()
        let arrayUSCity = ["chicago", "atlanta", "houston", "phoenix", "philadelphia", "texas" ]
        if arrayUSCity.contains(userlowercase){
            isCity = true
        }
        else {
            isCity = false
        }
        return isCity
    }
}



extension HomepageViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // search.endEditing(true)
        print(textfieldWeather.text!)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textfieldWeather.text != ""
        {
            return true
        }
        else
        {
            textfieldWeather.placeholder = "Enter the US city"
            return false
        }
    }

}


extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global().async{[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                  }
                
               }
            }
        }
    }
}

/*
extension HomepageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let weatherForecast = weatherForecast[indexPath.row + 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        cell.weatherDay.text = viewModel.weeklyWeatherList[indexPath.item]
        cell.weatherTemp.text = "Temp"
        cell.weatherImage.image = UIImage(named: "day")
        return cell
    }


}
*/



