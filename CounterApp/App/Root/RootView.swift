//
//  RootView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.view, action: RootAction.view)) { viewStore in
            VStack {
                Text("\(viewStore.counter)")
                
                NavigationLink(
                    "Goto edit page",
                    isActive: viewStore.binding(get: \.counterDetailActive, send: ViewAction.setCounterDetailActive),
                    destination: {
                        IfLetStore(
                            self.store.scope(state: \.counter, action: RootAction.counter),
                            then: CounterView.init
                        )
                    }
                )
                .padding()
                
                Button("Show Lock View") { viewStore.send(.setLockActive(true)) }
                
                NavigationLink(
                    "Goto users page",
                    isActive: viewStore.binding(get: \.usersActive, send: ViewAction.setUsersActive),
                    destination: {
                        IfLetStore(
                            self.store.scope(state: \.users, action: RootAction.users),
                            then: UsersView.init
                        )
                    }
                )
                .padding()
            }
            .font(Font.title2)
            .sheet(
                isPresented: viewStore.binding(get: \.lockActive, send: ViewAction.setLockActive)
            ) {
                IfLetStore(
                    self.store.scope(state: \.lock, action: RootAction.lock),
                    then: LockView.init
                )
            }
        }
    }
}

extension RootView {
    struct ViewState: Equatable {
        let counter: String
        let counterDetailActive: Bool
        let lockActive: Bool
        let usersActive: Bool
    }
    
    enum ViewAction: Equatable {
        case setCounterDetailActive(Bool)
        case setLockActive(Bool)
        case setUsersActive(Bool)
    }
}

extension RootState {
    var view: RootView.ViewState {
        .init(
            counter: "\(counter?.count ?? 0)",
            counterDetailActive: counter != nil,
            lockActive: lock != nil,
            usersActive: users != nil
        )
    }
}

extension RootAction {
    static func view(_ localAction: RootView.ViewAction) -> RootAction {
        switch localAction {
        case .setCounterDetailActive(true):
            return .activeCounterDetail
            
        case .setCounterDetailActive(false):
            return .resetCounterDetail
            
        case .setLockActive(true):
            return .activeLock
            
        case .setLockActive(false):
            return .resetLock
            
        case .setUsersActive(true):
            return .activeUsers
            
        case .setUsersActive(false):
            return .resetUsers
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(
            initialState: RootState(
                counter: .init(),
                lock: .init(code: [9, 5, 7]),
                users: .init(userNum: 5)
            ),
            reducer: rootReducer,
            environment: .init(
                counterEnv: .init(
                    queue: DispatchQueue.main.eraseToAnyScheduler(),
                    increment: CounterClient.Interface.live.increment,
                    decrement: CounterClient.Interface.live.decrement
                ),
                firstNameGenerator: RandomGenerator.Interface.live.generateFirstName
            )
        ))
    }
}
