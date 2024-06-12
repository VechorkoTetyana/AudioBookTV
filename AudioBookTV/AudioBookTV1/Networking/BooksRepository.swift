import UIKit

// curl 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'

// curl -X POST -d '{"title": "Dopamine Nation", "subtitle": "Finding Balance in the Age of Indulgence", "authors": ["Anna Lembke"], "cover": "dopamineNation", "rating": "4.2", "items": ["Brilliant core message!", "super"]}' 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'

// curl -X POST -d '{"authors"}' 'https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/books.json'


struct FirebasePostResponseDTO: Codable {
    let name: String
}

protocol BooksRepository{
    func fetchBooks() async throws -> [Book]
    func addBookToLibrary(_ book: Book) async throws
    func postReview(_ review: String, to book: Book) async throws
    func deleteBook(_ book: Book) async throws
}

class BooksRepositoryLive: BooksRepository {
    
    typealias BooksResponse = [String: BookDTO]
    
    private lazy var booksUrl = baseUrl.appending(path: "books.json")
    
    private let baseUrl = URL(string: "https://audiobooktv-e2688-default-rtdb.europe-west1.firebasedatabase.app/")!
    
    private lazy var decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    private lazy var encoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }()
    
    func fetchBooks() async throws -> [Book] {
        let request = URLRequest(url: booksUrl)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try decoder.decode(BooksResponse.self, from: data)
        
        return toDomain(decoded)
    }
    
    func addBookToLibrary(_ book: Book) async throws {
        var request = URLRequest(url: booksUrl)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(book.toData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try decoder.decode(FirebasePostResponseDTO.self, from: data)
        
        print("Successfully added \(book.title) to database with id \(decoded.name)")
    }
    
    func postReview(_ review: String, to book: Book) async throws {
        var request = URLRequest(url: baseUrl.appending(path: "books/\(book.id)/items.json"))
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(BookDTO.ReviewDTO(createDate: Date(), content: review))
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try decoder.decode(FirebasePostResponseDTO.self, from: data)
        
        print("Successfully posted review to book \(book.title) with review id \(decoded.name) to database")
        }
    
    
    func deleteBook(_ book: Book) async throws {
        var request = URLRequest(url: baseUrl.appending(path: "books/\(book.id).json"))
        request.httpMethod = "DELETE"
        
        let _ = try await URLSession.shared.data(for: request)
        
        print("Successfully deleted book with id \(book.id)")
    }
    
    private func toDomain(_ response: BooksResponse) -> [Book] {
        var result = [Book]()
        
        for(id, book) in response {
            result.append(book.toDomain(with: id))
        }
        return result
    }
}

extension BookReview {
    var toData: BookDTO.ReviewDTO {
        BookDTO.ReviewDTO(
            createDate: createDate,
            content: content)
    }
}
    
extension BookDTO {
    func toDomain(with id: String) -> Book {
            
            var reviews: [BookReview] = []
            for (id, review) in self.items {
                reviews.append(
                    BookReview(
                        id: id,
                        createDate: review.createDate,
                        content: review.content
                    ))
            }
           
           return Book(
                id: id,
                title: title,
                subtitle: subtitle,
                authors: authors,
                coverImageName: cover,
                rating: rating,
                items: reviews.sorted(by: { $0.createDate < $1.createDate }),
                isInLibrary: true,
                priceCredit: priceCredit
            )
    }
}

extension Book {
    var toData: BookDTO {
        
        var reviews: [String: BookDTO.ReviewDTO] = [:]
        for review in self.items {
            reviews[review.id] = review.toData
        }
        
        return BookDTO(
            authors: authors,
            cover: coverImageName,
            rating: rating,
            items: reviews,
            subtitle: subtitle,
            title: title,
            priceCredit: priceCredit
        )
    }
}
