//
//  addTaskViewController.swift 


import UIKit
import CoreData

class addTaskViewController: UIViewController {
    @IBOutlet weak var txtTaskname: UITextField!
    @IBOutlet weak var txtDuedate: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtnotes: UITextView!
    @IBOutlet weak var txtStartdate: UITextField!
    
    var currentCoursework:Coursework?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
     txtTaskname.becomeFirstResponder()
       
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderchanged(_ sender: UISlider) {
        let currentvalue = Double(sender.value * 100).rounded()/100
        lblPercentage.text = String(currentvalue)
    }
    
    @IBAction func startDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(addTaskViewController.datePickerValue), for: UIControl.Event.valueChanged)
    }

    @objc func datePickerValue(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        //dateFormatter.timeStyle = DateFormatter.Style.medium
        txtStartdate.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func dueDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(addTaskViewController.duedatePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    @objc func duedatePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        //dateFormatter.timeStyle = DateFormatter.Style.medium
        txtDuedate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func savedata(_ sender: UIBarButtonItem) {
        let newtasks = Tasks(context: context)
        if(txtTaskname.text != "" || txtDuedate.text != "" || txtStartdate.text != "")
        {newtasks.taskName = txtTaskname.text
            print("Adding task")
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM d, yyyy"
            newtasks.startDate = dateformatter.date(from: txtStartdate.text!)
            newtasks.taskDuedate = dateformatter.date(from: txtDuedate.text!)
            //newtasks.taskReminder = Date()
            newtasks.notes = txtnotes.text
            newtasks.progress = Double(lblPercentage.text!) == nil ? 0: Double(lblPercentage.text!)!
            currentCoursework?.addToTask(newtasks)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            print("saved task")
        } else {
            //alert
            let alert = UIAlertController(title:"Missing some fields",message: "Please fill values in empty fields", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert,animated: true, completion: nil)
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
