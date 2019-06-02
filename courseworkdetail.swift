//
//  courseworkdetail.swift


import UIKit

class courseworkdetail: UITableViewCell {
    @IBOutlet weak var Modulename: UILabel!
    @IBOutlet weak var Duedate: UILabel!
    @IBOutlet weak var Marks: UILabel!
    @IBOutlet weak var Weight: UILabel!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Notes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
