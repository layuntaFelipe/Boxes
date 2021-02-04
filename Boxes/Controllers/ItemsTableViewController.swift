//
//  ItemsTableViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {
    
    @IBOutlet weak var navItem: UINavigationItem?
    
    var title2 = String()
    var itemArray = [ToDoItems]()
    var testArray = [ToDoItems]()
    
    var namesArray = [String]()
    
    var selectedCategory: BoxItems? {
        didSet {
            getAllItems()
            tableView.reloadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getAllItems()

    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Teranry Operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            deleteItem(item: itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("The \(itemArray[indexPath.row].title!) has \(itemArray[indexPath.row].text!)")
        
        itemArray[indexPath.row].done.toggle()
        
        if itemArray[indexPath.row].done == true {
            print("YEEE IT's DONE")
        }
        
        self.tableView.reloadData()
        
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
    
    func createItem(title: String, text: String, endDate: Date?) {
        let newItem = ToDoItems(context: context)
        newItem.title = title
        newItem.done = false
        newItem.text = text
        newItem.date = Date()
        if endDate != nil {
            newItem.endDate = endDate
        }
        newItem.parentCategory = selectedCategory
        print(newItem.title!)
        print(newItem.text!)
        itemArray.append(newItem)
        self.tableView.reloadData()
        
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
    
    func updateBox(item: ToDoItems, newTitle: String) {
        item.title = newTitle
        
        do {
            try context.save()
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
//        var titleField = UITextField()
//        var textView = UITextField()
//
//        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
//
//        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            //what will happen once the user clicks the Add Item Button on our UIAlert
//
//            //Create a new Object of type NSManagedObject -> which is a row in our database
//            //By creating the Class, it already has all the properties information we've specified
//            //In this case: Title and Done
//            self.createItem(title: titleField.text!, text: textView.text!)
//
//            //After creating we save our Items
//            //It looks at the items in the temporary area, and save the context to our persistent store("database")
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "title"
//            titleField = alertTextField
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "text"
//            textView = alertTextField
//        }
//
//        alert.addAction(cancel)
//        alert.addAction(action)
//
//        present(alert, animated: true, completion: nil)
        
        performSegue(withIdentifier: "createNewItem", sender: self)
        
    }
    
    @IBAction func unwindToItems(_ sender: UIStoryboardSegue) {
        
    }

}
