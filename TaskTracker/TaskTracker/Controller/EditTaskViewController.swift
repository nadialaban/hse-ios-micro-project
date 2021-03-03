//
//  EditTaskViewController.swift
//  TaskTracker
//
//  Created by Nadia on 01.03.2021.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var noteText: UITextView!

    var task: Task!
    let statuses : [String] = ["New",
                               "In Process",
                               "Done"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTitleTextField.text = task.title
        self.taskDatePicker.date = task.date
        self.noteText.text = task.note
        
        self.statusPicker.dataSource = self
        self.statusPicker.delegate = self
        let index = statuses.firstIndex(of: task.status)
        
        self.statusPicker.selectRow(index!, inComponent: 0, animated: false)
    }
    
    @IBAction func saveTask(_ sender: Any) {
        let title = taskTitleTextField.text!
        let date = taskDatePicker.date
        let note = noteText.text!
        let status_index = statusPicker.selectedRow(inComponent: 0)
        
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
        
        task.title = title
        task.date = date
        task.note = note
        task.status = statuses[status_index]
        
        do {
            try ViewController.container.viewContext.save()
        } catch {
            print("error")
        }
        
        navigationController?.popViewController(animated: true)
        let parentController = navigationController?.topViewController as! DetailTaskViewController
        parentController.task = task
    }

    @IBAction func deleteTask(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Delete Task", message: "Are You Sure?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction!) in
            refreshAlert .dismiss(animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            (action: UIAlertAction!) in
            ViewController.container.viewContext.delete(self.task)
            
            do {
                try ViewController.container.viewContext.save()
            } catch {
                print("error")
            }

            self.navigationController?.popToRootViewController(animated: true)
        }))

        present(refreshAlert, animated: true, completion: nil)
    }

    
    // Picker view methods
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.statuses[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
