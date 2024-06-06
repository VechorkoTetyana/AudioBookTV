import UIKit

// curl 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'

// curl -X POST -d '{"title": "Dopamine Nation", "subtitle": "Finding Balance in the Age of Indulgence", "authors": ["Anna Lembke"], "cover": "dopamineNation", "rating": "4.2", "items": ["Brilliant core message!", "super"]}' 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'

// curl -X POST -d '{"authors"}' 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'


struct FirebasePostResponseDTO: Codable {
    let name: String
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
    
    func addBookToLibrary(_ book: Book) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(book.toData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(FirebasePostResponseDTO.self, from: data)
        
        print("Successfully added \(book.title) to database with id \(decoded.name)")
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
                coverImageName: cover,
                rating: rating,
                items: items,
                isInLibrary: true,
                priceCredit: priceCredit
            )
    }
}

extension Book {
    var toData: BookDTO {
        BookDTO(
            authors: authors,
            cover: coverImageName,
            rating: rating,
            items: items,
            subtitle: subtitle,
            title: title,
            priceCredit: priceCredit
        )
    }
}
