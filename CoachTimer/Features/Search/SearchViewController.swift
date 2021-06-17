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

class SearchViewController: UIViewController {
	@IBOutlet var confirmButton: UIButton! {
		didSet {
			confirmButton.layer.cornerRadius = 5
			
			confirmButton.backgroundColor = UIColor.systemBlue
			confirmButton.setTitleColor(.white, for: .normal)
			
			confirmButton.setTitle(L10n.App.Search.Button.search, for: .normal)
		}
	}
	@IBOutlet var cancelButton: UIButton! {
		didSet {
			cancelButton.setTitle(L10n.App.Search.Button.cancel, for: .normal)
		}
	}
	
	@IBOutlet var ownerField: UITextField! {
		didSet {
			ownerField.placeholder = L10n.App.Search.owner
		}
	}
	@IBOutlet var repoField: UITextField! {
		didSet {
			repoField.placeholder = L10n.App.Search.repo
		}
	}
	
	// MARK: Store
	
	public var store: Store<SearchState, SearchAction>?
	
	private let disposeBag = DisposeBag()
	
	public var closeClosure: (() -> Void)?
	
	// MARK: - Life cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
				
		guard let store = self.store else {
			return
		}
		
		// MARK: - searchs 
			
		confirmButton.rx
			.tap
			.bind { [weak self] in
				if let close = self?.closeClosure {
					close()
				}
				
				self?.dismiss(animated: true, completion: nil)
			}.disposed(by: disposeBag)
		
		// MARK: - cancel
		
		cancelButton.rx
			.tap
			.bind { [weak self] in
				self?.dismiss(animated: true, completion: nil)
			}.disposed(by: disposeBag)
		
		// MARK: - owner
		
		store.value
			.map { $0.owner }
			.bind(to: self.ownerField.rx.text)
			.disposed(by: disposeBag)
		
		// MARK: - repo
		
		store.value
			.map { $0.repo }
			.bind(to: self.repoField.rx.text)
			.disposed(by: disposeBag)
		
		// MARK: - owner
		
		ownerField.rx
			.text
			.map { $0 ?? "" }
			.bind(to: store.rx.owner)
			.disposed(by: disposeBag)
		
		// MARK: - repo
		
		repoField.rx
			.text
			.map { $0 ?? "" }
			.bind(to: store.rx.repo)
			.disposed(by: disposeBag)
	}
}
