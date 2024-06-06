import UIKit

struct Book {
    let title: String
    let subtitle: String
    let authors: [String]
    let coverImageName: String
    let rating: String
    var items: [String]
    var isInLibrary: Bool
    let priceCredit: Int
    
    init(title: String, 
         subtitle: String,
         authors: [String],
         coverImageName: String,
         rating: String,
         items: [String],
         isInLibrary: Bool = false,
         priceCredit: Int
    ) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.coverImageName = coverImageName
        self.rating = rating
        self.items = items
        self.isInLibrary = isInLibrary
        self.priceCredit = priceCredit
    }
}
