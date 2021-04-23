import UIKit

protocol GridCollectionViewLayoutDelegate: UICollectionViewDelegate {
    func numberOfColumns(in collectionView: UICollectionView) -> Int
    func numberOfRows(in collectionView: UICollectionView) -> Int

    func width(forColumn column: Int, in collectionView: UICollectionView) -> CGFloat
    func height(forRow row: Int, in collectionView: UICollectionView) -> CGFloat
}

class GridCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: GridCollectionViewLayoutDelegate!
    private var layoutCache: LayoutCache = LayoutCache()

    private var numberOfColumns: Int {
        if let cached = layoutCache.numberOfColumnsCache {
            return cached
        }
        let columns = delegate.numberOfColumns(in: collectionView!)
        layoutCache.numberOfColumnsCache = columns
        return columns
    }

    private var numberOfRows: Int {
        if let cached = layoutCache.numberOfRowsCache {
            return cached
        }
        let rows = delegate.numberOfRows(in: collectionView!)
        layoutCache.numberOfRowsCache = rows
        return rows
    }

    override func prepare() {
        var offset = CGFloat(0)
        for column in 0 ..< numberOfColumns {
            let width = delegate.width(forColumn: column, in: collectionView!)
            layoutCache.columnWidth.append((width, offset))
            offset += width
        }

        offset = 0
        for row in 0 ..< numberOfRows {
            let height = delegate.height(forRow: row, in: collectionView!)
            layoutCache.rowHeight.append((height, offset))
            offset += height
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        layoutCache = LayoutCache()
    }

    override var collectionViewContentSize: CGSize {
        if let size = layoutCache.contentSizeCache {
            return size
        }

        var contentSize = CGSize.zero
        if let w = layoutCache.columnWidth.last {
            contentSize.width = w.width + w.offset
        }
        if let h = layoutCache.rowHeight.last {
            contentSize.height = h.height + h.offset
        }

        layoutCache.contentSizeCache = contentSize
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let width = layoutCache.columnWidth[indexPath.section]
        let height = layoutCache.rowHeight[indexPath.row]
        let itemSize = CGSize(width: width.width, height: height.height)

        let xOffset = layoutCache.columnWidth[indexPath.section].offset
        let yOffset = layoutCache.rowHeight[indexPath.row].offset

        var frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if indexPath.section == 0 && indexPath.row == 0 {
            frame.origin.y = collectionView!.contentOffset.y
            frame.origin.x = collectionView!.contentOffset.x
            attributes.zIndex = 2
        } else if indexPath.row == 0 {
            frame.origin.y = collectionView!.contentOffset.y
            attributes.zIndex = 1
        } else if indexPath.section == 0 {
            frame.origin.x = collectionView!.contentOffset.x
            attributes.zIndex = 1
        } else {
            attributes.zIndex = 0
        }

        attributes.frame = frame.integral
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let (rect, attributes) = layoutCache.layoutAttributesCache, rect == rect {
            return attributes
        }

        var attributes = [UICollectionViewLayoutAttributes]()
        for column in 0 ..< numberOfColumns {
            for row in 0 ..< numberOfRows {
                let attribute = layoutAttributesForItem(at: IndexPath(row: row, section: column))!
                attributes.append(attribute)
            }
        }

        layoutCache.layoutAttributesCache = (rect, attributes)
        return attributes
    }
}

private struct LayoutCache {
    var layoutAttributesCache: (CGRect, [UICollectionViewLayoutAttributes])?
    var contentSizeCache: CGSize?
    var numberOfRowsCache: Int?
    var numberOfColumnsCache: Int?
    var columnWidth: [(width: CGFloat, offset: CGFloat)] = []
    var rowHeight: [(height: CGFloat, offset: CGFloat)] = []
}
