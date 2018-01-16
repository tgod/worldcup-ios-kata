import XCTest
@testable import worldcup_kata

class TeamRepositoryTest : XCTestCase {
    
    let subject = TeamRemoteRepository()
    
    func testShouldReturnListOfTeams() {
        let expectation = XCTestExpectation()
        
        subject.getTeams { teams in
            XCTAssertFalse(teams.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testShouldAddANewTeam() {
        let expectation = XCTestExpectation()
        let team = Team(group: "A", id: "PT", name: "Portugal")
        
        subject.addTeam(team: team) { (success) -> (Void) in
            XCTAssert(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
