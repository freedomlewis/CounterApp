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
                    )))

                    Button(action: {
                        viewStore.send(.lock(LockAction.setSheet(isPresented: true)))
                    }) {
                        Text("Show Lock View")
                    }.padding()
                }.font(Font.title2)
            }.sheet(
                isPresented: viewStore.binding(
                    get: \.isShowLockView,
                    send: { localState in
                        AppAction.lock(LockAction.setSheet(isPresented: localState))
                    }
                )
            ) {
                LockView(
                    store: self.store.scope(
                        state: { appState in appState.lock },
                        action: { localAction in AppAction.lock(localAction) }
                    )
                )
            }
        }
    }
}

extension AppView {
    struct ViewState: Equatable {
        var counter: String
        var isShowLockView: Bool
    }
}

extension AppState {
    var viewState: AppView.ViewState {
        .init(
            counter: "\(counter.count)",
            isShowLockView: lock.isPresent
        )
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: appStore)
    }
}
