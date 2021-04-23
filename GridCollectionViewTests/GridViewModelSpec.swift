@testable import GridCollectionView
import Quick
import Nimble

class GridViewModelSpec: QuickSpec {
    override func spec() {
        var settings: GridSettings!
        var sut: GridViewModel!

        describe("initialisation") {
            beforeEach {
                settings = CustomGridSettings(columns: 3, rows: 5, cellSize: CGSize(width: 50, height: 20))
                sut = GridViewModel(settings: settings)
            }

            it("initialises object with settings") {
                expect(sut.columns).to(equal(3))
                expect(sut.rows).to(equal(5))
                expect(sut.minimumCellSize).to(equal(settings.minimumCellSize))
                expect(sut.columnWidth.dropFirst().allSatisfy({ $0 == 50})).to(beTrue())
                expect(sut.rowHeight.allSatisfy({ $0 == 20})).to(beTrue())
                expect(sut.matrix.columns).to(equal(settings.columns))
                expect(sut.matrix.rows).to(equal(settings.rows))
            }
        }

        describe("updateSize") {
            beforeEach {
                settings = CustomGridSettings(columns: 2, rows: 3, cellSize: CGSize(width: 200, height: 300))
                sut = GridViewModel(settings: settings)
            }

            it("updates the selected column and row size") {
                let cell = sut.matrix[0, 0]
                sut.updateSize(CGSize(width: 220, height: 330), cell: cell)

                expect(sut.columnWidth[0]).to(beCloseTo(220.0))
                expect(sut.rowHeight[0]).to(beCloseTo(330.0))
            }

            it("doesn't affect other columns or rows") {
                let cell = sut.matrix[0, 0]
                sut.updateSize(CGSize(width: 220, height: 330), cell: cell)

                expect(sut.columnWidth[1]).to(beCloseTo(200.0))
                expect(sut.rowHeight[1]).to(beCloseTo(300.0))
                expect(sut.rowHeight[2]).to(beCloseTo(300.0))
            }

            it("respects the minimum size configuration") {
                let cell = sut.matrix[0, 0]
                sut.updateSize(CGSize(width: 0, height: 0), cell: cell)

                expect(sut.columnWidth[0]).to(beCloseTo(10.0))
                expect(sut.rowHeight[0]).to(beCloseTo(10.0))
            }
        }
    }
}
