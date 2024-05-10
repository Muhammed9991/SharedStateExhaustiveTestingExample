import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<SomeReducer>

    var body: some View {
        VStack {
            
            Button {
                self.store.send(.onButtonTapped)
            } label: {
                Text("Toggle Button")
            }
            
            ChildView(isOn: self.$store.isOn)
            Text("Variable 1: \(self.store.variable1)")
            Text("Variable 2: \(self.store.variable2)")
        }
        .onAppear {
            self.store.send(.onAppear)
        }
    }
}

struct ChildView: View {
    @Binding var isOn: Bool

    var body: some View {
        Text("The toggle is \(isOn ? "On" : "Off")")
    }
}

@Reducer
struct SomeReducer {
    @ObservableState
    struct State: Equatable, Sendable {
        var isOn = false
        var variable1: String = ""
        @Shared(.inMemory("variable2")) var variable2: String = ""
    }

    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case action1
        case action2
        case onButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.action1)
                    await send(.action2)
                }
            case .action1:
                state.variable1 = "Updated by method 1"
                return .none
            case .action2:
                state.variable2 = "Updated by method 2"
                return .none
                
            case .onButtonTapped:
                state.isOn.toggle()
                return .none
            case .binding:
                return .none
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: SomeReducer.State()){
        SomeReducer()
    })
}
