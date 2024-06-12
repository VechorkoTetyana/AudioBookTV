import UIKit

class AudioListCellNew: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with book: Book) {
        coverImageView.image = UIImage(named: book.coverImageName)
        titleLbl.text = "\(book.title) (\(book.rating))"
    }
}
