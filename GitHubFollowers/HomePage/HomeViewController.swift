//
//  HomeViewController.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayFollowers(viewModel: HomeModels.HomeModel.ViewModel)
    func displayError(viewModel: HomeModels.HomeModel.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic)?
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Configuration Architecture
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchButtonTap()
    }
    
    // MARK: - UI Setup
    private var coverImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "github")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        return image
    }()
    
    private var header: UILabel = {
        var header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "GitHub"
        header.textAlignment = .center
        header.textColor = .white
        header.font = UIFont(name: "FiraGO-BookItalic", size: 50)
        return header
    }()
    
    private var subHeader: UILabel = {
        var subHeader = UILabel()
        subHeader.translatesAutoresizingMaskIntoConstraints = false
        subHeader.text = "Followers"
        subHeader.textAlignment = .center
        subHeader.textColor = .white
        subHeader.font = UIFont(name: "FiraGO-BookItalic", size: 30)
        return subHeader
    }()
    
    private var followersField: UITextField = {
        var followersField = UITextField()
        followersField.translatesAutoresizingMaskIntoConstraints = false
        followersField.placeholder = "Enter a username"
        followersField.textAlignment = .center
        followersField.textColor = .blue
        followersField.layer.cornerRadius = 15
        followersField.backgroundColor = UIColor(.white).withAlphaComponent(0.9)
        followersField.font = UIFont(name: "FiraGO-BookItalic", size: 18)
        return followersField
    }()
    
    private var searchButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Get Followers", for: .normal)
        button.setImage(UIImage(named: "followers"), for: .normal)
        button.backgroundColor = UIColor(red: 2/255, green: 173/255, blue: 238/255, alpha: 1)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private func setupUI() {
        setupCoverImage()
        setupHeader()
        setupSubHeader()
        setupFollowersField()
        setupSearchButton()
    }
    
    private func setupCoverImage() {
        view.addSubview(coverImage)
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            coverImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImage.widthAnchor.constraint(equalToConstant: 100),
            coverImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupHeader() {
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 20),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSubHeader() {
        view.addSubview(subHeader)
        NSLayoutConstraint.activate([
            subHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            subHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subHeader.widthAnchor.constraint(equalTo: view.widthAnchor),
            subHeader.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupFollowersField() {
        view.addSubview(followersField)
        NSLayoutConstraint.activate([
            followersField.topAnchor.constraint(equalTo: subHeader.bottomAnchor, constant: 40),
            followersField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            followersField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            followersField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            followersField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSearchButton() {
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    private func searchButtonTap() {
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.requestByUsername()
        }), for: .touchUpInside)
    }
    
    func requestByUsername() {
        guard let username = followersField.text, !username.isEmpty else {
            let alertController = UIAlertController(title: "Missing Username", message: "Please enter a username to search for followers.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            return
        }
        let request = HomeModels.HomeModel.Request(username: username)
        interactor?.requestByUsername(requestUsername: request)
    }
    
    func displayFollowers(viewModel: HomeModels.HomeModel.ViewModel) {
        router?.routeToFollowersView(followers: viewModel.followers ?? [])
    }
    
    func displayError(viewModel: HomeModels.HomeModel.ViewModel) {
        guard let errorMessage = viewModel.error else { return }
        let alertController = UIAlertController(title: "Problem Fetching Data", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
