//
//  Leaderboard+Binder.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 22/06/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture

extension Reactive where Base: Store<LeaderboardState, LeaderboardAction> {
	var sort: Binder<(Sorting)> {
		Binder(self.base) { store, value in
			store.send(LeaderboardAction.sort(value))
		}
	}
	
	var export: Binder<Void> {
		Binder(self.base) { store, _ in
			store.send(LeaderboardAction.exportCSV)
		}
	}
}
