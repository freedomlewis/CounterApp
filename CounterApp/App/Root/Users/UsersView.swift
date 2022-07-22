//
//  UsersView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/20.
//

import ComposableArchitecture
import IdentifiedCollections
import SwiftUI

struct UsersView: View {
    let store: Store<UsersState, UsersAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.view, action: UsersAction.view)) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewStore.users) { user in
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(state: \.selection?.value, action: UsersAction.detail),
                                then: UserDetailView.init
                            ),
                            tag: user.id,
                            selection: viewStore.binding(get: \.selectId, send: ViewAction.setEditActive)
                        ) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(user.fullName)").font(.title2)
                                Text("\(user.email)").foregroundColor(.gray)
                            }.padding(.leading)
                        }
                        
                        Divider()
                    }
                    
                    Spacer()
                }
                .onAppear { viewStore.send(.onAppear) }
                .onDisappear { viewStore.send(.onDisappear)}
            }
        }
    }
}

extension UsersView {
    struct ViewState: Equatable {
        var users: [User]
        var selectId: UUID?
    }
    
    enum ViewAction: Equatable {
        case setEditActive(selectedId: UUID?)
        case onAppear
        case onDisappear
    }
}

extension UsersState {
    var view: UsersView.ViewState {
        .init(users: self.users.elements, selectId: selection?.id)
    }
}

extension UsersAction {
    static func view(_ localAction: UsersView.ViewAction) -> UsersAction {
        switch localAction {
        case let .setEditActive(id):
            return .setNavigation(selection: id)
        case .onAppear:
            return .onAppear
        case .onDisappear:
            return .onDisappear
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(
            store: Store(
                initialState: UsersState(userNum: 5),
                reducer: usersReducer,
                environment: UsersEnvironment(
                    randomFirstName: { .none }
                )
            )
        )
    }
}
