//
//  AppView.swift
//  CounterApp
//
//  Created by QinChao Xu on 2022/7/8.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct CounterState: Equatable {
    var count = 0
    var errorMessage: String?
}

enum CounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
    case decrementButtonTappedFetch(Int)
    case incrementButtonTappedFetch(Int)
    case numberChangeResponse(Result<Int, ApiError>)
}

struct CounterView: View {
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(store.scope(state: \.view)) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.count)")
                        .font(.title)
                        .padding()
                    NavigationLink("Edit", destination: EditCounterView(store: store))
                }
            }
        }
    }
}

extension CounterView {
    struct State: Equatable {
        var count = 0
    }
}

extension CounterState {
  var view: CounterView.State {
    .init(count: self.count)
  }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: APP_STORE.scope(state: \.counter, action: AppAction.counter))
    }
}
