import UIKit

class AudioListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
       case header = 0
        case reviews
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postReviewView: UIView!
    @IBOutlet weak var postReviewSafeView: UIView!
    @IBOutlet weak var postReviewBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var postReviewSafeBottomConstraint: NSLayoutConstraint!
    
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTableView()
        configureKeyboard()
        configurePostReviewView()
        configureTextField()
        setPostReviewBtn(enabled: false)
    }
    
    private func setPostReviewBtn(enabled isEnabled: Bool) {
        postBtn.isUserInteractionEnabled = isEnabled
        postBtn.tintColor = isEnabled ? .tintColor : UIColor(hex: "#737373")?.withAlphaComponent(0.5)
    }
    
    var isNewReviewValid: Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    @objc private func didChangeText() {
        setPostReviewBtn(enabled: isNewReviewValid)
    }
    
    private func configurePostReviewView() {
        postReviewView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        postReviewView.layer.shadowOffset = .zero
        postReviewView.layer.shadowRadius = 18.5
        postReviewView.layer.shadowPath = UIBezierPath(rect: postReviewView.bounds).cgPath
        postReviewView.layer.shadowOpacity = 1
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
        
//     UIView.animate(withDuration: duration) {
//          self.postBtn.alpha = isKeyboardPresent ? 1 : 0
//          self.view.layoutIfNeeded()
//      }
        
        UIView.animate(withDuration: duration) {
            self.postBtn.alpha = isKeyboardPresent ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.tableView.scrollToRow(at: IndexPath(row: self.book.items.count - 1, section: Section.reviews.rawValue), at: .bottom, animated: true)
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
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let text = textField.text, isNewReviewValid else { return }
        book.items.append(text)
        let indexPath = IndexPath(row: book.items.count - 1, section: Section.reviews.rawValue)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        textField.text = ""
        setPostReviewBtn(enabled: false)
    }
}

extension AudioListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .reviews:
            return book.items.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section)
        else { return UITableViewCell() }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookHeaderCell", for: indexPath) as! BookHeaderCell
            
            cell.configure(with: book)
            
            return cell
        case .reviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListItemCellNew") as? AudioListItemCellNew
            else { return UITableViewCell() }
            
            let review = book.items[indexPath.row]
            cell.configure(with: review)
            
            return cell
            
        }
    }
}

extension AudioListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
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
