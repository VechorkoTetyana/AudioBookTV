import UIKit

class AudioBookTVViewController: UIViewController{
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
      
    let viewModel = MyBookViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchBooks()
        
        viewModel.didFetchBooks = { [weak self] in
            self?.tableView.reloadData()
        }
        configureTableView()
    }
    
   private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cellName = "AudioListCellNew"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableView.rowHeight = 44
    }
    
    func present(with book: Book) {
        let audioListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
        
        audioListViewController.viewModel = BookViewModel(book: book)
        
        audioListViewController.modalPresentationStyle = .fullScreen
        
        present(audioListViewController, animated: true)
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true)
    }
}

extension AudioBookTVViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListCellNew") as? AudioListCellNew
        else { return UITableViewCell() }
        
        let book = viewModel.books[indexPath.row]
        
        cell.configure(with: book)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension AudioBookTVViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        present(with: book)
    }
}
