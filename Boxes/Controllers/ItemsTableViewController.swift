//
//  ItemsTableViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit
import CoreData
import UserNotifications
import ChameleonFramework

class ItemsTableViewController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem?
    @IBOutlet var tableView: UITableView?
    
    internal var itemArray = [ToDoItems]()
    
    private var itemNumber = Int()
    
    internal var namesArray = [String]()
    
    internal var selectedCategory: BoxItems? {
        didSet {
            getAllItems()
            tableView?.reloadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        guard let title = selectedCategory?.name else {
            return
        }
        navigationItem.title = "\(title) Items"
        super.viewWillAppear(animated)
        let titleColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationItem.rightBarButtonItem?.tintColor = titleColor
        navigationController?.navigationBar.tintColor = titleColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MyTableViewCell.nib(), forCellReuseIdentifier: "MyTableViewCell")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        tableView?.addGestureRecognizer(longPressGesture)

    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let pressure = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: pressure)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            HapticsManager.shared.vibrate(for: .success)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd-hh:mm"
            let popUpVC = PopUpService()
            if let safeDate = itemArray[indexPath!.row].endDate {
                self.present(popUpVC.popUp(title: itemArray[indexPath!.row].title!, description: itemArray[indexPath!.row].text ?? "", dateString: dateFormatter.string(from: safeDate), color: view.backgroundColor!), animated: true)
            } else {
                self.present(popUpVC.popUp(title: itemArray[indexPath!.row].title!, description: itemArray[indexPath!.row].text ?? "", dateString: "", color: view.backgroundColor!), animated: true)
            }
        }
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
    
    func createItem(title: String, text: String, deadLine: Bool, endDate: Date?) {
        let newItem = ToDoItems(context: context)
        newItem.title = title
        newItem.done = false
        newItem.text = text
        newItem.date = Date()
        newItem.hasDeadLine = deadLine
        if newItem.hasDeadLine {
            newItem.endDate = endDate
            reminder.createReminder(title: title, text: text, date: endDate!)
        }
        newItem.parentCategory = selectedCategory
        // The endDate is NOT changing as the DatePicker Changes!
        print("The newItem endDate is: \(String(describing: newItem.endDate))")
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
    
    func updateItem(item: ToDoItems, newTitle: String, newText: String, hasDeadLine: Bool, newDate: Date?) {
        item.title = newTitle
        item.text = newText
        item.hasDeadLine = hasDeadLine
        if item.hasDeadLine {
            item.endDate = newDate
        }
        self.tableView?.reloadData()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CreateItemViewController
        destVC.view.backgroundColor = self.view.backgroundColor
    }

}
