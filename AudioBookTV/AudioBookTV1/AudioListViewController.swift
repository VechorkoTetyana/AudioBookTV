import UIKit

struct AudioList {
    let title: String
    let describtion: String
    let image: UIImage
}

class AudioListViewController: UIViewController {
    
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


