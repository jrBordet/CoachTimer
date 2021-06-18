//
//  SearchViewController.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture

class SessionViewController: UIViewController {
	@IBOutlet var userImage: UIImageView!
	@IBOutlet var timerBackgroundView: UIView! {
		didSet {
			timerBackgroundView.clipsToBounds = true
			timerBackgroundView.layer.cornerRadius = 5 //timerBackgroundView.frame.width / 2
		}
	}
	
	@IBOutlet var startButton: UIButton!
	@IBOutlet var stopButton: UIButton!
	@IBOutlet var lapButton: UIButton!
	@IBOutlet var timerLabel: UILabel!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var distanceField: UITextField!
	
	// MARK: - RxDataSource
	
	typealias SessionListSectionModel = AnimatableSectionModel<String, SessionSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<SessionListSectionModel>!
	
	// MARK: - Store
	
	public var store: Store<SessionState, SessionAction>?
	
	private let disposeBag = DisposeBag()
	
	public var closeClosure: (() -> Void)?
	
	var mainTimer: Observable<Int>!
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let store = self.store else {
			return
		}
		
		// MARK: - resign keyboard
		
		startButton.rx
			.tap
			.bind { [weak self] in
				self?.distanceField.resignFirstResponder()
			}
			.disposed(by: disposeBag)
		
		// MARK: - Distance
		
		distanceField.rx
			.text
			.compactMap { $0 }
			.map { Int($0) }
			.bind(to: store.rx.distance)
			.disposed(by: disposeBag)
		
		// MARK: - Config cell
		
		tableView.rowHeight = 33
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: SessionCell.self,
			reuseIdentifier: "SessionCell"
		)
		
		func stringFromTimeInterval(_ ms: Int) -> String {
			String(
				format: "%0.2d:%0.2d.%0.1d",
				arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10]
			)
		}
		
		store
			.value
			.map { "\($0.user?.name ?? "") \($0.user?.surname ?? "")" }
			.bind(to: usernameLabel.rx.text)
			.disposed(by: disposeBag)
		
		let start = startButton.rx.tap.map { true }.share(replay: 1, scope: .whileConnected)
		let stop = stopButton.rx.tap.map { false }.share(replay: 1, scope: .whileConnected)
		
		let startStop = Observable<Bool>.merge([start, stop])
		
		mainTimer = Observable<Int>
			.interval(.milliseconds(1), scheduler: MainScheduler.instance)
			.withLatestFrom(startStop, resultSelector: { _, running in running })
			.filter { $0 }
			.scan(0, accumulator: { (acc, _) in
				acc + 1
			})
			.startWith(0)
			.share(replay: 1, scope: .whileConnected)
		
		mainTimer
			.map { stringFromTimeInterval($0) }
			.asDriver(onErrorJustReturn: "")
			.drive(timerLabel.rx.text)
			.disposed(by: disposeBag)

		let lapsValues = mainTimer
			.sample(lapButton.rx.tap)
			.scan ([Int](), accumulator: { lapTimes, newTime in
				lapTimes + [newTime - lapTimes.reduce (0, +)]
			})
			.share(replay: 1)
		
		lapsValues
			.map { laps  -> [Lap] in
				laps.enumerated().map { index, value in
					Lap(
						id: index,
						time: value
					)
				}
			}
			.bind(to: store.rx.laps)
			.disposed(by: disposeBag)
				
		let laps = lapsValues
			.map { $0.map { stringFromTimeInterval($0) } }
			.share(replay: 1)
		
		// MARK: - User Image
		
		store.value
			.map { $0.user?.imageUrl }
			.subscribe(onNext: { [weak self] url in
				guard
					let self = self,
					let url = url else {
					return
				}
				
				// TODO: refactor this
				
				self.userImage.load(url: url)
			})
			.disposed(by: disposeBag)
		
		// MARK: - Bind dataSource
		
		setupDataSource()
		
		laps.map {
			$0.enumerated().map { index, value in
				SessionSectionItem(id: String(index), time: value)
			}
		}
		.map { items -> [SessionListSectionModel] in
			[
				SessionListSectionModel(model: "", items: items)
			]
		}
		.asDriver(onErrorJustReturn: [])
		.drive(tableView.rx.items(dataSource: dataSource))
		.disposed(by: disposeBag)
	}
	
	// MARK: - Data Source Configuration
	
	private func setupDataSource() {
		dataSource = RxTableViewSectionedAnimatedDataSource<SessionListSectionModel>(
			animationConfiguration: AnimationConfiguration(
				insertAnimation: .fade,
				reloadAnimation: .none
			),
			configureCell: configureCell
		)
	}
}

// MARK: - RxDataSource models

struct SessionSectionItem {
	var id: String
	var time: String
}

extension SessionSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return "\(id)"
	}
}

extension SessionSectionItem: Equatable { }

// MARK: - cell

extension SessionViewController {
	private var configureCell: RxTableViewSectionedAnimatedDataSource<SessionListSectionModel>.ConfigureCell {
		return { _, table, idxPath, item in
			guard let cell = table.dequeueReusableCell(withIdentifier: "SessionCell", for: idxPath) as? SessionCell else {
				return UITableViewCell(style: .default, reuseIdentifier: nil)
			}
			
			cell.timeLabel.text =  "\(item.id)" + " - " + item.time
			
			return cell
		}
	}
}
