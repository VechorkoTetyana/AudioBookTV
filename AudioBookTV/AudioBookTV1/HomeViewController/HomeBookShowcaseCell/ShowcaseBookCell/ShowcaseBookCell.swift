import UIKit

class ShowcaseBookCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    
    func configure(_ book: AudioList) {
        coverImageView.image = book.image
        titleLbl.text = book.title
        authorsLbl.text = authorsSubtitle(from: book.authors)
    }
    
    private func authorsSubtitle(from authors: [String]) -> String {
        "By " + authors.joined(separator: ", ")
        
    }
}
