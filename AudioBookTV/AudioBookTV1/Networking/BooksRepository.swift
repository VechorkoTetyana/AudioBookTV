import UIKit
import Foundation

// curl 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'

// curl -X POST -d '{"title": "Dopamine Nation", "subtitle": "Finding Balance in the Age of Indulgence", "authors": ["Anna Lembke"], "cover": "dopamineNation", "rating": "4.2", "items": ["Brilliant core message!", "super"]}' 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'


struct BookDTO: Codable {

    let authors: [String]
    let cover: String
    let rating: String
    let items: [String]
    let subtitle: String
    let title: String
}

class BooksRepository {
    
    typealias BooksResponse = [String: BookDTO]
    
    private let url = URL(string:
        "https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json")!
    func fetchBooks() async throws -> [Book] {
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(BooksResponse.self, from: data)
        
        return toDomain(decoded)
    }
    private func toDomain(_ response: BooksResponse) -> [Book] {
        var result = [Book]()
        
        for(_, book) in response {
            result.append(book.toDomain)
        }
        
        return result
    }
}
    
    extension BookDTO {
        var toDomain: Book {
            Book(
                title: title,
                subtitle: subtitle,
                authors: authors,
                coverImage: UIImage(named: cover) ?? UIImage(),
                rating: rating,
                items: items
            )
    }
}
