//
//  ProfileViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import CoreLocation

class ProfileViewModel: ProfileViewModelType {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: ProfileViewModelCoordinatorDelegate?
    weak var viewDelegate: ProfileViewModelViewDelegate?
    
    // MARK: - Dependencies
    private let episodeService: EpisodeService
    private let userService: UserService
//    private var user: PanicMechanicUser? {
//        didSet {
//            if let user = user {
//                dataSource += createDataSource(from: user)
//            }
//        }
//    }
    
    // MARK: - Properties
//    private var episodes: [PanicMechanicEpisode] = [] {
//        didSet {
//            dataSource += createDataSource(from: episodes)
//        }
//    }
    private var dataSource: [TableViewSectionMap] = [] {
        didSet {
            viewDelegate?.updateDataSource(ds: dataSource)
        }
    }
    
    init(episodeService: EpisodeService, userService: UserService) {
        self.episodeService = episodeService
        self.userService = userService
    }
    
    func start() {
        loadUser()
    }
    
    func loadEpisodes(userDatasource: [TableViewSectionMap]) {
        episodeService.loadEpisodes { episodes, error in
            if let error = error {
                print("error getting episodes: \(error.localizedDescription)")
            } else {
                if let episodes = episodes {
//                    self.episodes = episodes
                    let epds = self.createDataSource(from: episodes)
                    self.dataSource = userDatasource + epds
                } else {
                    print("error getting episodes after retrieval")
                }
            }
        }
    }
    
    func loadUser() {
        userService.loadUser { user, error in
            if let error = error {
                print("error getting user: \(error.localizedDescription)")
            } else {
                if let user = user {
//                    self.user = user
                    let uds = self.createDataSource(from: user)
                    self.loadEpisodes(userDatasource: uds)
                } else {
                    print("error getting user after retrieval")
                }
            }
        }
    }
    
