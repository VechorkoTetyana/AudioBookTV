import UIKit

class BookHeaderCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playBtn.layer.cornerRadius = 22
        playBtn.layer.masksToBounds = true
        selectionStyle = .none
    }
    
    func configure(with book: Book) {
        titleLbl.text = book.title
        subtitleLbl.text = book.subtitle
        coverImageView.image = book.coverImage
    }
}
    

