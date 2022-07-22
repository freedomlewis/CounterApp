//
//  UserDetailView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/20.
//

import ComposableArchitecture
import SwiftUI

struct UserDetailView: View {
    let store: Store<UserDetailState, UserDetailAction>

    var body: some View {
        WithViewStore(self.store.scope(state: \.viewState, action: UserDetailAction.view)) { viewStore in
            VStack(alignment: .leading) {
                Button("Edit User Info") { viewStore.send(.setEditActive(true)) }.padding(.bottom, 10)

                UserInfoView(store: self.store.scope(state: \.userInfo, action: UserDetailAction.userInfoView))

                Spacer()
            }
            .padding(.leading)
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresent,
                    send: ViewAction.setEditActive
                )
            ) {
                IfLetStore(
                    self.store.scope(state: \.editUserState, action: UserDetailAction.edit),
                    then: EditUserView.init
                )
            }
        }
    }
}

extension UserDetailView {
    struct State: Equatable {
        var isPresent: Bool
    }

    enum ViewAction: Equatable {
        case setEditActive(Bool)
    }
}

extension UserDetailState {
    var viewState: UserDetailView.State {
        .init(isPresent: editUserState != nil)
    }
}

extension UserDetailAction {
    static func view(_ localAction: UserDetailView.ViewAction) -> UserDetailAction {
        switch localAction {
        case .setEditActive(true):
            return .activeEdit
        case .setEditActive(false):
            return .deActiveEdit
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(
            store: Store(
                initialState: UserDetailState(
                    userInfo: UserInfoState(user: User.dummy, disabled: true)
                ),
                reducer: userDetailReducer,
                environment: UserDetailEnvironment(userInfo: UserInfoEnvironment())
            )
        )
    }
}
