//
//  SceneLocationEstimate.swift


import Foundation
import CoreLocation
import SceneKit

class SceneLocationEstimate {
    let location: CLLocation
    let position: SCNVector3
    
    init(location: CLLocation, position: SCNVector3) {
        self.location = location
        self.position = position
    }
}
