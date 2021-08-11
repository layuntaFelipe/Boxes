//
//  ItemsTableExtension.swift
//  Boxes
//
//  Created by Felipe Lobo on 07/08/21.
//

import Foundation
import UIKit
import ChameleonFramework

extension ItemsTableViewController: DefaultTableMethods {
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
                reminder.removeReminder(date: "\(self.itemArray[indexPath.row].endDate!)")
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
                reminder.removeReminder(date: "\(self.itemArray[indexPath.row].endDate!)")
                print("Deleting...")
            }
        } else {
            print("NOT DONE YET")
            if self.itemArray[indexPath.row].hasDeadLine {
                reminder.createReminder(title: self.itemArray[indexPath.row].title!, text: self.itemArray[indexPath.row].text ?? "", date: self.itemArray[indexPath.row].endDate!)
                print("Recreating...")
            }
        }
        self.tableView?.reloadData()
        //Every time you change the database, call this:
        self.saveItems()
    }
}
