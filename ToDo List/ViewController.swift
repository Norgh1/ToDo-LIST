//
//  ViewController.swift
//  ToDo List
//
//  Created by Nor Gh on 26.06.22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDolistItem]()
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome To Do List"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let filed = alert.textFields?.first, let text = filed.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = models[indexPath.row]
        cell.textLabel?.text = x.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            
        let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = item.name
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                return
            }
            self?.updateItem(item: item, newName: newName)
        }))
            
            self?.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))

        
        present(sheet, animated: true)
    }
    
    // here is Core Data !!!
    
    
    func getAllItems(){
        do {
            models = try context.fetch(ToDolistItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    func createItem(name:String) {
        let newItem = ToDolistItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        do {
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    func deleteItem(item: ToDolistItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    func updateItem(item: ToDolistItem, newName: String) {
        item.name = newName
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
}


