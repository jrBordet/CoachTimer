//
//  LeaderboardViewController.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 19/06/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SceneBuilder

class LeaderboardViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: Store
	
	public var store: Store<LeaderboardState, LeaderboardAction>?
	
	// MARK: - RxDataSource
	
	typealias UsersListSectionModel = AnimatableSectionModel<String, LeaderboardSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<UsersListSectionModel>!
	
	private let disposeBag = DisposeBag()
		
	// MARK: - Life cycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = L10n.App.name
		
		guard let store = self.store else {
			return
		}
				
		// MARK: - Config cell
		
		tableView.rowHeight = 64
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: LeaderboardCell.self,
			reuseIdentifier: "LeaderboardCell"
		)
		
		tableView.separatorColor = .lightGray
		
		// MARK: - Bind dataSource
		
		setupDataSource()
		
		store
			.value
			.map { (state: LeaderboardState) -> [LeaderboardSectionItem] in
				state.sessions.map { (model: Session) -> LeaderboardSectionItem in
					LeaderboardSectionItem(
						id: model.id,
						title: model.user?.id ?? "",
						name: model.user?.name ?? "",
						surname: model.user?.surname ?? "",
						imageUrl: model.user?.imageUrl,
						laps: model.laps.count
					)
				}
			}
			.distinctUntilChanged()
			.map { (items: [LeaderboardSectionItem]) -> [UsersListSectionModel] in
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

// MARK: - cell

extension LeaderboardViewController {
	private var configureCell: RxTableViewSectionedAnimatedDataSource<UsersListSectionModel>.ConfigureCell {
		return { _, table, idxPath, item in
			guard let cell = table.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: idxPath) as? LeaderboardCell else {
				return UITableViewCell(style: .default, reuseIdentifier: nil)
			}
						
			cell.nameLabel.text = item.name.capitalized + " " + item.surname.capitalized
			cell.lapsLabel.text = "\(item.laps)"
			
			if let url = item.imageUrl {
				cell.avatarImage?.load(url: url)
			}
			
			return cell
		}
	}
}

// MARK: - RxDataSource models

struct LeaderboardSectionItem {
	var id: String
	var title: String
	var name: String
	var surname: String
	var imageUrl: URL?
	var laps: Int
}

extension LeaderboardSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return "\(id)"
	}
}

extension LeaderboardSectionItem: Equatable { }
