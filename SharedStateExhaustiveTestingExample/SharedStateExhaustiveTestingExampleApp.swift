import SwiftUI
import ComposableArchitecture

@main
struct SharedStateExhaustiveTestingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: SomeReducer.State()){
                SomeReducer()
            })
        }
    }
}
