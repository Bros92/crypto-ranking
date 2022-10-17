import UIKit

struct Item: Codable {
    var isbn: String? // https://en.wikipedia.org/wiki/ISBN
    var title: String?
    var author: String?
}

struct ComicBook: Codable {
    var isbn: String?
    var title: String?
    var author: String?
    var marvelUniverse: Bool?
}

protocol FooViewPresenter: AnyObject {
    func refresh()
}

class FooPresenter {
    private(set) var isFetching: Bool = false
    private(set) var data: [Item] = []
    private(set) var comics: [ComicBook] = []
    private var networkManager = NetworkManager.shared
    weak var viewPresenter: FooViewPresenter?
    init(viewPresenter: FooViewPresenter?) {
        self.viewPresenter = viewPresenter
    }
    func fetchItems(saveData: Bool = true) {
        // Fetch from DB
        
        // Call network manager
        
        // save data from api response
        
        // Call refresh on main thread because UI update need to be apply on main thread
        DispatchQueue.main.async { [weak self] in
            self?.viewPresenter?.refresh()
        }

        // Save data after the response if required
        if saveData {
            self.saveItems(items: data)
        }
    }
    func saveItems(items: [Item]) {
        // Save on DB
    }
    func fetchComicBooks(saveData: Bool = true)  {
        // Fetch from DB
                
        // Call network manager
        
        // save data from api response
        
        // Call refresh on main thread because UI update need to be apply on main thread
        DispatchQueue.main.async { [weak self] in
            self?.viewPresenter?.refresh()
        }

        // Save data after the response if required
        if saveData {
            self.saveComicBooks(comicBooks: comics)
        }
    }
    func saveComicBooks(comicBooks: [ComicBook]) {
        // Save on DB
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {
        // Setup ...
    }
    func makeRequest<T: Codable>(_ type: T.Type) {}
    
}

class FooViewController: UIViewController, FooViewPresenter {
    
    private lazy var fooViewModel: FooPresenter = {
        return FooPresenter(viewPresenter: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fooViewModel.fetchItems()
        // FooViewController Declaration
    }
    
    // MARK: - FooViewPresenter
    
    func refresh() {
        // Reload view controller, table view / collection, etc...
        // ... }
    }
}
