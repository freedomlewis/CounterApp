//
//  AppView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/7.
//

import ComposableArchitecture
import StoreKit
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store.scope(state: \.viewState)) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.counter)").font(Font.title2).padding()
                    NavigationLink("Goto edit page", destination: CounterView(store: self.store.scope(
                        state: { appState in appState.counter },
                        action: { localAction in AppAction.counter(localAction) }
                    ))).font(Font.title2)
                }
            }
        }
    }
}

extension AppView {
    struct ViewState: Equatable {
        var counter: String
    }
}

extension AppState {
    var viewState: AppView.ViewState {
        .init(counter: "\(counter.count)")
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: appStore)
    }
}
