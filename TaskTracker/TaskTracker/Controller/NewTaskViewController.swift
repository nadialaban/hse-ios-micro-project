//
//  NewTaskViewController.swift
//  TaskTracker
//
//  Created by Nadia on 01.03.2021.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var noteText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveTask(_ sender: Any) {
        let title = taskTitleTextField.text!
        let date = taskDatePicker.date
        let note = noteText.text!
        if title == "" {
            let alert = UIAlertController(title: "Error!", message: "Title is empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if note == "" || note == "Type your text" {
            let alert = UIAlertController(title: "Error!", message: "Comment is empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let newTask = Task(context: ViewController.container.viewContext)
        newTask.title = title
        newTask.date = date
        newTask.note = note
        newTask.status = "New"
        do {
            try ViewController.container.viewContext.save()
        } catch {
            print("error")
        }
        navigationController?.popViewController(animated: true)
    }
}
