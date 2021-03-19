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

class ItemsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navItem: UINavigationItem?
    @IBOutlet var tableView: UITableView?
    
    let reminder = Reminders.init(center: UNUserNotificationCenter.current())
    
    var itemArray = [ToDoItems]()
    
    var itemNumber = Int()
    
    var namesArray = [String]()
    
    var selectedCategory: BoxItems? {
        didSet {
            getAllItems()
            tableView?.reloadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationItem.rightBarButtonItem?.tintColor = titleColor
        navigationController?.navigationBar.tintColor = titleColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminder.requestAuthorization()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MyTableViewCell.nib(), forCellReuseIdentifier: "MyTableViewCell")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        tableView?.addGestureRecognizer(longPressGesture)

    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: p)
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

    //MARK: - Tableview Datasource Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        
        let item = itemArray[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd-hh:mm"
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundViewCell.backgroundColor = view.backgroundColor?.darken(byPercentage: 0.05 * CGFloat(indexPath.row))
        cell.titleLabel.text = item.title
        cell.titleLabel.textColor = ContrastColorOf((view.backgroundColor?.darken(byPercentage: 0.05 * CGFloat(indexPath.row)))!, returnFlat: true)
        cell.descriptionLabel.textColor = ContrastColorOf((view.backgroundColor?.darken(byPercentage: 0.05 * CGFloat(indexPath.row)))!, returnFlat: true)
        cell.descriptionLabel.text = item.text
        cell.circleImageView.tintColor = ContrastColorOf((view.backgroundColor?.darken(byPercentage: 0.05 * CGFloat(indexPath.row)))!, returnFlat: true)
        if item.hasDeadLine {
            cell.redView.isHidden = false
            cell.endDateLabel.text = dateFormatter.string(from: item.endDate!)
            cell.endDateLabel.textColor = ContrastColorOf((view.backgroundColor?.darken(byPercentage: 0.05 * CGFloat(indexPath.row)))!, returnFlat: true)
        } else {
            cell.redView.isHidden =  true
            //Search about Date Formating into a custom String
        }
        cell.circleImageView.image = item.done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            tableView.beginUpdates()

            if self.itemArray[indexPath.row].hasDeadLine {
                self.reminder.removeReminder(date: "\(self.itemArray[indexPath.row].endDate!)")
                print("Deleting...")
            }
            self.deleteItem(item: self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()

            tableView.endUpdates()
            handler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    //MARK: - TableView Delegate Methods
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrate(for: .success)
        
        print("The \(itemArray[indexPath.row].title!) has \(itemArray[indexPath.row].text!) and date: \(String(describing: itemArray[indexPath.row].date)) and endDate is: \(String(describing: itemArray[indexPath.row].endDate))")
        
        
        print("Does it has DeadLine: \(itemArray[indexPath.row].hasDeadLine)")
        
        itemArray[indexPath.row].done.toggle()
        
        if itemArray[indexPath.row].done == true {
            print("YEEE IT's DONE")
            if self.itemArray[indexPath.row].hasDeadLine {
                self.reminder.removeReminder(date: "\(self.itemArray[indexPath.row].endDate!)")
                print("Deleting...")
            }
        } else {
            print("NOT DONE YET")
            if self.itemArray[indexPath.row].hasDeadLine {
                self.reminder.createReminder(title: self.itemArray[indexPath.row].title!, text: self.itemArray[indexPath.row].text ?? "", date: self.itemArray[indexPath.row].endDate!)
                print("Recreating...")
            }
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
