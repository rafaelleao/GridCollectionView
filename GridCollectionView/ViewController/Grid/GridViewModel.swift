import Foundation
import CoreGraphics
import Combine

class GridViewModel {
    let columns: Int
    let rows: Int
    private(set) var matrix: Matrix<GridCell>
    private(set) var columnWidth: [CGFloat] = []
    private(set) var rowHeight: [CGFloat] = []
    let minimumCellSize: CGSize
    let needsLayoutUpdate = PassthroughSubject<Void, Never>()
    private var selectedCell: GridCell?

    init(settings: GridSettings) {
        assert(settings.columns > 0 && settings.rows > 0)
        self.columns = settings.columns
        self.rows = settings.rows
        self.columnWidth = Array(repeating: settings.cellSize.width, count: columns)
        self.columnWidth[0] = settings.rowHeaderWidth
        self.rowHeight = Array(repeating: settings.cellSize.height, count: rows)
        self.minimumCellSize = settings.minimumCellSize
        var cells: [GridCell] = []
        for i in 0 ..< columns {
            for j in 0 ..< rows {
                var text = settings.defaultText
                if i == 0 && j > 0 {
                    text = "\(j)"
                }
                if j == 0 && i > 0 {
                    text = GridViewModel.character(fromIndex: i - 1).uppercased()
                }
                let cell = GridCell(column: i, row: j, text: text)
                cells.append(cell)
            }
        }
        self.matrix = Matrix(columns: columns, rows: rows, items: cells)!
    }

    func updateSize(_ size: CGSize, cell: GridCell) {
        if cell.row == 0 {
            let width = max(minimumCellSize.width, size.width)
            columnWidth[cell.column] = width
        }
        if cell.column == 0 {
            let height = max(minimumCellSize.height, size.height)
            rowHeight[cell.row] = height
        }
        needsLayoutUpdate.send()
    }

    func selectCell(cell: GridCell) {
        selectedCell?.selected = false
        if !(cell.column == 0 && cell.row == 0) && (cell.column == 0 || cell.row == 0) {
            selectedCell = cell
            selectedCell?.selected = true
        }
    }

    private static func character(fromIndex: Int) -> String {
        let aScalars = "a".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value

        var characters = [Character]()
        var val = fromIndex
        repeat {
            let x = val % 26
            if let scalar = UnicodeScalar(aCode + UInt32(x)) {
                characters.append(Character(scalar))
            }
            val /= 26
        } while val > 0

        return String(characters)
    }
}
