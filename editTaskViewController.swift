//
//  editTaskViewController.swift


import UIKit
import CoreData

class editTaskViewController: UIViewController {
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var sliderProgress: UISlider!
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var startDate: UITextField!
    
    let datePickerview :UIDatePicker = UIDatePicker()
    
    var currentTask:Tasks?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDateTime = Date()
        taskName.text = currentTask?.taskName
//        notes.text = currentTask?.notes

        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let sdateString = formatter.string(from: (currentTask?.startDate ?? currentDateTime))
        startDate.text = sdateString
        

        
        let endDateString = formatter.string(from: (currentTask?.taskDuedate ?? currentDateTime))
        endDate.text = endDateString
        sliderProgress.setValue(Float((currentTask?.progress ?? 0)), animated: false)

        progressText.text = "\( currentTask?.progress ?? 0)";
        notes.text = currentTask?.notes
//        let sdateString = formatter.string(from: (currentTask?.startDate)!)
//        startDate.text = "\(sdateString)"
//
//        let endDateString = formatter.string(from: (currentTask?.taskDuedate)!)
//        endDate.text = "\(endDateString)"
        
//        sliderProgress.setValue(Float((currentTask?.progress)!), animated: false)
        
//        progressText.text = "\(currentTask?.progress ?? 0)"
//        notes.text = currentTask?.notes
    }
    
    @IBAction func startDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(editTaskViewController.sdatePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    @objc func sdatePickerValueChanged(sender:UIDatePicker) {
       let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = DateFormatter.Style.medium
        startDate.text = dateFormatter.string(from: sender.date)

    }

    @IBAction func dueDate(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
             sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(editTaskViewController.ddatePickerValueChanged), for: UIControl.Event.valueChanged)
        
        
    }
    
    

    @objc func ddatePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        endDate.text = dateFormatter.string(from: sender.date)

    }


    @IBAction func sliderChanged(_ sender: UISlider) {
    var currentvalue = Double(sender.value * 100).rounded()/100
        progressText.text = String(currentvalue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        currentTask?.taskName = taskName.text
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        currentTask?.startDate = dateformatter.date(from: startDate.text!)
        currentTask?.taskDuedate = dateformatter.date(from: endDate.text!)
        currentTask?.progress = Double(progressText.text!)!
        currentTask?.notes = notes.text
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
