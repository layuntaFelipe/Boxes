//
//  ItemsTableViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData

class ItemsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navItem: UINavigationItem?
    @IBOutlet var tableView: UITableView?
    
    var title2 = String()
    var itemArray = [ToDoItems]()
    var testArray = [ToDoItems]()
    
    var namesArray = [String]()
    
    var selectedCategory: BoxItems? {
        didSet {
            getAllItems()
            tableView?.reloadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MyTableViewCell.nib(), forCellReuseIdentifier: "MyTableViewCell")
//        getAllItems()

    }

    //MARK: - Tableview Datasource Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//
//        let item = itemArray[indexPath.row]
//
//        cell.textLabel?.text = item.title
//
//        //Teranry Operator
//        // value = condition ? valueIfTrue : valueIfFalse
//        cell.accessoryType = item.done ? .checkmark : .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        
        let item = itemArray[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.text
        cell.circleImageView.image = item.done ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            deleteItem(item: itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("The \(itemArray[indexPath.row].title!) has \(itemArray[indexPath.row].text!)")
        
        itemArray[indexPath.row].done.toggle()
        
        if itemArray[indexPath.row].done == true {
            print("YEEE IT's DONE")
        }
        
        self.tableView?.reloadData()
        
        //Deleting from database, the order matters a huge deal
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //Every time you change the database, call this:
        self.saveItems()
        
//        print(itemArray[indexPath.row].done)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving item :\(error)")
        }
    }
    
    func getAllItems(with request: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching allItems : \(error)")
        }
    }
    
    func getAllItemsTest(with request: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()) -> Int? {
        do {
            testArray = try context.fetch(request)
        } catch {
            print("Error fetching allItems : \(error)")
        }
        return testArray.count
    }
    
    func createItem(title: String, text: String) {
        let newItem = ToDoItems(context: context)
        newItem.title = title
        newItem.done = false
        newItem.text = text
        newItem.parentCategory = selectedCategory
        print(newItem.title!)
        print(newItem.text!)
        itemArray.append(newItem)
        self.tableView?.reloadData()
        
        do {
            try context.save()
        } catch {
            print("Error creating and saving new item :\(error)")
        }

    }
    
    func deleteItem(item: ToDoItems) {
        
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("Error deleting item: \(error)")
        }
        
    }
    
    func updateItem(item: ToDoItems, newTitle: String, newText: String) {
        item.title = newTitle
        item.text = newText
        
        do {
            try context.save()
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "createNewItem", sender: self)
        
    }
    
    @IBAction func unwindToItems(_ sender: UIStoryboardSegue) {
        
    }

}
