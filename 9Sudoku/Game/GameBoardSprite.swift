import SpriteKit

class GameBoardSprite : SKSpriteNode {
    
    weak var delegate : GameBoardSpriteDelegate?
    
    var cells = Dictionary<GameBoardState.Location,SKSpriteNode>()
    
    func handlePress(at pressLocation: CGPoint) {
        guard let delegate = self.delegate else {
            return
        }
        let location = cellLocationFrom(nodePoint:pressLocation)
        delegate.gameBoardSprite(self, didPressAtLocation: location)
    }
    
    func cellLocationFrom(nodePoint: CGPoint) -> GameBoardState.Location {
        let size = self.size
        let anchorPoint = self.anchorPoint
        let cellSize = CGSize(width: size.width / CGFloat(GameBoardState.horizontalCount), height: size.height / CGFloat(GameBoardState.verticalCount))
        let column = Int(floor((nodePoint.x + size.width * anchorPoint.x) / cellSize.width))
        let row = Int(floor((nodePoint.y + size.height * anchorPoint.y) / cellSize.height))
        return GameBoardState.Location(column: column, row: row)
    }
    
    func nodePointFrom(cellLocation: GameBoardState.Location) -> CGPoint {
        let size = self.size
        let anchorPoint = self.anchorPoint
        let cellSize = CGSize(width: size.width / CGFloat(GameBoardState.horizontalCount), height: size.height / CGFloat(GameBoardState.verticalCount))
        let x = round(CGFloat(cellLocation.column) * cellSize.width - size.width * anchorPoint.x + cellSize.width / 2)
        let y = round(CGFloat(cellLocation.row) * cellSize.height - size.height * anchorPoint.y + cellSize.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    func setCellAt(location: GameBoardState.Location, value: GameBoardState.Cell) {
        if value == .empty {
            cells.removeValue(forKey: location)
            return
        }
        if let existingSprite = cells[location] {
            existingSprite.removeFromParent()
        }
        let cell = SKSpriteNode(imageNamed: value == .playerX ? "Player_X" : "Player_O")
        cell.position = nodePointFrom(cellLocation: location)
        cell.run(SKAction.sequence([
            SKAction.scale(to: 0.1, duration: 0),
            SKAction.scale(to: 1, duration: 0.1)
        ]))
        addChild(cell)
        cells[location] = cell
    }
    
    func reset() {
        for cell in cells.values {
            cell.removeFromParent()
        }
        cells.removeAll(keepingCapacity: true)
    }
}


#if os(iOS) || os(tvOS)
    extension GameBoardSprite {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let touch = touches.first!
            handlePress(at: touch.location(in: self))
        }
    }
#endif

protocol GameBoardSpriteDelegate : NSObjectProtocol {
    func gameBoardSprite(_ sprite: GameBoardSprite, didPressAtLocation: GameBoardState.Location)
}
