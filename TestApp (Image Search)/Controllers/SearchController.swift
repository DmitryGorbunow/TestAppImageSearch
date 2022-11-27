//
//  SearchController.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/24/22.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettingControllerDelegate {
    
    
    struct APIResponse: Codable {
        let images_results: [Result]
    }
    
    struct Result: Codable {
        let thumbnail: String
        let link: String
        let original: String
    }
    
    fileprivate let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    var results: [Result] = []
    var size: String = "isch"
    var country: String = "us"
    var language: String = "en"
    var page = 0
    var query = ""
    
    let searchFieldController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Image Search"
        navigationItem.searchController = searchFieldController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tools", style: .done, target: self, action: #selector(toolsPressed))

        searchFieldController.searchBar.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        setupView()
        setupConstraints()
        
    }
    
    func update(size: String, country: String, language: String) {
        self.size = size
        self.country = country
        self.language = language
    }
    
    @objc func toolsPressed() {
        let vc = SettingsController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupConstraints() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionView.reloadData()
            self.page = 0
            self.query = text
            fetchPhotos(query: text, size: self.size, country: self.country, language: self.language)
        }
    }
    
    func fetchPhotos(query: String, size: String, country: String, language: String) {
        
        let countryString = "&gl=\(country)"
        let languageString = "&hl=\(language)"
        
        let urlString = "https://serpapi.com/search.json?q=\(query)\(countryString)\(languageString)&tbm=\(size)&ijn=\(self.page)&api_key=f43e807bce8230928e2237077a9c2b1120f86dd0b283e2eba5ff1881c0339f2a"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResults = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results += jsonResults.images_results
                    self?.collectionView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURlString = results[indexPath.row].original
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURlString)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FullScreenController()
        vc.selectedIndex = indexPath.row
        vc.results = results
        pushView(viewController: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == results.count - 1 {
            self.page += 1
            fetchPhotos(query: self.query, size: self.size, country: self.country, language: self.language)
        }
    }
}
