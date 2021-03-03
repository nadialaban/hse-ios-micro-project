//
//  DetailTaskViewController.swift
//  TaskTracker
//
//  Created by Nadia on 01.03.2021.
//

import UIKit

class DetailTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var statusPicker: UIPickerView!
    
    var task: Task!
    let statuses : [String] = ["New",
                               "In Process",
                               "Done"]

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitleLabel.text = task.title
        statusLabel.text = task.status
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: task.date)
        
        noteText.text = task.note
        
        self.statusPicker.dataSource = self
        self.statusPicker.delegate = self
        let index = statuses.firstIndex(of: task.status)
        
        self.statusPicker.selectRow(index!, inComponent: 0, animated: false)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        taskTitleLabel.text = task.title
        let index = statuses.firstIndex(of: task.status)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        dateLabel.text = dateFormatter.string(from: task.date)

        
        self.statusPicker.selectRow(index!, inComponent: 0, animated: false)
        noteText.text = task.note
//        reloadData()
    }

    func reloadData() {

    }
    
    @IBSegueAction func edittask(_ coder: NSCoder) -> EditTaskViewController? {
        let page = EditTaskViewController(coder: coder)
        page?.task = self.task
        return page
    }
    
    // Picker view methods
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.task.status = statuses[row]
        statusLabel.text = task.status
        do {
            try ViewController.container.viewContext.save()
        } catch {
            print("error")
        }

        
        return self.statuses[row]
    }

}
