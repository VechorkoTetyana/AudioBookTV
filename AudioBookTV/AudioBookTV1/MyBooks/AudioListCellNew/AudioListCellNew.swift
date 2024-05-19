import UIKit

class AudioListCellNew: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with book: Book) {
        coverImageView.image = book.coverImage
        titleLbl.text = "\(book.title) (\(book.rating))"
    }
}
