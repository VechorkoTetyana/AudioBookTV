import UIKit

class AudioListItemCellNew: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    func configure (with review: String) {
        titleLbl.text = review
    }
}
