//
//  ViewController.swift
//  TaskTracker
//
//  Created by Nadia on 28.02.2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    public var tasks = [Task]()
    
    static var container: NSPersistentContainer!
    var taskPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if ViewController.container == nil {
            ViewController.container = NSPersistentContainer(name: "TaskModel")
            ViewController.container.loadPersistentStores {
                storeDesctiption, error in
                if let error = error {
                    print("error: \(error)")
                }
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            tasks = try ViewController.container.viewContext.fetch(Task.fetchRequest())
            tableView.reloadData()
        } catch {
            print("error while fetching")
        }

    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        cell.detailTextLabel!.text = dateFormatter.string(from: task.date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTaskViewController {
            vc.task = tasks[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
     }
    
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
        // 1
        ac.addAction(UIAlertAction(title: "Show only New", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status CONTAINS[c] 'New'")
            self.loadSavedData()
        })
        
        // 2
        ac.addAction(UIAlertAction(title: "Show only In Process", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status CONTAINS[c] 'In Process'")
            self.loadSavedData()
        })

        // 3
        ac.addAction(UIAlertAction(title: "Show only Done", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status CONTAINS[c] 'Done'")
            self.loadSavedData()
        })
        
        // 4
        ac.addAction(UIAlertAction(title: "Show All Tasks", style: .default)
        { [unowned self] _ in
            self.taskPredicate = nil
            self.loadSavedData()
        })
        

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveContext(){
        if ViewController.container.viewContext.hasChanges {
        do {
            try ViewController.container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = taskPredicate
        do {
            tasks = try ViewController.container.viewContext.fetch(request)
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    



}

