import UIKit

class HomeBookShowcaseCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var books: [Book] = []
    
    var didSelectBook: ((Book) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func configure(with viewModel: BooksShowcaseViewModel) {
        self.titleLbl.text = viewModel.title
        self.books = viewModel.books
        collectionView.reloadData()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ShowcaseBookCell", bundle: nil), forCellWithReuseIdentifier: "ShowcaseBookCell")
    }
}

extension HomeBookShowcaseCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseBookCell", for: indexPath) as? ShowcaseBookCell else { return UICollectionViewCell() }
        
        let book = books[indexPath.item]
        cell.configure(book)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
}

extension HomeBookShowcaseCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 180, height: 231)
    }
}

extension HomeBookShowcaseCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
        
        didSelectBook?(book)
    }
}
