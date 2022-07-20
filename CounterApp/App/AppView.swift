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
                        viewStore.send(.setLockSheet(isPresented: true))
                    }
                    
                    NavigationLink(
                        "Goto users page",
                        destination: UsersView(
                            store: Store(
                            initialState: UsersState(),
                            reducer: usersReducer,
                            environment: UsersEnvironment()
                            )
                        )
                    )
                    .padding()
                }
                .font(Font.title2)
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isShowLockView,
                    send: AppAction.setLockSheet(isPresented:)
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
        let counter: String
        let isShowLockView: Bool
    }
}

extension AppState {
    var viewState: AppView.ViewState {
        .init(
            counter: "\(counter.count)",
            isShowLockView: isPresentLock
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
