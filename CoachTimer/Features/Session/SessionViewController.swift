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
			timerBackgroundView.layer.cornerRadius = timerBackgroundView.frame.width / 2
			timerBackgroundView.layer.borderColor = UIColor.black.cgColor
			timerBackgroundView.layer.borderWidth = 0.5
		}
	}
	
	@IBOutlet var startButton: UIButton!
	@IBOutlet var stopButton: UIButton!
	@IBOutlet var lapButton: UIButton!
	@IBOutlet var timerLabel: UILabel!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var lapsCountLabel: UILabel!
	@IBOutlet var peakSpeedLabel: UILabel!
	@IBOutlet var averageSpeedLabel: UILabel!
	@IBOutlet var timeVarianceLabel: UILabel!
	
	// MARK: - RxDataSource
	
	typealias SessionListSectionModel = AnimatableSectionModel<String, SessionSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<SessionListSectionModel>!
	
	// MARK: - Store
	
	public var store: Store<SessionState, SessionAction>?
	
	private let disposeBag = DisposeBag()
	
	public var closeClosure: (() -> Void)?
	
	var mainTimer: Observable<Int>!
	
	// MARK: - Life cycle
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// MARK: Save current session
		store?.send(.saveCurrentSession)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let store = self.store else {
			return
		}
		
		func formatter(_ v: Double, from: String) -> String {
			let v1 = v, speedFormat = ".1"
			let s = "\(v1.format(f: speedFormat))"

			return "\(from) \(s)"
		}
		
		/// disable start button for invalid distance
		store.value
			.map { $0.distance }
			.ignoreNil()
			.map { $0 > 0 }
			.bind(to: startButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		// MARK: - Laps count
		
		store.value
			.map { $0.lapsCount }
			.map { "laps: \($0)" }
			.bind(to: lapsCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		// MARK: - Time variance
		
		store.value
			.map { (distance: $0.distance, laps: $0.laps) }
			.map { tuple -> String in
				guard
					let distance = tuple.0,
					tuple.laps.count > 0 else {
					return "time var.:"
				}

				let result = timeVariance(tuple.1, distance: distance)
				
				return formatter(result, from: "time var.:")
			}
			.bind(to: timeVarianceLabel.rx.text)
			.disposed(by: disposeBag)

		
		// MARK: - Average speed
		
		store.value
			.map { (distance: $0.distance, laps: $0.laps) }
			.map { tuple -> String in
				guard
					let distance = tuple.0,
					tuple.laps.count > 0 else {
					return "avg speed:"
				}

				let result = averageSpeed(tuple.1, distance: distance)
				
				return formatter(result, from: "avg speed:")
			}
			.bind(to: averageSpeedLabel.rx.text)
			.disposed(by: disposeBag)
				
		// MARK: - Peak speed
		
		store.value
			.map { $0.peakSpeed }
			.map { speed in
				let speed = speed, speedFormat = ".1"
				let result = "\(speed.format(f: speedFormat))"

				return "peak speed: \(result)"
			}
			.bind(to: peakSpeedLabel.rx.text)
			.disposed(by: disposeBag)
	
		// MARK: - Config cell
		
		tableView.rowHeight = 33
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: SessionCell.self,
			reuseIdentifier: "SessionCell"
		)
		
		// MARK: - session name
		
		let alert = UIAlertController(
			title: "Session distance",
			message: "Enter a distance for this session",
			preferredStyle: .alert
		)
		
		alert.addTextField { textField in
			textField.placeholder = "distance in [m]"
			textField.text = "100"
		}
		
		alert.addAction(
			UIAlertAction(
				title: "Ok",
				style: .default,
				handler: { [weak alert, weak self] _ in
					guard let textField = alert?.textFields?.first else {
						return
					}
					
					
					self?.store?.send(.distance(Int(textField.text ?? "1")))
				}
			)
		)
		
		// 4. Present the alert.
		self.present(alert, animated: true, completion: nil)
		
		// MARK: - Username
		
		store
			.value
			.map { "\($0.user?.name ?? "") \($0.user?.surname ?? "")" }
			.bind(to: usernameLabel.rx.text)
			.disposed(by: disposeBag)
		
		// MARK: - Timer
		
		let start = startButton.rx.tap.map { true }.share(replay: 1, scope: .whileConnected)
		let stop = stopButton.rx.tap.map { false }.share(replay: 1, scope: .whileConnected)
		
		let startStop = Observable<Bool>.merge([start, stop])
		
		// MARK: - start timer
		mainTimer = Observable<Int>
			.interval(.milliseconds(100), scheduler: MainScheduler.instance)
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
				
//		stopButton.rx
//			.tap
//			.bind(to: store.rx.saveCurrentSession)
//			.disposed(by: disposeBag)
		
		// MARK: - take lap
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
			.compactMap { $0 }
			.bind(to: self.rx.image)
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

func stringFromTimeInterval(_ ms: Int) -> String {
	String(
		format: "%0.2d:%0.2d.%0.1d",
		arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10]
	)
}


extension Reactive where Base: SessionViewController {
	var image: Binder<(URL)> {
		Binder(base) { vc, url in
			vc.userImage.load(url: url)
		}
	}
}
