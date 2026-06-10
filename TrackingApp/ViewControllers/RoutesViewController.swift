//
//  RoutesViewController.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import UIKit

class RoutesViewController: UIViewController {

    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var stopTrackingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshButtonsStatus()
    }
    
    func refreshButtonsStatus(){
        if LocationService.shared.isTracking {
            startTrackingButton.isEnabled = false
            stopTrackingButton.isEnabled = true
        }else{
            startTrackingButton.isEnabled = true
            stopTrackingButton.isEnabled = false
        }
    }

    @IBAction func startTracking(_ sender: Any) {
        LocationService.shared.startTracking()
        refreshButtonsStatus( )
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        LocationService.shared.stopTracking()
        refreshButtonsStatus( )
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
