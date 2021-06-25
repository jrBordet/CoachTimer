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
import SceneBuilder

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
	
	@IBOutlet var startButton: UIButton! {
		didSet {
			startButton.clipsToBounds = true
			startButton.layer.cornerRadius = 5
		}
	}
	@IBOutlet var stopButton: UIButton! {
		didSet {
			stopButton.clipsToBounds = true
			stopButton.layer.cornerRadius = 5
		}
	}
	@IBOutlet var lapButton: UIButton! {
		didSet {
			lapButton.clipsToBounds = true
			lapButton.layer.cornerRadius = 5
		}
	}
	@IBOutlet var timerLabel: UILabel!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var lapsCountLabel: UILabel!
	@IBOutlet var peakSpeedLabel: UILabel!
	@IBOutlet var cadenceLabel: UILabel!
	
	private var goingForwards: Bool = false
	
	// MARK: - RxDataSource
	
	typealias SessionListSectionModel = AnimatableSectionModel<String, SessionSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<SessionListSectionModel>!
	
	// MARK: - Store
	
	public var store: Store<SessionState, SessionAction>?
	
	private let disposeBag = DisposeBag()
		
	var mainTimer: Observable<Int>!
	
	// MARK: - Open chart
	
	@objc func chartTapped() {
		guard let store = self.store else {
			return
		}
				
		let chart = Scene<SessionChartViewController>().render()
		
		chart.store = store
		
		self.present(chart, animated: true, completion: nil)
	}
	
	// MARK: - Life cycle
	
	@objc func back() {
		store?.send(.saveCurrentSession(Date()))
		
		self.navigationController?.popViewController(animated: true)
	}
	
	deinit {
		print("SessionViewController deinit")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Custom back button to save current session
		self.navigationItem.hidesBackButton = true
		let newBackButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action:  #selector(back))
		self.navigationItem.leftBarButtonItem = newBackButton
		
		guard let store = self.store else {
			return
		}
		
		// Chart button
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "chart", style: .plain, target: self, action: #selector(chartTapped))
		let chart = UIBarButtonItem(title: "chart", style: .plain, target: self, action:  #selector(chartTapped))
		navigationItem.rightBarButtonItems = [chart]
		
		// MARK: - Cadence
		
		store.value
			.map { (distance: $0.distance, laps: $0.laps) }
			.map { tuple -> String in
				guard
					let distance = tuple.0,
					tuple.laps.count > 0 else {
					return "cadence"
				}

				let result = cadence(tuple.1, distance: distance)
				
				return formatter(result, from: "lap/min:", format: ".1")
			}
			.bind(to: cadenceLabel.rx.text)
			.disposed(by: disposeBag)
		
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
		
		// MARK: - Session distance
		
		let alert = UIAlertController(
			title: "Session distance",
			message: "Enter a distance for this session",
			preferredStyle: .alert
		)
		
		alert.addTextField { textField in
			textField.placeholder = "distance in [m]"
			textField.text = "25"
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
		
		present(alert, animated: true, completion: nil)
		
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
				
		// MARK: - Take a lap
		
		let lapsValues = mainTimer
			.sample(
				Observable.merge(
					lapButton.rx.tap.map { true },
					stopButton.rx.tap.map { true }
				)
			)
			.scan ([Int](), accumulator: { lapTimes, newTime in
				lapTimes + [newTime - lapTimes.reduce (0, +)]
			})
			.share(replay: 1)
		
		lapsValues
			.map { laps  -> [Lap] in
				laps.enumerated().map { index, value in
					Lap(
						id: (index + 1),
						time: value
					)
				}
			}
			.bind(to: store.rx.laps)
			.disposed(by: disposeBag)
		
		// MARK: - User Image
		
		store.value
			.map { $0.user?.imageUrl }
			.compactMap { $0 }
			.bind(to: self.rx.image)
			.disposed(by: disposeBag)
		
		// MARK: - Bind laps
		
		setupDataSource()
		
		store.value
			.map { $0.laps }
			.map { $0.map { SessionSectionItem(id: String($0.id), time: stringFromTimeInterval($0.time)) } }
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
			
			cell.timeLabel.text =  "\(item.id)" + ". " + item.time
			
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

func formatter(_ v: Double, from: String, format: String = ".1") -> String {
	let v1 = v, speedFormat = format
	let s = "\(v1.format(f: speedFormat))"

	return "\(from) \(s)"
}

extension Reactive where Base: SessionViewController {
	var image: Binder<(URL)> {
		Binder(base) { vc, url in
			vc.userImage.load(url: url)
		}
	}
}
