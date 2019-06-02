//
//  CourseworddetailsViewController.swift

import UIKit
import MBCircularProgressBar
import M13ProgressSuite
import CoreData
class CourseworddetailsViewController: UIViewController {
    
    @IBOutlet weak var lblModulename: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var Percentageviewbar: UILabel!
    @IBOutlet weak var Daysleft: UILabel!
    @IBOutlet weak var Textdaysleft: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var moduleName:String?
    var weightage:Int16 = 0
    var marks:Int16 = 0
    var completedPercentage:Int16?
    var notes:String?
    var level:Int16 = 0
    var currentCoursework:Coursework?
    var priority: String?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lblModulename.text = currentCoursework?.courseworkName
        txtNotes.text = currentCoursework?.notes
        lblPriority.text = currentCoursework?.priority
        let calendar = NSCalendar.current
        
        if (currentCoursework?.task?.count != nil) && (currentCoursework?.task?.count != 0)
        {
            var total: Int = 0
            for case let tasks as Tasks in (currentCoursework?.task)!
            {
                total += Int(tasks.progress)
                print("total",total)
            }
            //progressBar.setProgress((Float(total/(currentCoursework?.tasks?.count)!)/100), animated: false)
            print("progressing")
            let progress = (Float(total/(currentCoursework?.task?.count)!)/100)
            
            lblPercentage.text = String((Int16(total/(currentCoursework?.task?.count)!)))
            
            let taskFrame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 20.0)
            let taskProgress = M13ProgressViewBorderedBar.init(frame: taskFrame)
            taskProgress.setProgress(CGFloat(progress), animated: false)
            Percentageviewbar.addSubview(taskProgress)
        }
        
        let curDate = calendar.startOfDay(for: Date())
        
        if let endDate = currentCoursework?.dueDate {
            let diffDays = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day
            print("Diff: " + String(diffDays!))
            
            let dateFrame = CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0)
            let dateProgress = M13ProgressViewSegmentedRing.init(frame: dateFrame)
            dateProgress.showPercentage = false
            dateProgress.progressRingWidth = CGFloat(10.0)
            //dateProgress.numberOfSegments = Calendar.current.dateComponents([.day], from: curDate, to: endDate).day!
            dateProgress.numberOfSegments = 20
            dateProgress.setProgress(CGFloat(diffDays!)/100, animated: true)
            Daysleft.addSubview(dateProgress)
            
           Textdaysleft.text = String(diffDays!)+" Days left"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
