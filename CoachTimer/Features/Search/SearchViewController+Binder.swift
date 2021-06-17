//
//  SearchViewController+Binder.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 30/05/21.
//

import Foundation

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture

extension Reactive where Base: Store<SearchState, SearchAction> {
	var owner: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(SearchAction.owner(value))
		}
	}
	
	var repo: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(SearchAction.repo(value))
		}
	}
}
