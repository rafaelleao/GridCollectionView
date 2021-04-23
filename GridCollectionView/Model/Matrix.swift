import Foundation

struct Matrix<T> {
    let columns: Int, rows: Int
    private var grid: [T]

    init?(columns: Int, rows: Int, items: [T]) {
        if items.count != columns * rows || rows + columns == 1 {
            return nil
        }
        self.columns = columns
        self.rows = rows
        self.grid = items
    }

    func indexIsValid(column: Int, row: Int) -> Bool {
        return column >= 0 && column < columns && row >= 0 && row < rows
    }

    subscript(column: Int, row: Int) -> T {
        get {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            return grid[(column * rows) + row]
        }
        set {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            grid[(column * rows) + row] = newValue
        }
    }
}
