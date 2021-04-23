import Combine
import CoreGraphics

class SettingsViewModel {
    @Published var columns: Int
    @Published var rows: Int
    @Published var width: Int
    @Published var height: Int
    let minItems = 1
    let maxItems = 1000
    let minSize: CGSize
    let step = 10.0

    init(settings: GridSettings = DefaultGridSettings()) {
        columns = settings.columns
        rows = settings.rows
        width = Int(settings.cellSize.width)
        height = Int(settings.cellSize.height)
        minSize = settings.minimumCellSize
    }

    func gridSettings() -> GridSettings {
        let size = CGSize(width: width, height: height)
        return CustomGridSettings(columns: columns, rows: rows, cellSize: size)
    }
}
