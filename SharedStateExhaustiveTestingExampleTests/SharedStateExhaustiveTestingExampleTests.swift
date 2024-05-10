import ComposableArchitecture
@testable import SharedStateExhaustiveTestingExample
import XCTest

final class SharedStateExhaustiveTestingExampleTests: XCTestCase {
    
    @MainActor
    func testOnAppear() async {
        let store = TestStore(initialState: SomeReducer.State()) {
            SomeReducer()
        }
        
        await store.send(.onAppear)
        
        await store.receive(.action1) {
            $0.variable1 = "Updated by method 1"
            $0.variable2 = "Updated by method 2" // This should be mutated in action2
        }
        await store.receive(.action2)
    }
}
