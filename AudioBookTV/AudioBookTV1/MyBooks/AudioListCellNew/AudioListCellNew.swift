import UIKit

class AudioListCellNew: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with audioList: AudioList) {
        coverImageView.image = audioList.image
        titleLbl.text = "\(audioList.title) (\(audioList.rating))"
    }
}
