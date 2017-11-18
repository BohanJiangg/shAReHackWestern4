//
//  ViewController.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import CocoaLumberjack
import ARKit
import AWSAuthCore
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

@available(iOS 11.0, *)
class ViewController: UIViewController, MKMapViewDelegate, SceneLocationViewDelegate, ARSCNViewDelegate, UITextFieldDelegate{
         
    let sceneLocationView = SceneLocationView()
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    
    var updateUserLocationTimer: Timer?
    
    ///Whether to show a map view
    ///The initial value is respected
    var showMapView: Bool = false
    
    var centerMapOnUserLocation: Bool = true
    
    ///Whether to display some debugging data
    ///This currently displays the coordinate of the best location estimate
    ///The initial value is respected
    var displayDebugging = true
    
    var infoLabel = UILabel()
    
    var updateInfoLabelTimer: Timer?
    
    var adjustNorthByTappingSidesOfScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        sceneLocationView.scene = scene
        sceneLocationView.autoenablesDefaultLighting = true
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
        sceneLocationView.addSubview(infoLabel)
        
        /* No need for Timer */
        updateInfoLabelTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(ViewController.updateInfoLabel),
            userInfo: nil,
            repeats: true)
        
        //Set to true to display an arrow which points north.
        //Checkout the comments in the property description and on the readme on this.
        //        sceneLocationView.orientToTrueNorth = false
        
        //        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
       // sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        
        if displayDebugging {
            sceneLocationView.showFeaturePoints = true
        }
        
        //Currently set to HSOC
        let pinCoordinate = CLLocationCoordinate2D(latitude: 42.3806887, longitude: -71.124984)
        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 30)
        let pinImage = UIImage(named: "pin")!
        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
        
        view.addSubview(sceneLocationView)
        
        if showMapView {
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.alpha = 0.8
            view.addSubview(mapView)
            
            updateUserLocationTimer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(ViewController.updateUserLocation),
                userInfo: nil,
                repeats: true)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)

        
        textField.delegate = self
        view.setNeedsUpdateConstraints()
        view.addSubview(textField)
        
        let button = UIButton(type: UIButtonType.contactAdd) as UIButton
        let screenCentre : CGPoint = CGPoint(x: self.sceneLocationView.bounds.midX, y: self.sceneLocationView.bounds.midY)
        button.frame = CGRect(origin: screenCentre, size: CGSize(width: 100, height: 100))
        button.center = view.center
        button.tintColor = UIColor.white
        view.addSubview(button)
        
    }
    override func updateViewConstraints() {
        textFieldConstraints()
        super.updateViewConstraints()
    }
    
    func textFieldConstraints() {
        NSLayoutConstraint(
            item: textField,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
            .isActive = true
        
        NSLayoutConstraint(
            item: textField,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.8,
            constant: 0.0)
            .isActive = true
        
        
        NSLayoutConstraint(
            item: textField,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.1,
            constant: 0.0)
            .isActive = true
    }
    
   
    
    var textField: UITextField! = {
        let view = UITextField()
        view.placeholder = "Enter Message Here"
        view.font = UIFont.systemFont(ofSize: 15)
        view.borderStyle = UITextBorderStyle.roundedRect
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer?) {
        // HIT TEST : REAL WORLD
        // Get Screen Centre
        
        if (gestureRecognize != nil) {
        textField.isHidden = false
        textField.becomeFirstResponder()
        }
        
        
        let screenCentre : CGPoint = CGPoint(x: self.sceneLocationView.bounds.midX, y: self.sceneLocationView.bounds.midY)
        
        let arHitTestResults : [ARHitTestResult] = sceneLocationView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // Create 3D Text
            
            if closestResult.anchor != nil {
                print("HIT A PIN!")
            } else {
                // Print out coordinates
                // let node : SCNNode = createNewBubbleParentNode( "\(String(describing: worldCoord))" )
                if (textField.text! != ""){
                    // Print out coordinates
                    // let node : SCNNode = createNewBubbleParentNode( "\(String(describing: worldCoord))" )
                    
                    let node : SCNNode = createNewBubbleParentNode( "\(textField.text!)" )
                    //textFieldShouldReturn(textField)
                    textField.text=""
                    textField.isHidden = true
                    textField.resignFirstResponder()
                    node.position = worldCoord
                    sceneLocationView.scene.rootNode.addChildNode(node)
                }
            }
            // Upload coordiantes
            let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
            
            //Create data object using data models you downloaded from Mobile Hub
            let locationItem: Locations = Locations();
            
            
            // Set lat and long with Bohan's method afterwards
            locationItem.id = String(transform.columns.3.x) + String(transform.columns.3.y)
            locationItem.x = NSNumber(value: transform.columns.3.x)
            locationItem.y = NSNumber(value: transform.columns.3.y)
            locationItem.z = NSNumber(value: transform.columns.3.z)
            locationItem.comment = textField.text!
            // Save a new item
            dynamoDbObjectMapper.save(locationItem, completionHandler: {
                (error: Error?) -> Void in
                
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    return
                }
                print("A location was added.")
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleTap(gestureRecognize: nil)
        textField.text=""
        textField.isHidden = true
        textField.resignFirstResponder()
        
        // returns false. Instead of adding a line break, the text
        // field resigns
        return false
    }
    
    func createNewBubbleParentNode(_ text : String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubbleDepth : Float = 0.01
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        bubble.font = font
        bubble.alignmentMode = kCAAlignmentCenter
        bubble.firstMaterial?.diffuse.contents = UIColor.darkGray
        bubble.firstMaterial?.specular.contents = UIColor.darkGray
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(bubbleDepth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, (bubbleDepth/2) - 0.1)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
        
        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        // background NODE
        let cube = SCNBox(width: CGFloat((maxBound.x - minBound.x)/4), height: CGFloat((maxBound.y - minBound.y)/2), length: 0.01, chamferRadius: 0.01)
        bubbleNodeParent.geometry = cube
        
        return bubbleNodeParent
    }
    /**
     // MARK:- ---> Textfield Delegates
     func textFieldDidBeginEditing(textField: UITextField) {
     print("TextField did begin editing method called")
     }
     
     func textFieldDidEndEditing(textField: UITextField) {
     print("TextField did end editing method called")
     }
     
     func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
     print("TextField should begin editing method called")
     return true;
     }
     
     func textFieldShouldClear(textField: UITextField) -> Bool {
     print("TextField should clear method called")
     return true;
     }
     
     func textFieldShouldEndEditing(textField: UITextField) -> Bool {
     print("TextField should end editing method called")
     return true;
     }
     
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
     print("While entering the characters this method gets called")
     return true;
     }
     
     func textFieldShouldReturn(textField: UITextField) -> Bool {
     print("TextField should return method called")
     textField.resignFirstResponder();
     return true;
     }
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DDLogDebug("run")
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DDLogDebug("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        
        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)
        
        if showMapView {
            infoLabel.frame.origin.y = (self.view.frame.size.height / 2) - infoLabel.frame.size.height
        } else {
            infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height
        }
        
        mapView.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height / 2,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height / 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @objc func updateUserLocation() {
        if let currentLocation = sceneLocationView.currentLocation() {
            DispatchQueue.main.async {
                
                if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                    let position = self.sceneLocationView.currentScenePosition() {
                    DDLogDebug("")
                    DDLogDebug("Fetch current location")
                    DDLogDebug("best location estimate, position: \(bestEstimate.position), location: \(bestEstimate.location.coordinate), accuracy: \(bestEstimate.location.horizontalAccuracy), date: \(bestEstimate.location.timestamp)")
                    DDLogDebug("current position: \(position)")
                    
                    let translation = bestEstimate.translatedLocation(to: position)
                    
                    DDLogDebug("translation: \(translation)")
                    DDLogDebug("translated location: \(currentLocation)")
                    DDLogDebug("")
                }
                
                if self.userAnnotation == nil {
                    self.userAnnotation = MKPointAnnotation()
                    self.mapView.addAnnotation(self.userAnnotation!)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.userAnnotation?.coordinate = currentLocation.coordinate
                }, completion: nil)
                
                if self.centerMapOnUserLocation {
                    UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                    }, completion: {
                        _ in
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                    })
                }
                
                if self.displayDebugging {
                    let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()
                    
                    if bestLocationEstimate != nil {
                        if self.locationEstimateAnnotation == nil {
                            self.locationEstimateAnnotation = MKPointAnnotation()
                            self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                        }
                        
                        self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
                    } else {
                        if self.locationEstimateAnnotation != nil {
                            self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                            self.locationEstimateAnnotation = nil
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateInfoLabel() {
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }
        
        /*let date = Date()
         let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
         
         if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
         infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
         } */
    }
    
    /**  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     super.touchesBegan(touches, with: event)
     
     if let touch = touches.first {
     if touch.view != nil {
     if (mapView == touch.view! ||
     mapView.recursiveSubviews().contains(touch.view!)) {
     centerMapOnUserLocation = false
     } else {
     
     let location = touch.location(in: self.view)
     
     if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
     print("left side of the screen")
     sceneLocationView.moveSceneHeadingAntiClockwise()
     } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
     print("right side of the screen")
     sceneLocationView.moveSceneHeadingClockwise()
     } else {
     let image = UIImage(named: "pin")!
     let annotationNode = LocationAnnotationNode(location: self.sceneLocationView.bestLocationEstimate()?.location, image: image)
     annotationNode.scaleRelativeToDistance = true
     sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
     }
     }
     }
     }
     } */
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if pointAnnotation == self.userAnnotation {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "user")
            } else {
                marker.displayPriority = .required
                marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
                marker.glyphImage = UIImage(named: "compass")
            }
            
            return marker
        }
        
        return nil
    }
    
    /** RESIZING IMAGES
     func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
     // USAGE:
     // let size = CGSize(width: 100, height: 100)
     // self.resizeImage(UIImage(named: "yourImageName")!, targetSize: size)
     // THE LINE ABOVE RESIZES IMAGE TO 200*200
     let size = image.size
     
     let widthRatio  = targetSize.width  / image.size.width
     let heightRatio = targetSize.height / image.size.height
     
     // Figure out what our orientation is, and use that to form the rectangle
     var newSize: CGSize
     if(widthRatio > heightRatio) {
     newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
     } else {
     newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
     }
     
     // This is the rect that we've calculated out and this is what is actually used below
     let rect = CGRectMake(0, 0, newSize.width, newSize.height)
     
     // Actually do the resizing to the rect using the ImageContext stuff
     UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
     image.drawInRect(rect)
     let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     return newImage
     } **/
    
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        DDLogDebug("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp), altitude: \(location.altitude)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        DDLogDebug("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}
extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
