//
//  ShareViewController.swift
//  NewTaskShare
//
//  Created by Nadia on 03.03.2021.
//

import UIKit
import MobileCoreServices
import CoreData

@objc(ShareExtensionViewController)
class ShareExtensionViewController: UIViewController {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var noteText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleSharedFile()
        
        if ViewController.container == nil {
            ViewController.container = NSPersistentContainer(name: "TaskModel")
            ViewController.container.loadPersistentStores {
                storeDesctiption, error in
                if let error = error {
                    print("error: \(error)")
                }
            }
        }
                
    }

    @IBAction func cancel(_ sender: Any) {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
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

        cancel((Any).self)
    }


    private func handleSharedFile() {
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        for provider in attachments {
            // Check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
                    // Handle the error here if you want
                    guard error == nil else { return }

                    if let text = data as? String {
                        DispatchQueue.main.async {
                            self.noteText.text = text
                        }
                    } else {
                        fatalError("Impossible to get text")
                    }
                }}
        }
    }
}
