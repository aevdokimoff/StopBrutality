//
//  ViewController.swift
//  EpiTracker
//
//  Created by Artem Evdokimov on 22.05.20.
//  Copyright © 2020 Artem Evdokimov. All rights reserved.
//

import UIKit
import MapKit
import LFHeatMap
import SPAlert

class CaseEntryCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var selectCaseType: UITextField!
    @IBOutlet weak var casesCountEnclosureView: UIView!
    @IBOutlet weak var casesCountEnclosureVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Globals
    let kLatitude = "latitude"
    let kLongitude = "longitude"
    let kMagnitude = "magnitude"
    
    let localtions = NSMutableArray()
    var imageView = UIImageView()
    let weights = NSMutableArray()
    let locationManager = CLLocationManager()
    
    fileprivate let selectCaseTypePickerView = ToolbarPickerView()
    fileprivate let caseTypes = ["Police Brutality", "Racism", "Discrimination"]
    let cellReuseIdentifier = "cell"

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        
        self.setupKeyboard()
        self.setupTextFieldAndPickerViews()
        self.setupNotifications()
        self.setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupViews()
    }
    
    // MARK: - UI
    func setupViews() {
        self.casesCountEnclosureVisualEffectView.layer.cornerRadius = 10.0
        self.casesCountEnclosureVisualEffectView.layer.masksToBounds = true
        self.casesCountEnclosureView.addShadow(offset: CGSize.zero, color: UIColor.black, radius: 8.0, opacity: 0.15)
    }
    
    func setupKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupTextFieldAndPickerViews() {
        // TextFields
        self.selectCaseType.text = self.caseTypes[0]
        self.selectCaseType.inputView = self.selectCaseTypePickerView
        self.selectCaseType.inputAccessoryView = self.selectCaseTypePickerView.toolbar

        // PickerViews
        self.selectCaseTypePickerView.dataSource = self
        self.selectCaseTypePickerView.delegate = self
        self.selectCaseTypePickerView.toolbarDelegate = self
        
        self.selectCaseTypePickerView.reloadAllComponents()
        self.selectCaseTypePickerView.tag = 0
    }
    
    // MARK: - Notifications
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Map
    func setupMap() {
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        
        let dataFile = Bundle.main.path(forResource: "data", ofType: "plist")!
        let caseeData = NSArray(contentsOfFile: dataFile) as! [Dictionary<String, Any>]
        
        for casee in caseeData {
            let latitude: CLLocationDegrees = casee[kLatitude] as! CLLocationDegrees
            let longtitude: CLLocationDegrees = casee[kLongitude] as! CLLocationDegrees
            let magnitude = Double("\(casee[kMagnitude]!)")
            let location = CLLocation(latitude: latitude, longitude: longtitude)
            self.localtions.add(location)
            self.weights.add(Int(magnitude! * 10))
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 13.0)
        let center = CLLocationCoordinate2D(latitude: 39.0, longitude: -77.0)
        self.mapView.region = MKCoordinateRegion(center: center, span: span)
        
        self.imageView = UIImageView(frame: mapView.frame)
        self.imageView.contentMode = .center
        self.view.insertSubview(self.imageView, at: 1)
        let heatMap = LFHeatMap.heatMap(for: self.mapView, boost: 0.5, locations: self.localtions as? [Any], weights: self.weights as? [Any])
        self.imageView.image = heatMap
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let heatMap = LFHeatMap.heatMap(for: self.mapView, boost: 0.5, locations: self.localtions as? [Any], weights: self.weights as? [Any])
        self.imageView.image = heatMap
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                print(city + ", " + country)
            }
        }
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockPosts.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CaseEntryCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CaseEntryCell
        cell.title.text = mockPosts[indexPath.row].title
        cell.date.text = mockPosts[indexPath.row].date
        cell.desc.text = mockPosts[indexPath.row].descr
        cell.commentsCount.text = "\(mockPosts[indexPath.row].commentsCount)"
        cell.postImageView.image = UIImage(named: mockPosts[indexPath.row].imageName)

        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    // MARK: - Actions
    @IBAction func addNewCaseButtonDidTouch(_ sender: Any) {
        if !checkIsInAddedCaseMode() && !checkCaseAddedOnce() {
            let alertView = SPAlertView(title: "Case added", message: nil, preset: SPAlertPreset.done)
            alertView.duration = 1.0
            alertView.present()
            UserDefaults.standard.set(true, forKey: "isCaseAddedOnce")
            UserDefaults.standard.set(true, forKey: "isInAddedCaseMode")
        } else if !checkIsInAddedCaseMode() && checkCaseAddedOnce() {
            let alertView = SPAlertView(title: "Case already added", message: nil, preset: SPAlertPreset.error)
            alertView.duration = 2.5
            alertView.present()
        }
        self.setupViews()
    }
    
    @IBAction func addNewRecoveryButtonDidTouch(_ sender: Any) {
        if checkIsInAddedCaseMode() {
            let alertView = SPAlertView(title: "Recovery added", message: nil, preset: SPAlertPreset.done)
            alertView.duration = 1.0
            alertView.present()
            UserDefaults.standard.set(false, forKey: "isInAddedCaseMode")
        }
        self.setupViews()
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.caseTypes.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.caseTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
}

extension ViewController: ToolbarPickerViewDelegate {
    func didTapDone(tag: Int) {
        let row = self.selectCaseTypePickerView.selectedRow(inComponent: 0)
        self.selectCaseTypePickerView.selectRow(row, inComponent: 0, animated: false)
        self.selectCaseType.text = self.caseTypes[row]
        self.selectCaseType.resignFirstResponder()
        
    }

    func didTapCancel(tag: Int) {
        self.selectCaseType.text = nil
        self.selectCaseType.resignFirstResponder()
    }
}
