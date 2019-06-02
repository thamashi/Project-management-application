//
//  addReminderViewController.swift

import UIKit
import EventKit
import UserNotifications
import CoreData

class addReminderViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var remindermessage: UITextField!
    
    
    var eventStore: EKEventStore!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let calendar = NSCalendar.current
    var currentTask : Tasks?
    let datePickerView:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge], completionHandler: {didAllow, error in })
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        if(currentTask?.taskReminder != nil && currentTask?.taskReminderMessage != nil){
            txtDate.text = dateformatter.string(from:currentTask!.taskReminder!);
            remindermessage.text = currentTask?.taskReminderMessage;
        }
//        if(currentTask?.taskReminderMessage != ""){
//            remindermessage.text = currentTask?.taskReminderMessage
//
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .medium
//            let dateString = formatter.string(from: (currentTask?.taskReminder ?? Date())!)
//            //let dateString = formatter.string(from: (currentTask?.taskReminder)!)
//
//            txtDate.text = "\(dateString)"
//        }
//        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        txtDate.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func reminderDate(_ sender: UITextField) {
        datePickerView.datePickerMode = .dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(addReminderViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
       currentTask?.setValue(remindermessage.text, forKey: "taskReminderMessage")

       let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.subtitle = "Project Notification"
        content.body = remindermessage.text!
        content.badge = 1
        
        let dueDate = dateformatter.date(from:txtDate.text!)
        currentTask?.setValue(dueDate, forKey: "taskReminder")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let datecomp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: dueDate!);
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomp, repeats: false);
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger:trigger)
        let center = UNUserNotificationCenter.current();
        center.add(request);
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
        
    }

func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge])
}

    

}
