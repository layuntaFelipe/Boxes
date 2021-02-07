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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var quoteView: UILabel!
    
    var uiColors = [UIColor.green, UIColor.blue, UIColor.white, UIColor.systemPink]
    var boxArray = [BoxItems]()
    var quotes = Quotes()
    var titleNavigation = String()
    
    var boxNumber = Int()
    
    var isToDelete = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        quoteView.text = quotes.getRandomQuote()
        
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getAllBoxes()
        
    }

    //MARK: - Model Manupulation Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var nameTextField = UITextField()

        var iconTextField = UITextField()

        let alert = UIAlertController(title: "Add New Box", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Box", style: .default) { (action) in
            
            if nameTextField.text == nil || nameTextField.text == "" {
                Alert.alertNoTitle(on: self, with: "What? No Title?", message: "How would you put something on nothing?... Serious man, get help... ;)")
            } else {
                self.createBox(name: nameTextField.text!, icon: iconTextField.text!)
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .destructive, handler: nil)

        alert.addTextField { (textField) in
            textField.placeholder = "Icon"
            iconTextField = textField
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Title"
            nameTextField = textField
        }



        alert.addAction(cancel)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Edit button clicked")
        
        isToDelete.toggle()
        collectionView.reloadData()
        
        if isToDelete {
            sender.image = UIImage.init(systemName: "trash.fill")
            self.navItems.title = "Editing Mode"
        } else {
            sender.image = UIImage.init(systemName: "trash")
            self.navItems.title = "Boxes"
        }
        
    }
    
    
    //MARK: - Model Manupulation Methods
    
    func getAllBoxes(with request: NSFetchRequest<BoxItems> = BoxItems.fetchRequest()) {
        do {
            boxArray = try context.fetch(request)
        } catch {
            print("Error fetching allBoxes : \(error)")
        }
    }
    
    func createBox(name: String, icon: String) {
        let newBox = BoxItems(context: context)
        newBox.name = name
        newBox.icon = icon
        newBox.number = 0
        boxArray.append(newBox)
        self.collectionView.reloadData()
        
        do {
            try context.save()
        } catch {
            print("Error creating and saving new box :\(error)")
        }

    }
    
    func deleteBox(box: BoxItems) {
        
        context.delete(box)
        
        do {
            try context.save()
        } catch {
            print("Error deleting box: \(error)")
        }
        
        self.collectionView.reloadData()
    }
    
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
            
            let alert = UIAlertController(title: "Delete Box?", message: "Do You Really Want To Delete This Box and All It Has Inside?", preferredStyle: .alert)
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
        itemsOfTheBox.selectedCategory = box
        print("Box Name: \(box.name) and box number of items: \(itemsOfTheBox.itemArray.count)")
        
        cell.titleView?.text = box.name
        cell.iconView?.text = box.icon
        cell.numberView.text = String(itemsOfTheBox.itemArray.count)
        
        if isToDelete {
            cell.numberView.text = "-"
        } else {
            cell.numberView.text = String(box.number)
        }
        
        return cell
        
    }
}
