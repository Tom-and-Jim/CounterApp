//
//  EditCounter.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct EditCounterView: View {
    
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.title)
                    .padding()
                HStack {
                    Text("Local:")
                        .font(.title)
                        .padding()
                    Button("−") {
                        viewStore.send(.decrementButtonTapped)
                    }.padding()
                    Button("+") { viewStore.send(.incrementButtonTapped)
                    }.padding()
                }
                HStack {
                    Text("Network:")
                        .font(.title)
                        .padding()
                    Button("−") {
                        viewStore.send(.decrementButtonTappedFetch(Config.COUNT_MIN))
                    }.padding()
                    Button("+") { viewStore.send(.incrementButtonTappedFetch(Config.COUNT_MAX))
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
        EditCounterView(store: APP_STORE)
    }
}
