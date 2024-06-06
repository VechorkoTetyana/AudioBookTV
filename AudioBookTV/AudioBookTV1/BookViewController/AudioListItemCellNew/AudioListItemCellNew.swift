import UIKit

class AudioListItemCellNew: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure (with review: String) {
        titleLbl.text = review
    }
}
