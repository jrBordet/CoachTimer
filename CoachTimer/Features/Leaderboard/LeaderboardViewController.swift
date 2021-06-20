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

extension Reactive where Base: Store<LeaderboardState, LeaderboardAction> {
	var sort: Binder<(Sorting)> {
		Binder(self.base) { store, value in
			store.send(LeaderboardAction.sort(value))
		}
	}
}

class LeaderboardViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var sortingController: UISegmentedControl!
	
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
		
		sortingController.rx
			.selectedSegmentIndex
			.map { index in
				if index == 0 {
					return Sorting.speed
				} else {
					return Sorting.laps
				}
			}
			.bind(to: store.rx.sort)
			.disposed(by: disposeBag)
				
		setupDataSource()
		
		store
			.value
			//.debug("[LEADERBOARD]", trimOutput: false)
			.map { (state: LeaderboardState) -> [LeaderboardSectionItem] in
				// TODO: check this, something goes wrong with RxDataSource
//				return state
//					.sessions
//					.map { (model: Session) -> LeaderboardSectionItem in
//						LeaderboardSectionItem(
//							id: model.id,
//							title: model.user?.id ?? "",
//							name: model.user?.name ?? "",
//							surname: model.user?.surname ?? "",
//							imageUrl: model.user?.imageUrl,
//							laps: model.laps.count,
//							speed: model.speed()
//						)
//					}
				
				
				switch state.sort {
				case .laps:
					return state
						.sessions
						.sorted { s1, s2 in
							s1.laps.count > s2.laps.count
						}
						.map { (model: Session) -> LeaderboardSectionItem in
							LeaderboardSectionItem(
								id: model.id,
								title: model.user?.id ?? "",
								name: model.user?.name ?? "",
								surname: model.user?.surname ?? "",
								imageUrl: model.user?.imageUrl,
								laps: model.laps.count,
								speed: model.peakSpeed(),
								sort: state.sort
							)
						}
				case .speed:
					return state
						.sessions
						.sorted { s1, s2 in
							s1.peakSpeed() > s2.peakSpeed()
						}
						.map { (model: Session) -> LeaderboardSectionItem in
							LeaderboardSectionItem(
								id: model.id,
								title: model.user?.id ?? "",
								name: model.user?.name ?? "",
								surname: model.user?.surname ?? "",
								imageUrl: model.user?.imageUrl,
								laps: model.laps.count,
								speed: model.peakSpeed(),
								sort: state.sort
							)
						}
				}
			}
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
			
			let speed = item.speed, speedFormat = ".1"
			cell.speedLabel.text = "\(speed.format(f: speedFormat))"
			
			switch item.sort {
			case .speed:
				cell.speedLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
				cell.lapsLabel.font = UIFont.systemFont(ofSize: 20)
				break
			case .laps:
				cell.lapsLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
				cell.speedLabel.font = UIFont.systemFont(ofSize: 20)
				
				break
			}
			
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
	var speed: Double
	var sort: Sorting
}

extension LeaderboardSectionItem {
	static var empty = Self(
		id: "",
		title: "",
		name: "",
		surname: "",
		laps: 0,
		speed: 0,
		sort: .speed
	)
}

extension LeaderboardSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return UUID().uuidString
	}
}

extension LeaderboardSectionItem: Equatable { }
