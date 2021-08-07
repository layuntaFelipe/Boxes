//
//  BoxesViewExtension.swift
//  Boxes
//
//  Created by Felipe Lobo on 07/08/21.
//

import Foundation
import UIKit
import ChameleonFramework

extension BoxesViewController: DefaultCollectionMethods {
    //MARK: - CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if !isToDelete {
            print("Hi, my name is: \(String(describing: boxArray[indexPath.row].name))")
            titleNavigation = boxArray[indexPath.row].name!
            
            boxNumber = indexPath.row
//            print("boxNumber is: \(boxNumber)")
//            print("boxColor is: \(boxArray[boxNumber].color!)")
            
            performSegue(withIdentifier: "CategoryToItem", sender: self)
        } else {
            
            let alert = UIAlertController(title: "Delete Box?", message: "Are You Sure You Want To Delete \(boxArray[indexPath.row].name!) Box?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("I'm going to delete this box")
                let itemsOfTheBox = ItemsTableViewController()
                itemsOfTheBox.selectedCategory = boxArray[indexPath.row]
                for item in itemsOfTheBox.itemArray {
                    print("deleting a item:")
                    if item.hasDeadLine {
                        center.removePendingNotificationRequests(withIdentifiers: ["\(item.endDate!)"])
                    }
                    itemsOfTheBox.deleteItem(item: item)
                }
                self.deleteBox(box: boxArray[indexPath.row])
                boxArray.remove(at: indexPath.row)
                HapticsManager.shared.vibrate(for: .error)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToItem" {
            let destinationVC = segue.destination as! ItemsTableViewController
            destinationVC.selectedCategory = boxArray[boxNumber]
            destinationVC.view.backgroundColor = UIColor(hexString: boxArray[boxNumber].color!)
        }
    }
    
    //MARK: - CollectionView DataSource Methods
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
        cell.numberView.textColor = ContrastColorOf(UIColor(hexString: box.color!)!, returnFlat: true)
        cell.backgroundCellView.layer.borderColor = UIColor(hexString: box.color!)?.cgColor
        cell.circleView.backgroundColor = UIColor(hexString: box.color!)
        
        if isToDelete {
            cell.numberView.text = "-"
        } else {
            cell.numberView.text = String(box.number)
        }
        
        return cell
        
    }
}
