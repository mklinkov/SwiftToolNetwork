import XCTest
@testable import SwiftToolNetwork

final class SwiftToolNetworkTests: XCTestCase {
    var newData: Data? = nil
    func testExample() throws {
        let network: NetworkServiceProtocol = NetworkService()
        let expectation = expectation(description: "testExample")

        /// this is a stupid test for a working example
        network.request(method: .get, host: "https://www.google.com/") { [weak self] result in
            switch result {
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            case .success(let data):
                print("success:\n\(data)")
                self?.newData = data
            }
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 20.0)

        XCTAssertTrue(newData != nil, "Data is empty")
    }
}
