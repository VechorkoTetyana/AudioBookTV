import UIKit

class BookHeaderCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    var didTapPurchase: (() -> ())?
    
    private var book: Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playBtn.layer.cornerRadius = 22
        playBtn.layer.masksToBounds = true
        selectionStyle = .none
    }
    
    func configure(with book: Book) {
        self.book = book
        
        titleLbl.text = book.title
        subtitleLbl.text = book.subtitle
        coverImageView.image = UIImage(named: book.coverImageName)
        configureButton(with: book)

    }
    
    private func configureButton(with book: Book) {
        if !book.isInLibrary {
            playBtn.setTitle(configurePurchaseButtonTitle(with: book.priceCredit), for: .normal)
            playBtn.setTitleColor(.white, for: .normal)
            playBtn.backgroundColor = .mainButton
        } else {
            playBtn.setTitle("Play", for: .normal)
            playBtn.setTitleColor(.black, for: .normal)
            playBtn.backgroundColor = .secondaryButton

        }
        
        playBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private func configurePurchaseButtonTitle(with credits: Int) -> String {
        if credits <= 1{
            return "Purchase (\(credits) credit)"
        } else {
            return "Purchase (\(credits) credits)"
        }
    }
    
    
    @IBAction func didTapPlayBtn(_ sender: Any) {
        guard let book, !book.isInLibrary else { return }
  //    guard !book.isInLibrary else { return }
        
        didTapPurchase?()
    }
}
    

