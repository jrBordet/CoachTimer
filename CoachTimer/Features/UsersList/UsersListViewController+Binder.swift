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

extension Reactive where Base: Store<UsersSessionsViewState, UsersSessionsViewAction> {
	var fetch: Binder<(Bool)> {
		Binder(self.base) { store, value in
			store.send(UsersSessionsViewAction.user(UsersAction.fetch))
		}
	}
	
	var user: Binder<(User)> {
		Binder(self.base) { store, value in
			store.send(UsersSessionsViewAction.user(UsersAction.selectUser(value)))
		}
	}
}
