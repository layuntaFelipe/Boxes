//
//  Constants.swift
//  Boxes
//
//  Created by Felipe Lobo on 07/08/21.
//

import Foundation
import UIKit

typealias DefaultCollectionMethods = UICollectionViewDelegate & UICollectionViewDataSource
typealias DefaultTableMethods = UITableViewDelegate & UITableViewDataSource

var boxArray = [BoxItems]()

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let center = UNUserNotificationCenter.current()
let reminder = Reminders.init(center: UNUserNotificationCenter.current())
var trackingTransparency = TrackingTransparency()

let slides: [OnboardingSlide] = [
    OnboardingSlide(title: "Same But Different", description: "Experience what the other todo-list app couldn't give you. Be unique and motivated.", image: #imageLiteral(resourceName: "Image")),
    OnboardingSlide(title: "Each Box Is Special", description: "Modify each box to have it's own identity, making your tasks even more special.", image: #imageLiteral(resourceName: "Image-1")),
    OnboardingSlide(title: "Be Better Do More", description: "Create different tasks to different boxes, place deadlines, read motivational quotes. Do more tasks, be the better version of yourself", image: #imageLiteral(resourceName: "Image-2"))
]
