//
//  AppView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct CounterView: View {
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(store.scope(state: { counterState in counterState.view })) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.title)
                    .padding()
                NavigationLink(
                    "Edit",
                    isActive: viewStore.binding(
                        get: \.editCounterActive,
                        send: CounterAction.setEditCounter
                    ),
                    destination: {
                        EditCounterView(store: store)
                    }
                )
            }
        }
    }
}

extension CounterView {
    struct State: Equatable {
        var count = 0
        var editCounterActive = false
    }
}

extension CounterState {
  var view: CounterView.State {
    .init(
        count: self.count,
        editCounterActive: self.editCounterActive
    )
  }
}

//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView(store: appStore.scope(state: \AppState.root.counter, action: AppAction.rootView(RootAction)))
//    }
//}
