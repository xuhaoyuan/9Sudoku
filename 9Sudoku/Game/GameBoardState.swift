import Foundation

struct GameBoardState {
    enum Cell : Int {
        case empty
        case playerX
        case playerO
    }
    
    struct Location : Hashable {
        var row = 0
        var column = 0
        
        init(column: Int, row: Int) {
            self.row = row
            self.column = column
        }
        
        public static func ==(lhs: Location, rhs: Location) -> Bool {
            return lhs.row == rhs.row && lhs.column == rhs.column
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(row << 1 ^ column)
        }
    }
    
    static let horizontalCount = 3
    static let verticalCount = 3
    
    /**
     Cells in (column,row) order (x.y)
     */
    private var cells = Array(repeating: Array(repeating: Cell.empty,count: horizontalCount), count: verticalCount)

    subscript(index: Location) -> Cell {
        get {
            return cells[index.column][index.row]
        }
        set {
            cells[index.column][index.row] = newValue
        }
    }
    
    func isWin(playerCell: Cell) -> Bool {
        guard playerCell != .empty else {
            return false
        }

        // check column wins
        for i in 0..<GameBoardState.horizontalCount {
            if self[Location(column:i,row:0)] == playerCell {
                var foundOther = false
                for j in 1..<GameBoardState.verticalCount {
                    if self[Location(column:i,row:j)] != playerCell {
                        foundOther = true
                        break
                    }
                }
                if !foundOther {
                    return true
                }
            }
        }

        // check row wins
        for j in 0..<GameBoardState.horizontalCount {
            if self[Location(column:0,row:j)] == playerCell {
                var foundOther = false
                for i in 1..<GameBoardState.verticalCount {
                    if self[Location(column:i,row:j)] != playerCell {
                        foundOther = true
                        break
                    }
                }
                if !foundOther {
                    return true
                }
            }
        }
        
        // check primary diagonal win
        if self[Location(column:0,row:0)] == playerCell {
            var foundOther = false
            for k in 1..<GameBoardState.horizontalCount {
                if self[Location(column:k,row:k)] != playerCell {
                    foundOther = true
                    break
                }
            }
            if !foundOther {
                return true
            }
        }
        
        // check secondary diagonal win
        if self[Location(column:0,row:GameBoardState.verticalCount-1)] == playerCell {
            var foundOther = false
            for k in 1..<GameBoardState.horizontalCount {
                if self[Location(column:k,row:GameBoardState.verticalCount-1-k)] != playerCell {
                    foundOther = true
                    break
                }
            }
            if !foundOther {
                return true
            }
        }

        return false
    }
    
    func scoreFor(playerCell: Cell) -> Int {
        guard playerCell != .empty else {
            return 0
        }

        var totalScore = 0
        for i in 0..<GameBoardState.horizontalCount {
            for j in 0..<GameBoardState.verticalCount {
                if self[Location(column:i,row:j)] == playerCell {
                    totalScore += 1
                }
            }
        }
        return totalScore
    }

    func availableLocations() -> [Location] {
        var locations = [Location]()
        locations.reserveCapacity(GameBoardState.horizontalCount * GameBoardState.verticalCount)
        for i in 0..<GameBoardState.horizontalCount {
            for j in 0..<GameBoardState.verticalCount {
                let curLocation = Location(column:i,row:j)
                if self[curLocation] == .empty {
                    locations.append(curLocation)
                }
            }
        }
        return locations
    }
    
    func isTie() -> Bool {
        for i in 0..<GameBoardState.horizontalCount {
            for j in 0..<GameBoardState.verticalCount {
                let curLocation = Location(column:i,row:j)
                if self[curLocation] == .empty {
                    return false
                }
            }
        }
        return true
    }
}
