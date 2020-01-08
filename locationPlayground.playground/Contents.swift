import UIKit
import CoreLocation


let coordinate₀ = CLLocation(latitude: 5.0, longitude: 5.0)
let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)

let distanceInMeters = coordinate₀.distance(from: coordinate₁)
print(distanceInMeters)
