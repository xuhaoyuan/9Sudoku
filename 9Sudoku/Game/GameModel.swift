import GameplayKit

class GameModel : NSObject, NSCopying {

    let allPlayers = [
        Player(chip: .playerX),
        Player(chip: .playerO),
    ]
    
    var currentPlayer : Player?
    
    var state = GameBoardState()
    
    required override init() {
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let c = type(of: self).init()
        c.state = self.state
        c.activePlayer = activePlayer
        return c
    }
    
    func canMove(location: GameBoardState.Location) -> Bool {
        return state[location] == .empty
    }
    
    @discardableResult
    func move(location: GameBoardState.Location) -> Bool {
        guard canMove(location: location) else {
            return false
        }
        
        guard let player = currentPlayer else {
            return false
        }
        
        state[location] = player.chip
        return true
    }
}
