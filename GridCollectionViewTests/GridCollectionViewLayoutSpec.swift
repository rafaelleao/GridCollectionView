@testable import GridCollectionView
import Quick
import Nimble

class GridCollectionViewLayoutSpec: QuickSpec {
    override func spec() {
        var sut: GridCollectionViewLayout!
        var collectionView: UICollectionView!
        var delegate: TestDelegate!

        beforeEach {
            delegate = TestDelegate()
            delegate.columnWidth = [5.0, 12.0, 10.0]
            delegate.rowHeight = [15.0, 9.0]
            sut = GridCollectionViewLayout()
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: sut)
            _ = collectionView
            sut.delegate = delegate
            sut.prepare()
        }

        describe("contentSize") {
            it("calculates the size by summing up all value") {
                let contentSize = sut.collectionViewContentSize

                expect(contentSize.width).to(equal(27.0))
                expect(contentSize.height).to(equal(24.0))
            }
        }

        describe("layoutAttributesForItem") {
            it("calculates frame from cells") {
                let indexPath00 = IndexPath(row: 0, section: 0)
                let attributes = sut.layoutAttributesForItem(at: indexPath00)!
                expect(attributes.frame).to(equal(CGRect(x: 0, y: 0, width: 5, height: 15)))
            }

            it("calculates frame from cells") {
                let indexPath = IndexPath(row: 1, section: 0)
                let attributes = sut.layoutAttributesForItem(at: indexPath)!
                expect(attributes.frame).to(equal(CGRect(x: 0, y: 15, width: 5, height: 9)))
            }

            it("calculates frame from cells") {
                let indexPath = IndexPath(row: 1, section: 2)
                let attributes = sut.layoutAttributesForItem(at: indexPath)!
                expect(attributes.frame).to(equal(CGRect(x: 17, y: 15, width: 10, height: 9)))
            }
        }
    }
}

class TestDelegate: NSObject, GridCollectionViewLayoutDelegate {
    var columnWidth: [CGFloat] = []
    var rowHeight: [CGFloat] = []

    func numberOfColumns(in collectionView: UICollectionView) -> Int {
        return columnWidth.count
    }

    func numberOfRows(in collectionView: UICollectionView) -> Int {
        return rowHeight.count
    }

    func width(forColumn column: Int, in collectionView: UICollectionView) -> CGFloat {
        return columnWidth[column]
    }

    func height(forRow row: Int, in collectionView: UICollectionView) -> CGFloat {
        return rowHeight[row]
    }
}
