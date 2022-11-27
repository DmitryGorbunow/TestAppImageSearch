//
//  NewController.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/25/22.
//

import UIKit

class FullScreenController: UIViewController, UIScrollViewDelegate {
    
    var selectedIndex: Int = 0
    var results: [SearchController.Result] = []
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentMode = .scaleAspectFit
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .systemBackground
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 6
        return sv
    }()
    
    lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return button
    }()
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward"), for: .normal)
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward"), for: .normal)
        button.addTarget(self, action: #selector(previousBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var sourceBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Source", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(sourceBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        configure(with: results[selectedIndex].original)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.addSubview(img)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(closeBtn)
        buttonStackView.addArrangedSubview(previousBtn)
        buttonStackView.addArrangedSubview(nextBtn)
        buttonStackView.addArrangedSubview(sourceBtn)
    }
    
    func setupConstraint() {
        scrollView.frame = view.bounds
        img.frame = scrollView.bounds
        buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (navigationController?.navigationBar.frame.height)!).isActive = true
    }
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.img.image = image
            }
        }.resume()
    }
    
    @objc func closeBtnTapped() {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func previousBtnTapped() {
        if self.selectedIndex != 0 {
            self.selectedIndex -= 1
            configure(with: results[selectedIndex].original)
        }
    }
    
    @objc func nextBtnTapped() {
        if self.selectedIndex != results.count - 1 {
            self.selectedIndex += 1
            configure(with: results[selectedIndex].original)
        }
    }
    
    @objc func sourceBtnTapped() {
        guard let url = URL(string: results[selectedIndex].link) else {
            return
        }
        let vc = WebController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    
    }
}

extension UIViewController {
    func pushView(viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        self.view.window?.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func dimissView() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .reveal
        transition.subtype = .fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }
}
