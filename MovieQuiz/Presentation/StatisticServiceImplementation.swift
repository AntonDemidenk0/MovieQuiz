import Foundation

final class StatisticServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int) {
        let currentDate = Date()
        let newGameRecord = GameRecord(correct: count, total: amount, date: currentDate)
        let currentBestGame = bestGame
        if newGameRecord.correct > currentBestGame.correct {
            bestGame = newGameRecord
        }
        gamesCount += 1
        let totalCorrectAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(totalCorrectAnswers + count, forKey: Keys.total.rawValue)
    }
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let totalCorrectAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
            let totalGames = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            
            guard totalGames > 0 else {
                return 0.0
            }
            
            return Double(totalCorrectAnswers) / Double(totalGames * 10) * 100.0
        }
    }
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}
