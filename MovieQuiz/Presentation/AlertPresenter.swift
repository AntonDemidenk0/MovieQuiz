import Foundation
import UIKit

/*class AlertPresenter {
    weak var viewController: MovieQuizViewController?
    weak var presenter: MovieQuizPresenter?
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }
    func show(quiz result: AlertModel, statisticService: StatisticService) {
        guard let viewController = viewController else {
            return
        }
        let correctAnswers = result.correctAnswers
        let totalQuestions = result.totalQuestions
        let gamesCount = statisticService.gamesCount
        let bestGame = statisticService.bestGame
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)
        
        let text = """
        Ваш результат: \(correctAnswers)/\(totalQuestions)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        let alert = UIAlertController(
            title: result.title,
            message: text,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "EndRoundAlert"
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
            self.presenter?.restartGame()
        }
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
*/
