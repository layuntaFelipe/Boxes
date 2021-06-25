//
//  TrackingTransparencyManager.swift
//  Boxes
//
//  Created by Felipe Lobo on 25/06/21.
//

import Foundation
import UIKit
import AppTrackingTransparency

struct TrackingTransparency {
    func initiateTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
               break
            case .denied:
                break
            case .authorized:
                print("Allowed")
                break
            default:
                break
            }
        }
    }
}
