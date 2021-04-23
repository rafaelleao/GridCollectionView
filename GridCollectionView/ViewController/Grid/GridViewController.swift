import UIKit
import Combine

class GridViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    private var viewModel: GridViewModel!
    private var bindings: [AnyCancellable] = []

    static func instantiate(with viewModel: GridViewModel) -> GridViewController {
        let storyboard = UIStoryboard(name: "GridViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! GridViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        let headerNib = UINib(nibName: "GridCollectionViewHeaderCell", bundle: nil)
        collectionView.register(headerNib, forCellWithReuseIdentifier: GridCollectionViewHeaderCell.identifier)

        let layout = GridCollectionViewLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isDirectionalLockEnabled = true
        setUpBindings()
    }

    private func setUpBindings() {
        viewModel.needsLayoutUpdate.sink {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }.store(in: &bindings)

        Publishers.keyboardShown.sink { [weak self] frame in
            self?.keyboardVisibilityChanged(visible: true, frame: frame)
        }.store(in: &bindings)
        Publishers.keyboardHidden.sink { [weak self] frame in
            self?.keyboardVisibilityChanged(visible: false, frame: frame)
        }.store(in: &bindings)
    }

    private func keyboardVisibilityChanged(visible: Bool, frame: CGRect) {
        if visible == false {
            collectionView.contentInset = .zero
        } else {
            let keyboardViewEndFrame = view.convert(frame, from: view.window)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.columns
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridCell = viewModel.matrix[indexPath.section, indexPath.row]
        let cellViewModel = GridCellViewModel(gridCell: gridCell)
        cellViewModel.parentViewModel = viewModel

        if cellViewModel.isHeader {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewHeaderCell.identifier, for: indexPath) as! GridCollectionViewHeaderCell
            cell.viewModel = cellViewModel
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as! GridCollectionViewCell
            cell.viewModel = cellViewModel
            return cell
        }
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gridCell = viewModel.matrix[indexPath.section, indexPath.row]
        viewModel.selectCell(cell: gridCell)
    }
}

extension GridViewController: GridCollectionViewLayoutDelegate {
    func numberOfColumns(in collectionView: UICollectionView) -> Int {
        return viewModel.columns
    }

    func numberOfRows(in collectionView: UICollectionView) -> Int {
        return viewModel.rows
    }

    func width(forColumn column: Int, in collectionView: UICollectionView) -> CGFloat {
        let width = viewModel.columnWidth[column]
        return width
    }

    func height(forRow row: Int, in collectionView: UICollectionView) -> CGFloat {
        let height = viewModel.rowHeight[row]
        return height
    }
}
