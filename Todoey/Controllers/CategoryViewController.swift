//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Connie He on 8/8/19.
//  Copyright © 2019 Connie He. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // var categoryList = [Category]()
    
    var categoryList: Results<Category>?
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    // using Core Data
//    func saveCategories() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving category \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    // using Realm
    
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadCategories() {
        
        categoryList = realm.objects(Category.self)
        
        // Core Data implementation below
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categoryList = try context.fetch(request)
//        } catch {
//            print("Error fetching categories from context \(error)")
//        }
//
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // gets triggered when user clicked Add Item button in UIAlert
        // using CoreData
//        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
//
//            // create new NSManagedObjects by referring to a context
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//            self.categoryList.append(newCategory)
//
//            self.saveCategories()
//
//        }
        
        // using Realm
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            // don't need to append new categories because it's auto-updating
            //self.categoryList.append(newCategory)
            self.saveCategories(category: newCategory)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        // gets triggered when plus sign gets pressed - add text field to the alert, and then store a reference to it
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
        //loadCategories()

    }
    
 
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    // if multiple segues with different identifiers, might add if statement to specify the goToItems one
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            // only set if value not nil
            destinationVC.selectedCategory = categoryList?[indexPath.row]
        }
    }
}
