import UIKit

class ShowcaseBookCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    
    func configure(_ book: Book) {
        coverImageView.image = book.coverImage
        titleLbl.text = book.title
        authorsLbl.text = authorsSubtitle(from: book.authors)
    }
    
    private func authorsSubtitle(from authors: [String]) -> String {
        "By " + authors.joined(separator: ", ")
        
    }
}
