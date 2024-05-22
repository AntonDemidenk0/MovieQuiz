import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IB Outlets
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private var currentQuestion: QuizQuestion?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        overrideUserInterfaceStyle = .dark
        stackView.isHidden = true
        showLoadingIndicator()
    }
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
                presenter.yesButtonClicked()
        buttonBlock(true)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
                presenter.noButtonClicked()
        buttonBlock(true)
    }
    // MARK: - Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        stackView.isHidden = false
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        buttonBlock(false)
    }
    func show(quiz result: QuizResultsViewModel) {
            let message = presenter.makeResultsMessage()

            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "EndRoundAlert"
                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }
            
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func buttonBlock(_ shouldBlock: Bool) {
        yesButton.isEnabled = !shouldBlock
        noButton.isEnabled = !shouldBlock
    }
   /* func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
            self.presenter.correctAnswers = self.presenter.correctAnswers
                    self.presenter.showNextQuestionOrResults()
        }
    }*/
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка", message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] _ in
            self?.presenter.restartGame()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