    private func getCoordinates(episodes: [PanicMechanicEpisode]) -> [(Date, CLLocationCoordinate2D)] {
        var coordinates: [(Date, CLLocationCoordinate2D)] = []
        for episode in episodes {
            if let location = episode.location {
                let coordinate = (episode.startTs, CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                coordinates.append(coordinate)
            }
        }
        return coordinates
    }
    
    private func getHRs(episodes: [PanicMechanicEpisode]) -> [[(Int, Int)]] {
        var hrs: [[(Int, Int)]] = []
        for episode in episodes {
            var cycleHr: [(Int, Int)] = []
            for (idx, cycle) in episode.cycles.enumerated() {
                if let hr = cycle.hr {
                    cycleHr.append((idx, hr.bpm))
                }
            }
            hrs.append(cycleHr)
        }
        return hrs
    }
    
    private func getAnxietys(episodes: [PanicMechanicEpisode]) -> [[(Int, Int)]] {
        var anxietys: [[(Int, Int)]] = []
        for episode in episodes {
            var cycleAnxiety: [(Int, Int)] = []
            for (idx, cycle) in episode.cycles.enumerated() {
                if let anxiety = cycle.anxiety {
                    cycleAnxiety.append((idx, anxiety.rating))
                }
            }
            anxietys.append(cycleAnxiety)
        }
        return anxietys
    }
    
    private func getTriggerCounts(episodes: [PanicMechanicEpisode]) -> [String: Int] {
        var triggerCounts: [String: Int] = [:]
        for episode in episodes {
            for cycle in episode.cycles {
                if let question = cycle.question, question.name == "TRIGGER" {
                    if let exists = triggerCounts[question.answer] {
                        let v = exists + 1
                        triggerCounts[question.answer] = v
                    } else {
                        triggerCounts[question.answer] = 1
                    }
                }
            }
        }
        return triggerCounts
    }
    
    private func getQualityAverage(episodes: [PanicMechanicEpisode], name: String) -> Int {
        var count = 0
        var total = 0
        let questions = episodes.map { $0.cycles }.flatMap { $0 }.map { $0.question }
        for question in questions {
            if let question = question, question.name == name, let rating = Int(question.answer) {
                count += 1
                total += rating
            }
        }
        guard count > 0 else { return 0 }
        return Int(Float(total)/Float(count))
    }
    
    private func mapQuestionValues(value: Int, question: SurveyQuestion) -> String? {
        let options1 = ["A Lot Worse", "Slightly Worse", "Typical", "Slightly Better", "A Lot Better"]
        let options2 = ["A Lot Less", "Slightly Less", "Typical", "Slightly More", "A Lot More"]
        let options3 = ["A Lot More", "Slightly More", "Typical", "Slightly Less", "A Lot Less"]
        
        switch question {
        case .trigger, .none:
            return nil
        case .sleep, .diet, .stress:
            return options1[value - 1]
        case .exercise:
            return options2[value - 1]
        case .substances:
            return options3[value - 1]
        }
    }
    
    private func getQuestionValueSet(question: SurveyQuestion) -> [String] {
        let options1 = ["A Lot Worse", "Slightly Worse", "Typical", "Slightly Better", "A Lot Better"]
        let options2 = ["A Lot Less", "Slightly Less", "Typical", "Slightly More", "A Lot More"]
        let options3 = ["A Lot More", "Slightly More", "Typical", "Slightly Less", "A Lot Less"]
        
        switch question {
        case .trigger, .none:
            return []
        case .sleep, .diet, .stress:
            return options1
        case .exercise:
            return options2
        case .substances:
            return options3
        }
    }
    
    private func createDataSource(from user: PanicMechanicUser) -> [TableViewSectionMap]  {
        let avatarCell = ProfileAvatarCell(user: user)
        return [TableViewSectionMap(section: nil, items: [avatarCell], footer: nil)]
    }
    
    private func createDataSource(from episodes: [PanicMechanicEpisode]) -> [TableViewSectionMap]  {
        guard episodes.count > 0 else { return [] }
        
        let now = Date()
        let twoWeeksBefore = Calendar.current.date(byAdding: .day, value: -14, to: now)!
        let twelveMonthsBefore = Calendar.current.date(byAdding: .month, value: -12, to: now)!        
        let ep2Weeks = episodes.filter { $0.startTs >= twoWeeksBefore && $0.startTs <= now}
        let ep12Months = episodes.filter { $0.startTs >= twelveMonthsBefore && $0.startTs <= now}
        let coordinates = getCoordinates(episodes: episodes)
        
        var hrs: [[(Int, Int)]]
        var anxietys: [[(Int, Int)]]
        if let first = episodes.first, let last = episodes.last {
            hrs = getHRs(episodes: [first, last])
            anxietys = getAnxietys(episodes: [first, last])
        } else {
            hrs = []
            anxietys = []
        }
        let triggerCounts: [String: Int] = getTriggerCounts(episodes: episodes)
        var triggers: [(Int, Int)] = []
        var triggerLabels: [String] = []
        triggerCounts.enumerated().forEach { item in
            triggers.append((item.0, item.1.1))
            triggerLabels.append(item.1.0)
        }
        
        let sleepAverage = getQualityAverage(episodes: episodes, name: "SLEEP")
        let stressAverage = getQualityAverage(episodes: episodes, name: "STRESS")
        let dietAverage = getQualityAverage(episodes: episodes, name: "DIET")
        let exerciseAverage = getQualityAverage(episodes: episodes, name: "EXERCISE")
        let substanceAverage = getQualityAverage(episodes: episodes, name: "SUBSTANCES")
        
        
        
        var qualityCells: [TableViewItemViewModel] = []
        if sleepAverage > 0 {
            let sleepCell = SliderCell(title: "Sleep Quality", value: Float(sleepAverage), options: getQuestionValueSet(question: .sleep))
            qualityCells.append(sleepCell)
        }
        if stressAverage > 0 {
            let stressCell = SliderCell(title: "Stress Level", value: Float(stressAverage), options: getQuestionValueSet(question: .stress))
            qualityCells.append(stressCell)
        }
        if dietAverage > 0 {
            let dietCell = SliderCell(title: "Eating Habits", value: Float(dietAverage), options: getQuestionValueSet(question: .diet))
            qualityCells.append(dietCell)
        }
        if exerciseAverage > 0 {
            let exerciseCell = SliderCell(title: "Exercise Amount", value: Float(exerciseAverage), options: getQuestionValueSet(question: .exercise))
            qualityCells.append(exerciseCell)
        }
        if substanceAverage > 0 {
            let substanceCell = SliderCell(title: "Drug/Alcohol Consumption", value: Float(substanceAverage), options: getQuestionValueSet(question: .substances))
            qualityCells.append(substanceCell)
        }
        
        
        let sections: [TableViewItemViewModel] = [
            InfoCell(title: "# Attacks (Last 2 Weeks)" , detail: "\(ep2Weeks.count)", onPressed: nil),
            InfoCell(title: "# Attacks (Last 12 Months)" , detail: "\(ep12Months.count)", onPressed: nil),
            MultiPlotCell(title: "Heart Rate", points: hrs),
            MultiPlotCell(title: "Anxiety", points: anxietys),
            TriggerCell(title: "Triggers", points: triggers, labels: triggerLabels)]
        + qualityCells + [MapCell(coordinates: coordinates)]
        let ds: [TableViewSectionMap] = [TableViewSectionMap(section: nil, items: sections, footer: nil)]
        return ds
        
    }
    
    func chooseSettings() {
        coordinatorDelegate?.didChooseSettings()
    }
    
}


