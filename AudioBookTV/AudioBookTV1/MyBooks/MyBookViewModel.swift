import Foundation

class MyBookViewModel {
    
    private let repository = BooksRepositoryLive()
    
    var books: [Book] = []
    var didFetchBooks: (() -> ())?
    
    func fetchBooks() {
        Task {
            do {
                let books = try await repository.fetchBooks()
                
                self.books = books.sorted { $0.title < $1.title }
               
                await MainActor.run {
                    self.didFetchBooks?()
                }
            } catch {
                print(error)
            }
        }
    }
}

