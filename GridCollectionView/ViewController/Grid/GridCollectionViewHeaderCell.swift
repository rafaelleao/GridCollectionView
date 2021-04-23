import UIKit

class GridCollectionViewHeaderCell: UICollectionViewCell {
    static let identifier = "GridCollectionViewHeaderCell"
    var viewModel: GridCellViewModel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var debugLabel: UILabel!
    @IBOutlet var horizontalGuide: [UIView]!
    @IBOutlet var verticalGuide: [UIView]!

    var height: CGFloat?
    var width: CGFloat?
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor

        textLabel.text = viewModel?.gridCell.text
        debugLabel.isHidden = !viewModel.debugEnabled
        if viewModel.debugEnabled {
            debugLabel.text = "(\(viewModel.gridCell.column):\(viewModel.gridCell.row)) \(self.frame.size.width)x\(self.frame.size.height)"
        }

        horizontalGuide.forEach { $0.backgroundColor = .white }
        verticalGuide.forEach { $0.backgroundColor = .white }

        setSelected(viewModel.gridCell.selected)
    }

    private func setSelected(_ selected: Bool) {
        backgroundColor = selected ? .systemGray : .systemGray5
        textLabel.textColor = selected ? .white : .label

        if selected {
            contentView.addGestureRecognizer(panGesture)
        } else {
            contentView.removeGestureRecognizer(panGesture)
        }

        if selected, let viewModel = viewModel {
            let enabledItems: [UIView] = viewModel.gridCell.row != 0 ? verticalGuide : horizontalGuide
            let disabledItems: [UIView] = viewModel.gridCell.row == 0 ? verticalGuide : horizontalGuide
            for view in enabledItems {
                view.isHidden = false
            }
            for view in disabledItems {
                view.isHidden = true
            }
        } else {
            for view in verticalGuide {
                view.isHidden = true
            }
            for view in horizontalGuide {
                view.isHidden = true
            }
        }
    }

    @objc
    private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }

        if gestureRecognizer.state == .began {
            width = view.frame.width
            height = view.frame.height
            return
        }

        if gestureRecognizer.state == .ended {
            return
        }

        let translation = gestureRecognizer.translation(in: contentView)
        let deltaX = width! + translation.x
        let deltaY = height! + translation.y
        viewModel.updateSize(CGSize(width: deltaX, height: deltaY))
    }
}
