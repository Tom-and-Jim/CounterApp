//
//  EditCounter.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

let minEditCounterView = 0
let maxEditCounterView = 10

struct EditCounterView: View {
    let store: Store<CounterState, CounterAction>

    var body: some View {
        WithViewStore(store.scope(
            state: { counterState in counterState.editView },
            action: { (editCounterViewAction: EditCounterView.Action) in editCounterViewAction.feature })
        ) { viewStore in
            VStack {
                HStack {
                    Button("Dec") {
                        viewStore.send(.decrement)
                    }.padding()
                    Text("\(viewStore.count)")
                        .font(.title)
                        .padding()
                    Button("Inc") { viewStore.send(.increment)
                    }.padding()
                }
                HStack {
                    Text("Error Message:")
                        .font(.title)
                    Text("\(viewStore.errorMessage ?? "No errors")")
                        .foregroundColor(viewStore.errorMessage == nil ? .black : .red)
                }
            }
        }
    }
}

extension EditCounterView {
    struct State: Equatable {
        var count = 0
        var errorMessage: String?
    }

    enum Action: Equatable {
        case decrement
        case increment
    }
}

extension CounterState {
  var editView: EditCounterView.State {
    .init(count: self.count, errorMessage: self.errorMessage)
  }
}

extension EditCounterView.Action {
    var feature: CounterAction {
        switch self {
        case .decrement:
            return .decrement
        case .increment:
            return .increment
        }
    }
}


//struct EditCounter_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCounterView(store: appStore.scope(state: \RootState.counter, action: RootAction.counter))
//    }
//}
