@testable import GridCollectionView
import Quick
import Nimble

class SettingsViewModelSpec: QuickSpec {
    override func spec() {
        var sut = SettingsViewModel()

        describe("initialisation") {
            describe("initialisation with default settings") {
                it("copies configuration from DefaultGridSettings") {
                    let settings = DefaultGridSettings()

                    expect(settings.rows).to(equal(sut.rows))
                    expect(settings.columns).to(equal(sut.columns))
                    expect(settings.cellSize).to(equal(CGSize(width: sut.width, height: sut.height)))
                }
            }

            describe("initialisation with custom settings") {
                it("copies the values from the configuration object") {
                    let settings = CustomGridSettings(columns: 100, rows: 200, cellSize: CGSize(width: 10, height: 20))
                    let sut = SettingsViewModel(settings: settings)

                    expect(sut.rows).to(equal(200))
                    expect(sut.columns).to(equal(100))
                    expect(CGSize(width: sut.width, height: sut.height)).to(equal(CGSize(width: 10, height: 20)))
                }
            }
        }

        describe("gridSettings") {

            it("returns a settings object from the current configuration") {
                let settings = DefaultGridSettings()
                sut = SettingsViewModel(settings: settings)

                let output = sut.gridSettings()
                expect(settings.rows).to(equal(output.rows))
                expect(settings.columns).to(equal(output.columns))
                expect(settings.cellSize).to(equal(output.cellSize))
                expect(settings.minimumCellSize).to(equal(output.minimumCellSize))
            }
        }
    }
}
