//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Anton Demidenko on 16.5.24..
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testEndRoundAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        let alert = app.alerts["EndRoundAlert"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
        alert.buttons.firstMatch.tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}