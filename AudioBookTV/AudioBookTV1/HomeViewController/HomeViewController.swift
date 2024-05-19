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
                subtitle: "",
                authors: ["Stanislas Dehaene"],
                coverImage: .howWeLearn,
                rating: "",
                items: []
            ),
            Book(
                title: "Thinking, Fast and Slow",
                subtitle: "",
                authors: ["Daniel Kahneman"],
                coverImage: .thinkingFastAndSlow,
                rating: "",
                items: []
            ),
            Book(
                title: "Talking to Strangers",
                subtitle: "",
                authors: ["Malcolm Gladwell"],
                coverImage: .talkingToStrangers,
                rating: "",
                items: []
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
                coverImage: .unstressable,
                rating: "",
                items: []
            ),
                Book(
                title: "Liberated Love",
                subtitle: "",
                authors: ["Mark Groves", "Kylie McBeath"],
                coverImage: .liberatedLove,
                rating: "",
                items: []
            ),
                Book(
                title: "Kokoro",
                subtitle: "",
                authors: ["Beth Kempton"],
                coverImage: .kokoro,
                rating: "",
                items: []
            ),
                Book(
                title: "Three Summers",
                subtitle: "",
                authors: ["Amra Sabic-El-Rayess", "Laura L. Sullivan"],
                coverImage: .threeSummers,
                rating: "",
                items: []
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
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
}
