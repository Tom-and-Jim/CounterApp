//
//  LockView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/12.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

let minLockView = 0
let maxLockView = 9

struct LockView: View {
    let store: Store<LockState, LockAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Unlock:\(viewStore.unlock ? "Yes" : "No")")
                ForEachStore(
                    self.store.scope(state: \.digitals, action: LockAction.digitalView)
                ) {
                    EditCounterView(store: $0)
                }
            }
        }
    }
}

//struct LockView_Previews: PreviewProvider {
//    static var previews: some View {
//        LockView(store: appStore.scope(state: \.lock, action: RootAction.lock))
//    }
//}
