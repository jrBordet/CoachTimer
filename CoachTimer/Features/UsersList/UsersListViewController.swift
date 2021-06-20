//
//  StargazersListViewController.swift
//  CoachTimer
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
	
	public var store: Store<UsersSessionsViewState, UsersSessionsViewAction>?
	
	// MARK: - RxDataSource
	
	typealias UsersListSectionModel = AnimatableSectionModel<String, UserSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<UsersListSectionModel>!
	
	private let disposeBag = DisposeBag()
		
	// MARK: - Life cycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		store?.send(UsersSessionsViewAction.user(UsersAction.selectUser(nil)))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Users"
		
		guard let store = self.store else {
			return
		}
		
		// MARK: - load users
		
		/// Use `fetch` instead to retrieve users frorm the network
		// store.send(UsersSessionsViewAction.user(UsersAction.fetch))
		
		store.send(UsersSessionsViewAction.user(UsersAction.load))
		
		// MARK: - Config cell
		
		tableView.rowHeight = 64
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: UserCell.self,
			reuseIdentifier: "UserCell"
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
			.map { (state: UsersSessionsViewState) -> [UserSectionItem] in
				state.list.map { (model: User) -> UserSectionItem in
					UserSectionItem(
						id: model.id,
						title: model.title,
						name: model.name,
						surname: model.surname,
						imageUrl: model.imageUrl
					)
				}
			}
			.distinctUntilChanged()
			.map { (items: [UserSectionItem]) -> [UsersListSectionModel] in
				[
					UsersListSectionModel(
						model: "",
						items: items
					)
				]
			}
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
		
		// MARK: - User selected
		
		tableView.rx
			.modelSelected(UserSectionItem.self)
			.observeOn(MainScheduler.instance)
			.map { (sectionItem: UserSectionItem) -> User in
				User(
					id: sectionItem.id,
					title: sectionItem.title,
					name: sectionItem.name,
					surname: sectionItem.surname,
					imageUrl: sectionItem.imageUrl
				)
			}
			.bind(to: store.rx.user)
			.disposed(by: disposeBag)
		
		// MARK: - Present Session
		
		store.value
			.map { $0.currentUser }
			.distinctUntilChanged()
			.ignoreNil()
			.map { _ in Void() }
			.bind(to: self.rx.pushSession)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Data Source Configuration
	
	private func setupDataSource() {
		dataSource = RxTableViewSectionedAnimatedDataSource<UsersListSectionModel>(
			animationConfiguration: AnimationConfiguration(
				insertAnimation: .none,
				reloadAnimation: .none
			),
			configureCell: configureCell
		)
	}
	
}

extension Reactive where Base: UsersListViewController {
	var pushSession: Binder<Void> {
		Binder(self.base) { vc, interact in
			
			let searchScene = Scene<SessionViewController>().render()
			
			searchScene.store = vc.store?.view(
				value: { $0.session },
				action: { .session($0) }
			)
			
			vc.navigationController?.pushViewController(searchScene, animated: true)
		}
	}
}

// MARK: - cell

extension UsersListViewController {
	private var configureCell: RxTableViewSectionedAnimatedDataSource<UsersListSectionModel>.ConfigureCell {
		return { _, table, idxPath, item in
			guard let cell = table.dequeueReusableCell(withIdentifier: "UserCell", for: idxPath) as? UserCell else {
				return UITableViewCell(style: .default, reuseIdentifier: nil)
			}
						
			cell.nameLabel.text = item.title.capitalized + " " + item.name.capitalized + " " + item.surname.capitalized
			
			if let url = item.imageUrl {
				cell.avatarImage?.load(url: url)
			}
			
			return cell
		}
	}
}

// MARK: - RxDataSource models

struct UserSectionItem {
	var id: String
	var title: String
	var name: String
	var surname: String
	var imageUrl: URL?
}

extension UserSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return "\(id)"
	}
}

extension UserSectionItem: Equatable { }
