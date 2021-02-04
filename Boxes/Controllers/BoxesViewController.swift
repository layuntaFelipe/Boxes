//
//  ViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData

class BoxesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var quoteView: UILabel!
    
    var uiColors = [UIColor.green, UIColor.blue, UIColor.white, UIColor.systemPink]
    var boxArray = [BoxItems]()
    var quotes = Quotes()
    var titleNavigation = String()
    
    var boxNumber = Int()
    
    var testNumber = Int()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let itemsView = ItemsTableViewController()
        testNumber = itemsView.getAllItemsTest() ?? 0
        
        DispatchQueue.main.async {
            for item in self.boxArray {
                self.updateBox(box: item, newNumber: self.testNumber)
            }
            self.collectionView.reloadData()
        }
        
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

            self.createBox(name: nameTextField.text!, icon: iconTextField.text!)
//            let newBox = BoxListItem()
//            newBox.name = nameTextField.text!
//            newBox.icon = iconTextField.text!
//            self.test.append(newBox)
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
        
//        let cellBox = MyCollectionViewCell()
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
        print("Hi, my name is: \(String(describing: boxArray[indexPath.row].name))")
        titleNavigation = boxArray[indexPath.row].name!
        
        boxNumber = indexPath.row
        print("boxNumber is: \(boxNumber)")
        
        performSegue(withIdentifier: "CategoryToItem", sender: self)
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
        
        cell.titleView?.text = box.name
        cell.iconView?.text = box.icon
        cell.numberView.text = String(box.number)
        
        return cell
        
    }
}
