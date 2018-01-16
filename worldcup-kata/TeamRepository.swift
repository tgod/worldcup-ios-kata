import Foundation

typealias TeamCallback = ([Team]) -> Void
typealias AddTeamResult = (Bool) -> (Void)

protocol TeamRepository {
    func getTeams(callback: @escaping TeamCallback)
    func addTeam(team: Team, callback: @escaping AddTeamResult)
}

struct Team : Codeble {
    let group : String
    let id : String
    let name : String
}

class TeamRemoteRepository : TeamRepository {
    
    let teamsEndpoint = "http://localhost:3000/teams"
    
    func addTeam(team: Team, callback: @escaping AddTeamResult) {
        guard let teamsEndpointUrl = URL(string: teamsEndpoint) else {
            print("uh oh that does not seem a URL")
            return
        }
        
        var urlRequest = URLRequest(url:teamsEndpointUrl)
        urlRequest.httpMethod = "POST" //strongly -> stringly typed API
        //TODO: put team object to http body
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                callback(false)
                return
            }
            let success = (200..<300 ~= statusCode)
            callback(success)
        }
        
        task.resume()
    }
    
    func getTeams(callback: @escaping TeamCallback) {
        
        guard let teamsEndpointUrl = URL(string: teamsEndpoint) else {
            print("uh oh that does not seem a URL")
            return
        }
        
        let urlRequest = URLRequest(url:teamsEndpointUrl)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print("completed")
            print(response ?? error ?? "")
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            guard let teams = try? decoder.decode([Team].self, from: data) else {
                print("uh oh, not valid for JSON parsing")
                return
            }
            
            teams.forEach{print($0)}
            
            callback(teams)
        }
        
        task.resume()
    }
    
    
}
