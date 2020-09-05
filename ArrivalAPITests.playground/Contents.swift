import Alamofire
let af = Alamofire.AF
struct ApiService {
    
    let auth: String
    
  func  getStations() {
        Alamofire.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }
    
}
let api =  ApiService(auth: "test")

api.getStations()
