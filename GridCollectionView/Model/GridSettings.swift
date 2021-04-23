import Foundation
import CoreGraphics

protocol GridSettings {
    var rowHeaderWidth: CGFloat { get }
    var columns: Int { get }
    var rows: Int { get }
    var cellSize: CGSize { get }
    var minimumCellSize: CGSize { get }
    var defaultText: String { get }
}

struct DefaultGridSettings: GridSettings {
    let columns: Int = 30
    let rows: Int = 50
    let cellSize: CGSize = CGSize(width: 60, height: 25)
    let rowHeaderWidth: CGFloat = 35
    let minimumCellSize: CGSize = CGSize(width: 10, height: 10)
    let defaultText: String = ""
}

struct CustomGridSettings: GridSettings {
    let columns: Int
    let rows: Int
    let cellSize: CGSize
    let rowHeaderWidth: CGFloat = 35
    let minimumCellSize: CGSize = CGSize(width: 10, height: 10)
    let defaultText: String = ""
}
