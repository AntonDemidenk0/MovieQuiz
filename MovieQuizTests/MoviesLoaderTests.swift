import Foundation
import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSucsessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            switch result {
            case .success( let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectedError = StubNetworkClient.TestError.test
        let expectation = expectation(description: "Handler invoked with error")
        loader.loadMovies { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure( let error):
                XCTAssertEqual(error as! StubNetworkClient.TestError, expectedError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
