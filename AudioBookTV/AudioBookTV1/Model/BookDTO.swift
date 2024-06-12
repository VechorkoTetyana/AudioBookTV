import UIKit

struct BookDTO: Codable {
    
    struct ReviewDTO: Codable {
        let createDate: Date
        let content: String
    }

    let authors: [String]
    let cover: String
    let rating: String
    let items: [String: ReviewDTO]
    let subtitle: String
    let title: String
    let priceCredit: Int
    
    init(
        authors: [String],
        cover: String,
        rating: String,
        items: [String: ReviewDTO],
        subtitle: String,
        title: String,
        priceCredit: Int
    ){
        self.authors = authors
        self.cover = cover
        self.rating = rating
        self.items = items
        self.subtitle = subtitle
        self.title = title
        self.priceCredit = priceCredit
   }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authors = try container.decode([String].self, forKey: .authors)
        self.cover = try container.decode(String.self, forKey: .cover)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.items = try container.decodeIfPresent([String: ReviewDTO].self, forKey: .items) ?? [:]
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
        self.title = try container.decode(String.self, forKey: .title)
        self.priceCredit = try container.decode(Int.self, forKey: .priceCredit)
    }
}
