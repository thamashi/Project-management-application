//
//  DetailViewController.swift

import UIKit
import CoreData
import EventKit
import M13ProgressSuite

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var fetchRequest: NSFetchRequest<Tasks>!
    var tasks: [Tasks]!

    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = coursework {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        configureView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCoursework"{
            if let courseworddetailsViewController = segue.destination as? CourseworddetailsViewController {
                courseworddetailsViewController.moduleName = coursework?.moduleName
                courseworddetailsViewController.level = coursework?.level ?? 0
                courseworddetailsViewController.weightage = coursework?.weight ?? 0
                courseworddetailsViewController.marks = coursework?.marksAwarded ?? 0
                courseworddetailsViewController.notes = coursework?.notes
                courseworddetailsViewController.currentCoursework = coursework
            }
        }
        if segue.identifier == "addTask"
        {
            if let taskadd = segue.destination as? addTaskViewController {
               taskadd.currentCoursework = coursework
            }
        }
        if segue.identifier == "editCoursework"
        {
            if let cwEdit = segue.destination as? editCourseworkViewController {
                cwEdit.currentCoursework = coursework
            }
        }
        if segue.identifier == "editTask"
        {
            if let taskEdit = segue.destination as? editTaskViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let object = fetchedResultsController.object(at: indexPath)
                    taskEdit.currentTask = object
                }
            }
        }
        if segue.identifier == "reminder" {
            if let reminder = segue.destination as? addReminderViewController {
                print("reminder task")
                if let indexPath = tableView.indexPathForSelectedRow {
                    let object = fetchedResultsController.object(at: indexPath)
                   reminder.currentTask = object
                }
            }
        }
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    @objc func editTask(){
        performSegue(withIdentifier: "editTask", sender: nil)
    }
    var coursework: Coursework? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
        //        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
        //        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Taskrow",for:indexPath) as! Customtableviewcell
       // self.configureCell(cell,indexPath:indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Taskrow", for: indexPath) as! Customtableviewcell
        let tasks = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withTasks: tasks)
                        print("table")
        
        return cell
    }
    var _fetchedResultsController: NSFetchedResultsController<Tasks>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Tasks> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let curretCoursework = self.coursework
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        // Set the batch size to a suitable number.
        request.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "taskName", ascending: true,selector:#selector(NSString.localizedStandardCompare(_:)))
        
        request.sortDescriptors = [sortDescriptor]
        
        if(self.coursework != nil){
            let predicate = NSPredicate(format:"courseworkLink = %@",curretCoursework!)
            request.predicate = predicate
        }else{
            let predicate = NSPredicate(format:"courseworkLink = %@","")
            request.predicate = predicate
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
        let frc = NSFetchedResultsController<Tasks>(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: #keyPath(Tasks.courseworkLink),
            cacheName: nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc as! NSFetchedResultsController<NSFetchRequestResult> as!
            NSFetchedResultsController<Tasks>
    }
    //MARK : fetch results with table view
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {

        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            //print(tableView.cellForRow(at: indexPath!)!, newIndexPath!)
            configureCell(tableView.cellForRow(at: indexPath!)! as! Customtableviewcell, withTasks: anObject as! Tasks )
            break
//            configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*func configureCell(_ cell:UITableViewCell,indexPath:IndexPath){
        print("configure")
        let cell = cell as! Customtableviewcell
        
        let taskName = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskName
        let progress = self.fetchedResultsController.fetchedObjects?[indexPath.row].progress
        let estimatedTime = self.fetchedResultsController.fetchedObjects?[indexPath.row].estTime
        let notes = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
        
        print("completed")
        
        cell.Taskname.text = taskName
        cell.Percentage.text = String(progress!)
        cell.noteslbl.text = notes
        //cell.progress.progress = Float(progress!/100)
        let taskFrame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 10.0)
        let taskProgress = M13ProgressViewBorderedBar.init(frame: taskFrame)
        taskProgress.setProgress(CGFloat(progress!)/100, animated: false)
        
        cell.progressviewbar.addSubview(taskProgress)
        cell.EditTask.addTarget(self, action: #selector(editTask), for: .touchUpInside)
        let calendar = NSCalendar.current
        let dueDate = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskDuedate
        print(dueDate)
        if (dueDate != nil ) {
            let curDate = calendar.startOfDay(for: Date())
            let endDate = calendar.startOfDay(for: dueDate!)
            
            let components = calendar.dateComponents([.day], from: curDate, to: endDate)
            cell.Daysleft.text = String(components.day!)
            //cell.Daysleft.text = String(components.)
        }else{
            cell.Daysleft.text = String("None")
        }
    }*/
    
    func configureCell(_ cell: Customtableviewcell, withTasks tasks : Tasks ){
        cell.Taskname.text = tasks.taskName;
        cell.noteslbl.text = tasks.notes;
        cell.Percentage.text = String(tasks.progress);
        
        let taskFrame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 10.0)
        let taskProgress = M13ProgressViewBorderedBar.init(frame: taskFrame)
        taskProgress.setProgress(CGFloat(tasks.progress)/100, animated: false)
        
        cell.progressviewbar.addSubview(taskProgress);
        cell.EditTask.addTarget(self, action: #selector(editTask), for: .touchUpInside)
        let calendar = NSCalendar.current
        let dueDate = tasks.taskDuedate
        print(dueDate)
        if (dueDate != nil ) {
            let curDate = calendar.startOfDay(for: Date())
            let endDate = calendar.startOfDay(for: dueDate!)
            
            let components = calendar.dateComponents([.day], from: curDate, to: endDate)
            cell.Daysleft.text = String(components.day!)
            //cell.Daysleft.text = String(components.)
        }else{
            cell.Daysleft.text = String("None")
        }

    }


}

