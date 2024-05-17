import UIKit

class AudioBookTVViewController: UIViewController{
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var lists: [AudioList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lists = audioList()
        configureTableView()
    }
    
   private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cellName = "AudioListCellNew"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableView.rowHeight = 44
    }
    
    func present(with audioList: AudioList) {
        let audioListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
        
        audioListViewController.audioList = audioList
        
        audioListViewController.modalPresentationStyle = .fullScreen
        
        present(audioListViewController, animated: true)
    }
    
    private func audioList() -> [AudioList] {
        
        var lists = [AudioList]()
        
        lists.append(AudioList(
            title: "Why We Sleep",
            describtion: "Unlocking the Power of Sleep and Dreams",
            authors: [],
            image: .whyWeSleep,
            rating: "3.7",
            items: whyItems()
        ))
        
        lists.append(AudioList(
            title: "Dopamine Nation",
            describtion: "Finding Balance in the Age of Indulgence",
            authors: [],
            image: .dopamineNation,
            rating: "4.2",
            items: dopamineItems()
        ))
        
        lists.append(AudioList(
            title: "Start with Why",
            describtion: "How Great Leaders Inspire Everyone to Take Action",
            authors: [],
            image: .startWithWhy,
            rating: "4.5",
            items: startItems()
        ))
        
        return lists
    }
    
    private func whyItems() -> [String] {
        var items = [String]()
        items.append("Amazingly informative, unfitting reader")
        items.append("In-depth sleep analysis that fails to grasp")
        items.append("A must read if you want to live longer")
        items.append("That Narrator!!!")
        items.append("An eye-opener")
        items.append("We don't sleep enough. Here's how.")
        items.append("Un libro genial")
        
        return items
    }
    
    private func dopamineItems() -> [String] {
        var items = [String]()
        items.append("Brilliant core message!")
        items.append("super")
        items.append("Nice Explanation about Addiction")
        items.append("Pleasure and pain; honesty and balance")
        items.append("Great Book")
        items.append("A very good read with great story telling")
        items.append("Verständlich, eindringlich und nachhaltig")
        
        return items
    }
    
    private func startItems() -> [String] {
        var items = [String]()
        items.append("Very good message, but highly repetitive")
        items.append("es wiederholt sich, aber")
        items.append("amazing book")
        items.append("Listen and learn")
        items.append("Gut, aber hinten raus repititiv")
        items.append("A worthy book.")
        
        return items
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true)
    }
}

extension AudioBookTVViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListCellNew") as? AudioListCellNew
        else { return UITableViewCell() }
        
        let audioList = lists[indexPath.row]
        
        cell.configure(with: audioList)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension AudioBookTVViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioList = lists[indexPath.row]
        present(with: audioList)
    }
}
