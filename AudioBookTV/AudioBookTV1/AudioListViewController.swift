import UIKit

struct AudioList {
    let title: String
    let describtion: String
    let image: UIImage
    let rating: String
    let items: [String]
}

class AudioListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var describLbl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var audioList: AudioList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        playButton.layer.cornerRadius = 22
        playButton.layer.masksToBounds = true
        
        configure()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        let cellName = "AudioListItemCellNew"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func configure() {
        titleLbl.text = audioList.title
        iconImageView.image = audioList.image
        describLbl.text = audioList.describtion
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func playButton(_ sender: Any) {
    }
}

extension AudioListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        audioList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListItemCellNew") as? AudioListItemCellNew
        else { return UITableViewCell() }
        
        let item = audioList.items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}
