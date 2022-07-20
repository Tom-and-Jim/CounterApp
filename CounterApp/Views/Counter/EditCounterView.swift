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
                        viewStore.send(.decrementButtonTappedFetch(minEditCounterView))
                    }.padding()
                    Text("\(viewStore.count)")
                        .font(.title)
                        .padding()
                    Button("Inc") { viewStore.send(.incrementButtonTappedFetch(maxEditCounterView))
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

struct EditCounter_Previews: PreviewProvider {
    static var previews: some View {
        EditCounterView(store: appStore.scope(state: \AppState.counter, action: AppAction.counter))
    }
}
