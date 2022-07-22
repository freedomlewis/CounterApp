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
        WithViewStore(self.store) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewStore.users) { user in
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(
                                    state: \.selection?.value,
                                    action: UsersAction.detail
                                )
                            ) {
                                UserDetailView(store: $0)
                            } else: {
                                ProgressView()
                            },
                            tag: user.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: UsersAction.setNavigation(selection:)
                            )
                        ) {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("\(user.fullName)").font(.title2)
                                }
                                HStack {
                                    Text("\(user.email)").foregroundColor(.gray)
                                }
                            }.padding(.leading)
                        }
                        
                        Divider()
                    }
                    
                    Spacer()
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .onDisappear {
                    viewStore.send(.onDisappear)
                }
            }
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
