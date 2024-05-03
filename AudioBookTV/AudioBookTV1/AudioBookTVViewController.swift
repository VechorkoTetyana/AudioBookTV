import UIKit

class AudioBookTVViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func present(with audioList: AudioList) {
        let audioListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
        
        audioListViewController.audioList = audioList
        
        present(audioListViewController, animated: true)
        
    }
    
    @IBAction func whyTapped(_ sender: Any) {
        
        present(with: AudioList(
            title: "Why We Sleep",
            describtion: "Unlocking the Power of Sleep and Dreams",
            image: .whyWeSleep
        ))
    }
    
    @IBAction func dopamineTapped(_ sender: Any) {
        present(with: AudioList(
            title: "Dopamine Nation",
            describtion: "Finding Balance in the Age of Indulgence",
            image: .dopamineNation
        ))
    }
    
    @IBAction func startTapped(_ sender: Any) {
        present(with: AudioList(
            title: "Start with Why",
            describtion: "How Great Leaders Inspire Everyone to Take Action",
            image: .startWithWhy
        ))
    }
    
}
