import Foundation

class MyBookViewModel {
    
    private let repository = BooksRepository()
    
    var books: [Book] = []
    var didFetchBooks: (() -> ())?
    
    func fetchBooks() {
        Task {
            do {
                let books = try await repository.fetchBooks()
                self.books = books
                
                await MainActor.run {
                    self.didFetchBooks?()
                }
            } catch {
                print(error)
            }
        }
    }
}

