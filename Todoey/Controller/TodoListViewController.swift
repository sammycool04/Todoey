//
//  ViewController.swift
//  Todoey
//
//  Created by Sam  on 4/8/19.
//  Copyright © 2019 Sam. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
             loadItems()
        }
    }
    
    // create the intermediate -- context to allow users to create,read,save,update and destory
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
        
//        if let items = UserDefaults.standard.array(forKey: "TodoListArray")as? [Item]{
//            itemArray = items
//        }
    }
    
    //Mark - Tableview Data Source Method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none //check the done propety of the cell to see if it needs checkmark
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
        
    }
    //Mark - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        if let item = todoItems?[indexPath.row] {
            //checking if todoItems is nil first, if not, then go on updating
            do {
                try realm.write {
                    item.done = !item.done
                }

            } catch {
                print ("Error updating item, \(error)")
            }
        }
        tableView.reloadData()
                
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Mark - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens when users click button
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dataCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            
            
            
            self.tableView.reloadData()
            

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Model Manipulation Methods: saving and retrieving data in Core Data
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("error here \(error)")
//        }
//
//        self.tableView.reloadData()
//
//    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
  
    
}

//Mark: - Search Bar Method

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()

            }

        }
    }
}
