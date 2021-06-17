//
//  StargazersListViewController+Binder.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 30/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SceneBuilder

extension Reactive where Base: Store<UsersViewState, UsersViewAction> {
	var fetch: Binder<(Bool)> {
		Binder(self.base) { store, value in
			store.send(UsersViewAction.user(UsersAction.fetch))
		}
	}
//	
//	var repo: Binder<(String)> {
//		Binder(self.base) { store, value in
//			store.send(StargazerViewAction.stargazer(UsersAction.repo(value)))
//		}
//	}
}
