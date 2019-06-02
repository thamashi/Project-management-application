//
//  editCourseworkViewController.swift


import UIKit
import CoreData
class editCourseworkViewController: UIViewController {

    @IBOutlet weak var CourseworkName: UITextField!
    @IBOutlet weak var DueDate: UITextField!
    @IBOutlet weak var Marks: UILabel!
    @IBOutlet weak var MarksSlider: UISlider!
    @IBOutlet weak var Notes: UITextView!
    @IBOutlet weak var Priority: UISegmentedControl!
    
    var currentCoursework:Coursework?
    var priorityValue = "Low";
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CourseworkName.text = currentCoursework?.courseworkName
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: (currentCoursework?.dueDate)!)
        
        DueDate.text = dateString
        MarksSlider.setValue(Float((currentCoursework?.marksAwarded)!), animated: true)
        Marks.text = "\(currentCoursework?.marksAwarded ?? 0)"
        Notes.text = currentCoursework?.notes
        
        switch currentCoursework?.priority{
        case "Low":
            Priority.selectedSegmentIndex = 0
        case "Medium":
            Priority.selectedSegmentIndex = 1
        case "High":
            Priority.selectedSegmentIndex = 2
        case .none:
            Priority.selectedSegmentIndex = 1
        case .some(_):
            Priority.selectedSegmentIndex = 1

        }
    }
    
    @IBAction func duedatepick(_ sender: UITextField) {
    
    let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(editCourseworkViewController.datePickerValue), for: UIControl.Event.valueChanged)
}
@objc func datePickerValue(sender:UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    DueDate.text = dateFormatter.string(from: sender.date)
}
    
    
    @IBAction func onPriorityChange(_ sender: UISegmentedControl) {
        
        switch Priority.selectedSegmentIndex{
        case 0:
            priorityValue = "Low"
        case 1:
            priorityValue = "Medium"
        case 2:
            priorityValue = "High"
        default:
            priorityValue = "Low"
        }
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        let currentvalue = Double(sender.value * 100).rounded()/100
        Marks.text = String(currentvalue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateCW(_ sender: UIBarButtonItem) {
        currentCoursework?.courseworkName = CourseworkName.text
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        currentCoursework?.dueDate = dateformatter.date(from: DueDate.text!)
        
        currentCoursework?.marksAwarded = Int16(Int16(Marks.text!)!)
        currentCoursework?.notes = Notes.text
        currentCoursework?.priority = priorityValue
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    

}
