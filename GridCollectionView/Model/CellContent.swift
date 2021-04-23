import Foundation

class GridCell {
    let column, row: Int
    var text: String
    var selected = false

    init(column: Int, row: Int, text: String) {
        self.column = column
        self.row = row
        self.text = text
    }
}
