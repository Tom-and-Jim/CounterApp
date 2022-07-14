//
//  LockView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/12.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

let rightSecurityCode = [2, 5, 7]
let minLockView = 0
let maxLockView = 9

struct LockView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store.scope(state: { appState in appState.lock})) { viewStore in
            VStack {
                Text("Unlock:\(lock(viewStore.state) ? "Yes" : "No")")
                ForEachStore(
                    self.store.scope(state: \.lock, action: AppAction.lock(id:action:))
                ) { lockNumberStore in
                    WithViewStore(lockNumberStore) { lockNumberViewStore in
                        HStack {
                            Button("-") {
                                lockNumberViewStore.send(.decrementButtonTappedFetch(minLockView))
                            }.padding()
                            Text("\(lockNumberViewStore.count)")
                                .font(.title)
                                .padding()
                            Button("+") { lockNumberViewStore.send(.incrementButtonTappedFetch(maxLockView))
                            }.padding()
                        }
                    }
                }
            }
        }
    }
    
    func lock(_ state: IdentifiedArrayOf<CounterState>) -> Bool {
        state.map { $0.count } == rightSecurityCode
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(store: appStore)
    }
}
