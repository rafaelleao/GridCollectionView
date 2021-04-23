import CoreGraphics

class GridCellViewModel {
    let gridCell: GridCell
    weak var parentViewModel: GridViewModel?
    let debugEnabled = false
    var isHeader: Bool {
        gridCell.row == 0 || gridCell.column == 0
    }

    init(gridCell: GridCell) {
        self.gridCell = gridCell
    }

    func updateSize(_ size: CGSize) {
        parentViewModel?.updateSize(size, cell: gridCell)
    }
}
