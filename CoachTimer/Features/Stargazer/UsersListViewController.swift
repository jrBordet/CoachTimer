//
//  StargazersListViewController.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 25/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SceneBuilder

class UsersListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var ownerField: UITextField!
	@IBOutlet var repoField: UITextField!
	@IBOutlet var notFoundLabel: UILabel!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	// MARK: Store
	
	public var store: Store<UsersViewState, UsersViewAction>?
	
	// MARK: - RxDataSource
	
	typealias ArrivalsDeparturesListSectionModel = AnimatableSectionModel<String, StargazerSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>!
	
	private let disposeBag = DisposeBag()
	
	static let startLoadingOffset: CGFloat = 20.0
		
	// MARK: - Life cycle
	
	@objc func searchTapped() {
		let searchScene = Scene<SearchViewController>().render()
		
		searchScene.store = self.store?.view(
			value: { $0.search },
			action: { .search($0) }
		)
		
		searchScene.closeClosure = { [weak self] in
			self?.store?.send(UsersViewAction.user(UsersAction.purge))

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.28, execute: {
				self?.store?.send(UsersViewAction.user(UsersAction.fetch))
			})
		}
		
		self.navigationController?.present(searchScene, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = L10n.App.name
		
		guard let store = self.store else {
			return
		}
		
		store.send(UsersViewAction.user(UsersAction.fetch))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "search", style: .plain, target: self, action: #selector(searchTapped))
		let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))

		navigationItem.rightBarButtonItems = [search]
		
		// MARK: - Config cell
		
		tableView.rowHeight = 64
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: StargazerCell.self,
			reuseIdentifier: "StargazerCell"
		)
		
		tableView.separatorColor = .lightGray
		
		// MARK: - loading
		
		store.value
			.map { $0.isLoading }
			.bind(to: self.activityIndicator.rx.isAnimating)
			.disposed(by: disposeBag)
		
		// MARK: - not found
		
		let alert = store.value
			.map { $0.alert }
			.map { $0?.isEmpty == false }
			.share(replay: 1, scope: .whileConnected)
		
		alert
			.bind(to: notFoundLabel.rx.isVisible)
			.disposed(by: disposeBag)
		
		alert
			.bind(to: tableView.rx.isHidden)
			.disposed(by: disposeBag)

		// MARK: - Bind dataSource
		
		setupDataSource()
		
		store
			.value
			.map { (state: UsersViewState) -> [StargazerSectionItem] in
				state.list.map { (model: UserState) -> StargazerSectionItem in
					StargazerSectionItem(
						id: model.id,
						name: model.name,
						imageUrl: model.imageUrl
					)
				}
			}
			.distinctUntilChanged()
			.map { (items: [StargazerSectionItem]) -> [ArrivalsDeparturesListSectionModel] in
				[
					ArrivalsDeparturesListSectionModel(
						model: "",
						items: items
					)
				]
			}
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
	
	// MARK: - Data Source Configuration
	
	private func setupDataSource() {
		dataSource = RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>(
			animationConfiguration: AnimationConfiguration(
				insertAnimation: .none,
				reloadAnimation: .none
			),
			configureCell: configureCell
		)
	}
	
}

// MARK: - cell

extension UsersListViewController {
	private var configureCell: RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>.ConfigureCell {
		return { _, table, idxPath, item in
			guard let cell = table.dequeueReusableCell(withIdentifier: "StargazerCell", for: idxPath) as? StargazerCell else {
				return UITableViewCell(style: .default, reuseIdentifier: nil)
			}
			
			cell.nameLabel.text = item.name.lowercased()
			
			if let url = item.imageUrl {
				cell.avatarImage?.load(url: url)
			}
			
			return cell
		}
	}
}

// MARK: - RxDataSource models

struct StargazerSectionItem {
	var id: String
	var name: String
	var imageUrl: URL?
}

extension StargazerSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return "\(id)"
	}
}

extension StargazerSectionItem: Equatable { }
