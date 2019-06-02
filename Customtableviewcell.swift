//
//  Customtableviewcell.swift

import UIKit

class Customtableviewcell: UITableViewCell {
    @IBOutlet weak var Taskname: UILabel!
    @IBOutlet weak var Daysleft: UILabel!
    @IBOutlet weak var Percentage: UILabel!
    @IBOutlet weak var noteslbl: UITextView!
    @IBOutlet weak var progressviewbar: UILabel!
    @IBOutlet weak var EditTask: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
