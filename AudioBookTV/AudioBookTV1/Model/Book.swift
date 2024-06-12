import UIKit

struct BookReview {
    let id: String
    let createDate: Date
    let content: String
    
    init(id: String = UUID().uuidString, createDate: Date = Date(), content: String) {
        self.id = id
        self.createDate = createDate
        self.content = content
    }
}

struct Book {
    let id: String
    let title: String
    let subtitle: String
    let authors: [String]
    let coverImageName: String
    let rating: String
    var items: [BookReview]
    var isInLibrary: Bool
    let priceCredit: Int
    
    init(
        id: String = UUID().uuidString,
        title: String,
         subtitle: String,
         authors: [String],
         coverImageName: String,
         rating: String,
         items: [BookReview],
         isInLibrary: Bool = false,
         priceCredit: Int
    ) {
        self.id = id
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
