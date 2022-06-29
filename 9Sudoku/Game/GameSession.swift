import GameplayKit

class GameSession {
    
    weak var delegate : GameSessionDelegate?
    
    private lazy var strategist : GKMinmaxStrategist = {
        let s = GKMinmaxStrategist()
        s.maxLookAheadDepth = 42;
        s.randomSource = GKARC4RandomSource()
        s.gameModel = self.model
        return s
    }()
    
    let model = GameModel()
    
    let userPlayer: Player
    
    let computerPlayer: Player
    
    let computerPlayerQueue = DispatchQueue(label: "computer AI",qos: .userInteractive)
    
    var disableComputerPlayer = false
 
    init() {
        userPlayer = model.allPlayers[0]
        computerPlayer  = model.allPlayers[1]
    }

    func start(computerMove:Bool) {
        guard model.currentPlayer == nil else {
            return
        }
        
        if computerMove {
            model.currentPlayer = computerPlayer
            calculateComputerMove()
        } else {
            model.currentPlayer = userPlayer
        }
    }
    
    
    @discardableResult
    func makeCurrentPlayerMove(location : GameBoardState.Location) -> Bool {
        guard let currentPlayer = model.currentPlayer else {
            return false
        }
        
        model.move(location: location)
        delegate?.gameSession(self, player: currentPlayer, didMoveTo: location)
        
        if model.isWin(for: userPlayer) {
            delegate?.gameSession(self, didWinForPlayer: userPlayer)
        } else if model.state.isTie() {
            delegate?.gameSessionDidTie(self)
        } else {
            if disableComputerPlayer {
                // switch players
                if currentPlayer == userPlayer {
                    model.currentPlayer = computerPlayer
                } else {
                    model.currentPlayer = userPlayer
                }
            } else {
                model.currentPlayer = computerPlayer
                DispatchQueue.main.async {
                    self.calculateComputerMove()
                }
            }
        }
        return true
    }
    
    func calculateComputerMove() {
        guard model.currentPlayer == computerPlayer else {
            return
        }
        
        let strategist = self.strategist
        let player = computerPlayer
        computerPlayerQueue.async {
            guard let move = strategist.bestMove(for: player) as? GameMove else { return }
            DispatchQueue.main.async {
                guard self.model.move(location: move.moveTo) else {
                    return
                }
                self.delegate?.gameSession(self, player: player, didMoveTo: move.moveTo)
                if self.model.isWin(for: player) {
                    // computer won
                    self.delegate?.gameSession(self, didWinForPlayer: player)
                } else if self.model.state.isTie() {
                    self.delegate?.gameSessionDidTie(self)
                } else {
                    self.model.currentPlayer = self.userPlayer
                }
            }
        }
    }
}

protocol GameSessionDelegate: AnyObject {
    
    func gameSession(_ session: GameSession, player: Player, didMoveTo location: GameBoardState.Location)
    
    func gameSession(_ session: GameSession, didWinForPlayer wonPlayer: Player)

    func gameSessionDidTie(_ session: GameSession)

}

