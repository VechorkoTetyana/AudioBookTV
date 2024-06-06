import UIKit

struct Book {
    let title: String
    let subtitle: String
    let authors: [String]
    let coverImage: UIImage
    let rating: String
    var items: [String]
    let isInLibrary: Bool
    let priceCredit: Int
    
    init(title: String, 
         subtitle: String,
         authors: [String],
         coverImage: UIImage,
         rating: String,
         items: [String],
         isInLibrary: Bool = false,
         priceCredit: Int
    ) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.coverImage = coverImage
        self.rating = rating
        self.items = items
        self.isInLibrary = isInLibrary
        self.priceCredit = priceCredit
    }
}
