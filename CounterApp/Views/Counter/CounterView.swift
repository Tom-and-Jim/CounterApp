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
                NavigationLink("Edit", destination: EditCounterView(store: store))
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: appStore.scope(state: \AppState.counter, action: AppAction.counter))
    }
}
