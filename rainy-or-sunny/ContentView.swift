import SwiftUI
import Combine

struct ContentView: View {
    @State private var zip = ""
    @State private var weather: String? = nil
    
    var body: some View {
        ZStack {
            Color("light-yellow")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                    .frame(height:50)
                Text("Rainy Or Sunny?")
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(.blue)
                
                TextField("Enter ZIP code", text: $zip)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: checkWeather) {
                    Text("Check Weather")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let weather = weather {
                    switch weather {
                    case "Rain":
                        VStack {
                            Image("umbrella") // Make sure to add the image to your Assets.xcassets
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("Grab an umbrella!")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    default:
                        VStack {
                            Image("sun") // Make sure to add the image to your Assets.xcassets
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("Soak in the sun!")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    func checkWeather() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&appid=2894a53f30085c9063c00a0a27f9c6d0"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch weather with error: ", error)
                return
            }
            
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                   let weatherArray = json["weather"] as? [[String: Any]],
                   let weatherDict = weatherArray.first,
                   let weather = weatherDict["main"] as? String {
                    DispatchQueue.main.async {
                        self.weather = weather
                    }
                }
            } catch let jsonError {
                print("Failed to decode JSON with error: ", jsonError)
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
