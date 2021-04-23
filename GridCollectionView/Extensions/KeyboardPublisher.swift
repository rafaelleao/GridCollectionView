import Combine
import CoreGraphics
import UIKit

extension Publishers {
    // Produces the keyboard frame every time it is displayed
    static var keyboardShown: AnyPublisher<CGRect, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .compactMap { $0.keyboardValue }
            .eraseToAnyPublisher()
    }

    // Produces the keyboard frame every time it is hidden
    static var keyboardHidden: AnyPublisher<CGRect, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .compactMap { $0.keyboardValue }
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardValue: CGRect? {
        return userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
}
