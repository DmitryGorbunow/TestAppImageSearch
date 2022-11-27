//
//  SettingsController.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/24/22.
//

import UIKit

protocol SettingControllerDelegate {
    func update(size: String, country: String, language: String)
}

class SettingsController: UIViewController {
    
    var size: String = "isch"
    var country: String = "us"
    var language: String = "en"
    
    var delegate: SettingControllerDelegate?
        
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedTinted()
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sizeHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var countryHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var saveHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var languageHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Image Size"
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language"
        return label
    }()
    
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        return label
    }()
    
    lazy var sizeButton: UIButton = {

        let button = UIButton(type: .system)
        button.configuration = .bordered()
        let optionClosure = { [self](action: UIAction) in
            switch action.title {
             case "Any":
                    self.size = "isch"
            case "Large":
                self.size = "isch&tbs=isz:l"
            case "Medium":
                self.size = "isch&hl=ru&tbs=isz:m"
            case "Icon":
                self.size = "isch&hl=ru&tbs=isz:i"
            default:
                self.size = "isch"
            }
        }
            
        button.menu = UIMenu(children: [
            UIAction(title: "Any", state: .on, handler: optionClosure),
            UIAction(title: "Large", handler: optionClosure),
            UIAction(title: "Medium", handler: optionClosure),
            UIAction(title: "Icon", handler: optionClosure)
        ])
        button.automaticallyUpdatesConfiguration = true
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var countryButton: UIButton = {

        let button = UIButton(type: .system)
        button.configuration = .bordered()
        let optionClosure = {(action: UIAction) in
            switch action.title {
            case "United States":
                self.country = "us"
            case "Russia":
                self.country = "ru"
            case "Germany":
                self.country = "de"
            case "United Kingdom":
                self.country = "uk"

            default:
                self.country = "us"
            }
        }
            
        button.menu = UIMenu(children: [
            UIAction(title: "United States", state: .on, handler: optionClosure),
            UIAction(title: "Russia", handler: optionClosure),
            UIAction(title: "Germany", handler: optionClosure),
            UIAction(title: "United Kingdom", handler: optionClosure)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var languageButton: UIButton = {

        let button = UIButton(type: .system)
        button.configuration = .bordered()
        let optionClosure = {(action: UIAction) in
            switch action.title {
            case "English":
                self.language = "en"
            case "Russian":
                self.language = "ru"
            case "French":
                self.language = "fr"
            case "German":
                self.language = "de"

            default:
                self.language = "en"
            }
        }
            
        button.menu = UIMenu(children: [
            UIAction(title: "English", state: .on, handler: optionClosure),
            UIAction(title: "Russian", handler: optionClosure),
            UIAction(title: "French", handler: optionClosure),
            UIAction(title: "German", handler: optionClosure)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    @objc func saveButtonPressed() {
        delegate?.update(size: self.size, country: self.country, language: self.language)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupConstraint()
    }
    
    func setupView() {
        view.addSubview(buttonVStackView)
        buttonVStackView.addArrangedSubview(sizeHStackView)
        buttonVStackView.addArrangedSubview(countryHStackView)
        buttonVStackView.addArrangedSubview(languageHStackView)
        buttonVStackView.addArrangedSubview(saveHStackView)
        
        sizeHStackView.addArrangedSubview(sizeLabel)
        sizeHStackView.addArrangedSubview(sizeButton)
        
        countryHStackView.addArrangedSubview(countryLabel)
        countryHStackView.addArrangedSubview(countryButton)
        
        languageHStackView.addArrangedSubview(languageLabel)
        languageHStackView.addArrangedSubview(languageButton)
        
        saveHStackView.addArrangedSubview(saveButton)
    }
    
    func setupConstraint() {
        buttonVStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        buttonVStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        buttonVStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        buttonVStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 2).isActive = true
    }
}
