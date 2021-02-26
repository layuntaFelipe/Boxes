//
//  ViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData

class BoxesViewController: UIViewController {
    @IBOutlet weak var navItems: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var quoteView: UILabel?
    
    var boxArray = [BoxItems]()
    var quotes = Quotes()
    var titleNavigation = String()
    
    var boxNumber = Int()
    
    var isToDelete = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("CollectionView reloading data!")
        collectionView?.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Get a random quote and show on view
        quoteView?.text = quotes.getRandomQuote()
        
        collectionView?.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // CoreData read box data and show up on view
        getAllBoxes()
        
    }

    //MARK: - Buttons Models
    
    let alertService = AlertService()
    
    //Add Button - To create New Boxes
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let customAlertVC = alertService.alert()
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
        } catch {
            print("Error fetching allBoxes : \(error)")
        }
    }
    
    // Func Write to CoreData a BoxItem, append to the boxArray the new Box
    func createBox(name: String, icon: String) {
        let newBox = BoxItems(context: context)
        newBox.name = name
        newBox.icon = icon
        newBox.number = 0
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

//MARK: - CollectionView Delegate Methods
extension BoxesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if !isToDelete {
            print("Hi, my name is: \(String(describing: boxArray[indexPath.row].name))")
            titleNavigation = boxArray[indexPath.row].name!
            
            boxNumber = indexPath.row
            print("boxNumber is: \(boxNumber)")
            
            performSegue(withIdentifier: "CategoryToItem", sender: self)
        } else {
            
            let alert = UIAlertController(title: "Delete Box?", message: "Are You Sure You Want To Delete \(boxArray[indexPath.row].name!) Box?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("I'm going to delete this box")
                let itemsOfTheBox = ItemsTableViewController()
                itemsOfTheBox.selectedCategory = self.boxArray[indexPath.row]
                for item in itemsOfTheBox.itemArray {
                    print("deleting a item:")
                    itemsOfTheBox.deleteItem(item: item)
                }
                self.deleteBox(box: self.boxArray[indexPath.row])
                self.boxArray.remove(at: indexPath.row)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToItem" {
            let destinationVC = segue.destination as! ItemsTableViewController
            destinationVC.navItem!.title = "\(titleNavigation) Items"
            destinationVC.selectedCategory = boxArray[boxNumber]
        }
    }
    
}

//MARK: - CollectionView DataSource Methods
extension BoxesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        let box = boxArray[indexPath.row]
        
        print("Creating Boxes")
        let itemsOfTheBox = ItemsTableViewController()
        itemsOfTheBox.selectedCategory = boxArray[indexPath.row]
        print("Box Name: \(String(describing: box.name)) and box number of items: \(itemsOfTheBox.itemArray.count)")
        
        box.number = Int64(itemsOfTheBox.itemArray.count)
        
        cell.titleView?.text = box.name
        cell.iconView?.text = box.icon
        cell.numberView.text = String(box.number)
        
        if isToDelete {
            cell.numberView.text = "-"
        } else {
            cell.numberView.text = String(box.number)
        }
        
        return cell
        
    }
}

class EmojiTextField: UITextField {

       // required for iOS 13
       override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

        override var textInputMode: UITextInputMode? {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
            return nil
        }

    override init(frame: CGRect) {
            super.init(frame: frame)

            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)

             commonInit()
        }

        func commonInit() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(inputModeDidChange),
                                                   name: UITextInputMode.currentInputModeDidChangeNotification,
                                                   object: nil)
        }

        @objc func inputModeDidChange(_ notification: Notification) {
            guard isFirstResponder else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.reloadInputViews()
            }
        }
    
    
    
    }
