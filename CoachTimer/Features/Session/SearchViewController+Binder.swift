//
//  SearchViewController+Binder.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 30/05/21.
//

import Foundation

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture

extension Reactive where Base: Store<SessionState, SessionAction> {
	var owner: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(SessionAction.owner(value))
		}
	}
}
