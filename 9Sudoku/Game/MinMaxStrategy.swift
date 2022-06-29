import GameplayKit

extension Player : GKGameModelPlayer {
    var playerId : Int {
        get {
            return chip.rawValue
        }
    }
}

extension GameModel : GKGameModel {

    public func apply(_ gameModelUpdate: GKGameModelUpdate) {
        let update = gameModelUpdate as! GameMove
        move(location:update.moveTo)
    }
    
    public func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard currentPlayer != nil else {
            return nil
        }
        let locations = state.availableLocations()
        guard locations.count > 0 else {
            return nil
        }
        return locations.map({
            return GameMove(moveTo: $0)
        })
    }
    
    public func setGameModel(_ gameModel: GKGameModel) {
        let other = gameModel as! GameModel
        currentPlayer = other.currentPlayer
        state = other.state
    }
    
    public var activePlayer: GKGameModelPlayer? {
        set {
            currentPlayer = newValue as! Player?
        }
        get {
            return currentPlayer
        }
    }
    
    public var players: [GKGameModelPlayer]? {
        get {
            return allPlayers
        }
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        let player = player as! Player
        return state.scoreFor(playerCell: player.chip)
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let player = player as! Player
        return state.isWin(playerCell: player.chip)
    }
    
}

class GameMove : NSObject, GKGameModelUpdate {
    
    public var value = 0
    
    let moveTo : GameBoardState.Location

    init(moveTo: GameBoardState.Location) {
        self.moveTo = moveTo
    }
}

