import Foundation
import GameplayKit

class Player : NSObject  {
    
    let chip : GameBoardState.Cell
    
    init(chip : GameBoardState.Cell) {
        self.chip = chip
    }
    
    override var debugDescription: String {
        get {
            return "Chip: \(chip)"
        }
    }
}
