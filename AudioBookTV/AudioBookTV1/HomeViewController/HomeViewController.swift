import UIKit

struct WelcomeCellViewModel {
    let greeting: String
    let subtitle: String
}

struct BooksShowcaseViewModel {
    let title: String
    let books: [AudioList]
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
            AudioList(
                title: "How We Learn",
                describtion: "",
                authors: ["Stanislas Dehaene"],
                image: .howWeLearn,
                rating: "",
                items: []
            ),
            AudioList(
                title: "Thinking, Fast and Slow",
                describtion: "",
                authors: ["Daniel Kahneman"],
                image: .thinkingFastAndSlow,
                rating: "",
                items: []
            ),
            AudioList(
                title: "Talking to Strangers",
                describtion: "",
                authors: ["Malcolm Gladwell"],
                image: .talkingToStrangers,
                rating: "",
                items: []
            )
            ]
        ))
        
        rows.append(similarRow)
        
        let popularRow = Row.books(BooksShowcaseViewModel(
            title: "Popular titles that you could also enjoy",
            books: [
            AudioList(
                title: "Unstressable",
                describtion: "",
                authors: ["Mo Gawdat", "Alice Law"],
                image: .unstressable,
                rating: "",
                items: []
            ),
            AudioList(
                title: "Liberated Love",
                describtion: "",
                authors: ["Mark Groves", "Kylie McBeath"],
                image: .liberatedLove,
                rating: "",
                items: []
            ),
            AudioList(
                title: "Kokoro",
                describtion: "",
                authors: ["Beth Kempton"],
                image: .kokoro,
                rating: "",
                items: []
            ),
            AudioList(
                title: "Three Summers",
                describtion: "",
                authors: ["Amra Sabic-El-Rayess", "Laura L. Sullivan"],
                image: .threeSummers,
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
