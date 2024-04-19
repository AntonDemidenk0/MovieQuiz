import Foundation
import UIKit

class AlertPresenter {
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }
    func show(quiz result: AlertModel) {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
            viewController.resetQuestionsResult()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

