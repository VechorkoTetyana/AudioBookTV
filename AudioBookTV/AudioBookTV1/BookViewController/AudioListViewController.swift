import UIKit

enum BookViewSection: Int, CaseIterable {
   case header = 0
    case reviews
}

class BookViewModel {
    
    var book: Book
    
    private let repository: BooksRepository
    
    init(
        book: Book,
        repository: BooksRepository = BooksRepositoryLive()
    ) {
        self.book = book
        self.repository = repository
    }
    
    func isNewReviewValid(text: String) -> Bool {
//        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
    
    func purchaseBook() {
        guard !book.isInLibrary else { return }
        
        book.isInLibrary = true
        
        Task {
            do {
                try await repository.addBookToLibrary(book)
            } catch {
                print(error)
            }
        }
    }
    
    func postReview(with content: String) {
        guard isNewReviewValid(text: content) else { return }
        book.items.append(.init(content: content))
        
        Task {
            do {
                try await repository.postReview(content, to: book)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteBook() {
        Task {
            do {
                try await repository.deleteBook(book)
            } catch {
              print(error)
            }
        }
    }
}

class AudioListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postReviewView: UIView!
    @IBOutlet weak var postReviewSafeView: UIView!
    @IBOutlet weak var postReviewBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var postReviewSafeBottomConstraint: NSLayoutConstraint!
    
    var viewModel: BookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTableView()
        configureKeyboard()
        configurePostReviewView()
        configureTextField()
        setPostReviewBtn(enabled: false)
        
        configurePostReviewField(with: viewModel.book)
    }
    
    private func setPostReviewBtn(enabled isEnabled: Bool) {
        postBtn.isUserInteractionEnabled = isEnabled
        postBtn.tintColor = isEnabled ? .tintColor : UIColor(hex: "#737373")?.withAlphaComponent(0.5)
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    @objc private func didChangeText() {
        setPostReviewBtn(enabled: viewModel.isNewReviewValid(text: textField.text ?? ""))
    }
    
    private func configurePostReviewView() {
        postReviewView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        postReviewView.layer.shadowOffset = .zero
        postReviewView.layer.shadowRadius = 18.5
        postReviewView.layer.shadowPath = UIBezierPath(rect: postReviewView.bounds).cgPath
        postReviewView.layer.shadowOpacity = 1
    }
    
    private func configurePostReviewField(with book: Book) {
        postReviewView.isHidden = !book.isInLibrary
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let isKeyboardPresent = endFrame.origin.y < UIScreen.main.bounds.size.height
        
        // if keyboard will hide
        
        if !isKeyboardPresent {
            postReviewSafeBottomConstraint.constant = 0
        } else { // if keyboard will show
            let bottomHeight = 8 + endFrame.height - view.safeAreaInsets.bottom
            postReviewSafeBottomConstraint.constant = -bottomHeight
       }
        
        UIView.animate(withDuration: duration) {
            self.postBtn.alpha = isKeyboardPresent ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            guard !self.viewModel.book.items.isEmpty else { return }
            self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.book.items.count - 1, section: BookViewSection.reviews.rawValue), at: .bottom, animated: true)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellName = "AudioListItemCellNew"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableView.register(UINib(nibName: "BookHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BookHeaderCell")
        
        tableView.register(UINib(nibName: "BookHeaderCell", bundle: nil), forCellReuseIdentifier: "BookHeaderCell")

    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func playButton(_ sender: Any) {
    }
    
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        let sheet = UIAlertController(
            title: "More Actions",
            message: "What do you want to do?",
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(
            title: "Remove from library",
            style: .destructive,
            handler: { [weak self] _ in
                self?.presentDeletionPrompt()
            })
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(sheet, animated: true)
    }
    
    private func presentDeletionPrompt() {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Removing the book from your library will hide it from your My Books list.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: {
                [weak self] _ in self?.didConfirmRemoval()
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func didConfirmRemoval() {
        viewModel.deleteBook()
        self.dismiss(animated: true)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let text = textField.text else { return }
   //   viewModel.book.items.append(.init(content: text))
        
        viewModel.postReview(with: text)
        let indexPath = IndexPath(row: viewModel.book.items.count - 1, section: BookViewSection.reviews.rawValue)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        textField.text = ""
        setPostReviewBtn(enabled: false)
    }
}

extension AudioListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        BookViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = BookViewSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .reviews:
            return viewModel.book.items.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = BookViewSection(rawValue: indexPath.section)
        else { return UITableViewCell() }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookHeaderCell", for: indexPath) as! BookHeaderCell
            
            cell.configure(with: viewModel.book)
            cell.didTapPurchase = { [weak self] in
                self?.didTapPurchase()
            }
            
            return cell
        case .reviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListItemCellNew") as? AudioListItemCellNew
            else { return UITableViewCell() }
            
            let review = viewModel.book.items[indexPath.row]
            cell.configure(with: review.content)
            
            return cell
        }
    }
    
    private func didTapPurchase() {
        let credits = CreditFormatter().string(for: viewModel.book.priceCredit)
        let prompt = UIAlertController(
            title: "Please confirm purchase",
            message: "\(credits) credit will be used for this purchase",
            preferredStyle: .alert
        )
        
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        prompt.addAction(UIAlertAction(
            title: "Confirm",
            style: .default,
            handler: { [weak self] _ in self?.didConfirmPurchase()
        }))

        self.present(prompt, animated: true)
    }
    
    private func didConfirmPurchase() {
        viewModel.purchaseBook()
        configurePostReviewField(with: viewModel.book)
        tableView.reloadData()
    }
}

extension AudioListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = BookViewSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return 382
        case .reviews:
            return 44
        }
    }
}

extension AudioListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
