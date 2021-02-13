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
    
    var itemArray = [ToDoItems]()
    
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

    }

    //MARK: - Tableview Datasource Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        
        let item = itemArray[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        cell.backgroundColor = UIColor.clear
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.text
        if item.hasDeadLine {
            cell.redView.isHidden = false
            cell.endDateLabel.text = dateFormatter.string(from: item.endDate!)
        } else {
            cell.redView.isHidden =  true
            //Search about Date Formating into a custom String
        }
        cell.circleImageView.image = item.done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            // edit vc code
            print("edit \(indexPath.row)")
            handler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            tableView.beginUpdates()
            
            self.deleteItem(item: self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            handler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
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
        //Every time you change the database, call this:
        self.saveItems()
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
    
    func createItem(title: String, text: String, deadLine: Bool, endDate: Date) {
        let newItem = ToDoItems(context: context)
        newItem.title = title
        newItem.done = false
        newItem.text = text
        newItem.date = Date()
        newItem.hasDeadLine = deadLine
        if newItem.hasDeadLine {
            newItem.endDate = endDate
        }
        newItem.parentCategory = selectedCategory
        // The endDate is NOT changing as the DatePicker Changes!
        print("The newItem endDate is: \(newItem.endDate)")
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
    
    @IBAction func unwindToItems(_ sender: UIStoryboardSegue) {}

}
