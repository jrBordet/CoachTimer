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
	var distance: Binder<(Int?)> {
		Binder(self.base) { store, value in
			store.send(SessionAction.distance(value))
		}
	}
	
	var lap: Binder<(Lap)> {
		Binder(self.base) { store, value in
			store.send(SessionAction.lap(value))
		}
	}
	
	var laps: Binder<([Lap])> {
		Binder(self.base) { store, value in
			store.send(SessionAction.laps(value))
		}
	}
}
