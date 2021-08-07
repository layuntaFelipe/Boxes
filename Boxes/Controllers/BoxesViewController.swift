//
//  ViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData
import ChameleonFramework

class BoxesViewController: UIViewController {
    @IBOutlet weak var navItems: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var quoteView: UILabel?
    
    private var quotes = Quotes()
    internal var titleNavigation = String()
    internal var boxNumber = Int()
    internal var isToDelete = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.hidesBackButton = true
        let titleColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationItem.rightBarButtonItem?.tintColor = titleColor
        navigationController?.navigationBar.tintColor = titleColor
        //Adding the trackingTransparency 
        trackingTransparency.initiateTracking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("CollectionView reloading data!")
        collectionView?.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminder.requestAuthorization()
        // Get a random quote and show on view
        quoteView?.text = quotes.getRandom()
        // Get the collectionView Ready
        collectionView?.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // CoreData read box data and show up on view
        getAllBoxes()
    }

    //MARK: - Buttons Models
    
    //Add Button - To create New Boxes
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let customAlertVC = CustomBox().box()
        present(customAlertVC, animated: true)
    }
    
    // TrashCan Button - To delete Boxes
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        print("Edit button clicked")

        isToDelete.toggle()
        collectionView?.reloadData()

        if isToDelete {
            sender.image = UIImage.init(systemName: "trash.fill")
            self.navItems.title = "Editing Mode"
        } else {
            sender.image = UIImage.init(systemName: "trash")
            self.navItems.title = "Boxes"
        }
    }
    
    @IBAction func unwindToBox(_ sender: UIStoryboardSegue) {}
    
    //MARK: - CoreDate Manupulation Methods
    
    // Func Read from CoreData Class BoxItems, and make boxArray be equal to the items
    func getAllBoxes(with request: NSFetchRequest<BoxItems> = BoxItems.fetchRequest()) {
        do {
            boxArray = try context.fetch(request)
            boxArray.sort(by: {$0.date! < $1.date!})
        } catch {
            print("Error fetching allBoxes : \(error)")
        }
    }
    
    // Func Write to CoreData a BoxItem, append to the boxArray the new Box
    func createBox(name: String, icon: String, color: String) {
        let newBox = BoxItems(context: context)
        newBox.name = name
        newBox.icon = icon
        newBox.number = 0
        newBox.color = color
        newBox.date = Date()
        boxArray.append(newBox)
        self.collectionView?.reloadData()
        
        do {
            try context.save()
        } catch {
            print("Error creating and saving new box :\(error)")
        }

    }
    
    // Func to Delete a Box from CoreData and boxArray
    func deleteBox(box: BoxItems) {
        
        context.delete(box)
        
        do {
            try context.save()
        } catch {
            print("Error deleting box: \(error)")
        }
        
        self.collectionView?.reloadData()
    }
    
    // Func to Update box number of items in CoreData BoxItems
    func updateBox(box: BoxItems, newNumber: Int) {
        box.number = Int64(newNumber)
        
        do {
            try context.save()
        } catch {
            print("Error updating box: \(error)")
        }
    }
}
