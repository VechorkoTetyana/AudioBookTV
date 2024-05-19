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
            self.view.layoutIfNeeded()
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
