import XCTest
@testable import MarqueeText

final class MarqueeTextTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MarqueeText(font: UIFont.preferredFont(forTextStyle: .subheadline), leftFade: 16, rightFade: 16, startDelay: 3).text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
