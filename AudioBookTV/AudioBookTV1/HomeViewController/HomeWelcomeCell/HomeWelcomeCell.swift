import UIKit

class HomeWelcomeCell: UITableViewCell {

    @IBOutlet weak var greetingsLbl: UILabel!
    
    @IBOutlet weak var subtitleLbl: UILabel!
    
    func configure(with viewModel: WelcomeCellViewModel) {
        greetingsLbl.text = viewModel.greeting
        subtitleLbl.text = viewModel.subtitle
    }
}
