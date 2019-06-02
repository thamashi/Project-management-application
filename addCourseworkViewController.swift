//
//  addCourseworkViewController.swift

import UIKit
import CoreData
import EventKit
import Foundation

class addCourseworkViewController: UIViewController {

   
    @IBOutlet weak var txtcourseworkName: UITextField!
    @IBOutlet weak var txtdueDate: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblmarks: UILabel!
    @IBOutlet weak var txtnotes: UITextView!
    @IBOutlet weak var Switchcalendar: UISwitch!
    @IBOutlet weak var priority: UISegmentedControl!
    
    var priorityValue = "low";
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     let datePickerView:UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtcourseworkName.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
//        switch priority.selectedSegmentIndex
//        {
//        case 0:
//            HistList = SavedhistoryModel.printSavedList(type: 1)
//        case 1:
//            HistList = SavedhistoryModel.printSavedList(type: 2)
//        case 2:
//            HistList = SavedhistoryModel.printSavedList(type: 3)
//        default:
//            break
//        }
        switch priority.selectedSegmentIndex{
        case 0:
            priorityValue = "low"
        case 1:
            priorityValue = "medium"
        case 2:
            priorityValue = "high"
        default:
            priorityValue = "low"
        }

    }
    
    @IBAction func dueDatechanged(_ sender: UITextField) {
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.minimumDate = Date()
        
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(addCourseworkViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.medium
        
        txtdueDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
       
        let currentvalue = Int16(sender.value)
        lblmarks.text = String(currentvalue)
    }
    
    
    @IBAction func savebtn(_ sender: UIBarButtonItem) {
        let newProject = Coursework(context: context)
         var dateDue = Date()
        if (txtcourseworkName.text == "" || txtdueDate.text == "") {
            //Alert
            let alert = UIAlertController (title: "Misssing values name",message: "Please enter an valid name",preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        } else {
//            newProject.courseworkName = txtcourseworkName.text
            newProject.moduleName = txtcourseworkName.text
//            newProject.level = Int16(Int16(txtlevel.text!)!)
            newProject.notes = txtnotes.text
            newProject.priority = priorityValue
            
            let dateFormatter = DateFormatter()
            // dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            dateFormatter.dateStyle = DateFormatter.Style.medium
            
            dateFormatter.timeStyle = DateFormatter.Style.medium
            print("Date picker \(self.datePickerView)")
            
            //let dueDate = dateFormatter.string(from: datePickerView.date)
            //txtDueDate.text = "\(dueDate)"
            // let date = dateFormatter.date(from: txtDueDate.text!)!
            //newCoursework.dueDate = dueDate
            print("Date: " + txtdueDate.text!)
           dateDue = dateFormatter.date(from: txtdueDate.text!)!
            //  let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy h:mm:ss a"
            //            let date = dateFormatter.date(from: (self.txtDueDate.text)!)!
            txtdueDate.text = String(describing: dateDue)
            newProject.dueDate = dateDue
 
           // let dateformatter = DateFormatter()
            //newCoursework.dueDate = dateformatter.date(from: txtdueDate.text!)
            
//            newProject.weight = Int16(Int(txtweight.text!)!)
            newProject.marksAwarded = Int16(Int16(lblmarks.text!)!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
        
      
        
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted,Error) in
            
            if self.Switchcalendar.isOn{
                let eventStore: EKEventStore = EKEventStore()
                eventStore.requestAccess(to: .event) { (granted,Error) in
                    
                    if (granted) && (Error == nil)
                    {
                        print("granted \(granted)")
                        print("error \(String(describing: Error))")
                        
                        let event:EKEvent = EKEvent(eventStore: eventStore)
                        
                       
                        DispatchQueue.main.async {
                           
                            event.title =  self.txtcourseworkName.text
                            event.startDate = Date()
                            
                            event.endDate = dateDue
                            event.notes = "This is a note"
                            event.calendar = eventStore.defaultCalendarForNewEvents
                        }
                        
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        do{
                            try eventStore.save(event,span: .thisEvent)
                        } catch let error as NSError{
                            
                            print("error : \(error)")
                        }
                        print("Save event")
                    }else{
                        
                        //print("error : \(error)")
                    }
            

                }

            }
    
        }
    }
    
    @IBAction func cancelbtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
   
}

