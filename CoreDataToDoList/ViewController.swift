//
//  ViewController.swift
//  CoreDataToDoList
//
//  Created by Immanuel Matthews-Feemster on 9/3/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData To Do List"
        getTasks()
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAdd))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].task
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        let ac = UIAlertController(title: "Manage Task", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Update", style: .default, handler: {[weak self] _ in
            let ac = UIAlertController(title: "Updating Task", message: "Enter task details.", preferredStyle: .alert)
            ac.addTextField()
            ac.textFields?.first?.text = task.task
            ac.addAction(UIAlertAction(title: "Update", style: .default, handler: {[weak self] _ in
                guard let field = ac.textFields?.first, let text = field.text, !text.isEmpty else {return}
                self?.updateTask(task: task, newTask: text)
            }))
            self?.present(ac, animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: {
            [weak self] _ in
            self?.deleteTask(task: task)
        }))
        present(ac, animated: true)
    }
    
    func getTasks() {
        do {
            tasks = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func addTask(task: String) {
        let newTask = ToDoListItem(context: context)
        newTask.task = task
        newTask.createdAt = Date()
        do {
            try context.save()
            getTasks()
        }
        catch {
            
        }
    }
    
    func deleteTask(task: ToDoListItem) {
        context.delete(task)
        do {
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func updateTask(task: ToDoListItem, newTask: String) {
        task.task = newTask
        
        do {
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    @objc func tappedAdd() {
        let ac = UIAlertController(title: "Add Task", message: "" , preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let field = ac.textFields?.first, let text = field.text, !text.isEmpty else {return}
            self?.addTask(task: text)
        }))
        present(ac, animated: true)
        
    }
}

