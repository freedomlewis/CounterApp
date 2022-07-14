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
                    Text("\(viewStore.counter)")

                    NavigationLink(
                        "Goto edit page",
                        destination: CounterView(
                            store: self.store.scope(
                                state: { appState in appState.counter },
                                action: { localAction in AppAction.counter(localAction) }
                            )
                        )
                    )
                    .padding()

                    Button("Show Lock View") {
                        viewStore.send(.lock(LockAction.setSheet(isPresented: true)))
                    }
                }
                .font(Font.title2)
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isShowLockView,
                    send: { AppAction.lock(.setSheet(isPresented: $0)) }
                )
            ) {
                LockView(
                    store: self.store.scope(
                        state: \.lock,
                        action: AppAction.lock
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
        AppView(store: Store(
            initialState: AppState(
                counter: CounterState(),
                lock: LockState(
                    counters: [CounterState(), CounterState(), CounterState()]
                )
            ),
            reducer: appReducer,
            environment: AppEnviroment()
        ))
    }
}
