import UIKit

struct WelcomeCellViewModel {
    let greeting: String
    let subtitle: String
}

struct BooksShowcaseViewModel {
    let title: String
    let books: [Book]
}

class HomeViewController: UIViewController {
    
    enum Row {
        case welcome(WelcomeCellViewModel)
        case books(BooksShowcaseViewModel)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var rows: [Row] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDataSource()
        
        configureTableView()
    }
    
    private func fillDataSource() {
        
        let welcomeRow = Row.welcome(WelcomeCellViewModel(
            greeting: "Good afternoon, Ann",
            subtitle: "You have 5 credits"
        ))
        
        rows.append(welcomeRow)
        
        let similarRow = Row.books(BooksShowcaseViewModel(
            title: "Similar titles you have listened to",
            books: [
            Book(
                title: "How We Learn",
                subtitle: "How We Learn as it's meant to be heard",
                authors: ["Stanislas Dehaene"],
                coverImageName: "howWeLearn",
                rating: "4.5",
                items: [], 
                priceCredit: 1
            ),
            Book(
                title: "Thinking, Fast and Slow",
                subtitle: "",
                authors: ["Daniel Kahneman"],
                coverImageName: "thinkingFastAndSlow",
                rating: "4.5",
                items: [],
                priceCredit: 2
            ),
            Book(
                title: "Talking to Strangers",
                subtitle: "",
                authors: ["Malcolm Gladwell"],
                coverImageName: "talkingToStrangers",
                rating: "4.5",
                items: [],
                priceCredit: 3
            )
            ]
        ))
        
        rows.append(similarRow)
        
        let popularRow = Row.books(BooksShowcaseViewModel(
            title: "Popular titles that you could also enjoy",
            books: [
                Book(
                title: "Unstressable",
                subtitle: "",
                authors: ["Mo Gawdat", "Alice Law"],
                coverImageName: "unstressable",
                rating: "4.5",
                items: [],
                priceCredit: 1
            ),
                Book(
                title: "Liberated Love",
                subtitle: "",
                authors: ["Mark Groves", "Kylie McBeath"],
                coverImageName: "liberatedLove",
                rating: "4.5",
                items: [],
                priceCredit: 2
            ),
                Book(
                title: "Kokoro",
                subtitle: "",
                authors: ["Beth Kempton"],
                coverImageName: "kokoro",
                rating: "4.5",
                items: [],
                priceCredit: 3
            ),
                Book(
                title: "Three Summers",
                subtitle: "",
                authors: ["Amra Sabic-El-Rayess", "Laura L. Sullivan"],
                coverImageName: "threeSummers",
                rating: "4.5",
                items: [],
                priceCredit: 4
            )
            ]
        ))
        
        rows.append(popularRow)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "HomeWelcomeCell", bundle: nil), forCellReuseIdentifier: "HomeWelcomeCell")
        tableView.register(UINib(nibName: "HomeBookShowcaseCell", bundle: nil), forCellReuseIdentifier: "HomeBookShowcaseCell")
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .welcome(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWelcomeCell") as! HomeWelcomeCell
            cell.configure(with: viewModel)
            return cell
            
        case .books(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBookShowcaseCell") as! HomeBookShowcaseCell
            cell.configure(with: viewModel)
            
            cell.didSelectBook = { [weak self] book in
                self?.presentDetail(book)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
}

extension HomeViewController: UITableViewDelegate {
    
    private func presentDetail(_ book: Book) {
        let audioListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
        
        audioListViewController.viewModel = BookViewModel(book: book)
        
        audioListViewController.modalPresentationStyle = .fullScreen
        
        present(audioListViewController, animated: true)
    }
}
