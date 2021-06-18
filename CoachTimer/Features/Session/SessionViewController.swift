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
	
	// MARK: Store
	
	public var store: Store<SessionState, SessionAction>?
	
	private let disposeBag = DisposeBag()
	
	public var closeClosure: (() -> Void)?
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let store = self.store else {
			return
		}
		
		// MARK: - User Image
		
		store.value
			.map { $0.user?.imageUrl }
			.subscribe(onNext: { [weak self] url in
				guard let self = self, let url = url else {
					return
				}
				
				// TODO: refactor this
				
				self.userImage.load(url: url)
			})
			.disposed(by: disposeBag)
	}
}
