//
//  HistoryViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol HistoryViewModelType {
    
    var viewDelegate: HistoryViewModelViewDelegate? { get set }
    var coordinatorDelegate: HistoryViewModelCoordinatorDelegate? { get set }
    
    func start()
    func item(at index: Int) -> PanicMechanicEpisode
    func deleteEpisode(episode: PanicMechanicEpisode)
}

protocol HistoryViewModelCoordinatorDelegate: class {}

protocol HistoryViewModelViewDelegate: class {
    func updateDataSource(ds: [TableViewSectionMap])
    
}

class HistoryViewModel: HistoryViewModelType {
    
    weak var coordinatorDelegate: HistoryViewModelCoordinatorDelegate?
    weak var viewDelegate: HistoryViewModelViewDelegate?
    
    private let service: EpisodeService
    private var episodes: [PanicMechanicEpisode] = [] {
        didSet {
            let ds = createDataSource(from: episodes)
            viewDelegate?.updateDataSource(ds: ds)
        }
    }
    private var handler: (([PanicMechanicEpisode]?, Error?) -> Void)?

    init(service: EpisodeService) {
        self.service = service
    }
    
    func start() {
        loadEpisodes()
    }
    
    func item(at index: Int) -> PanicMechanicEpisode {
        return episodes[index]
    }
    
    func loadEpisodes() {
        service.loadEpisodes { episodes, error in
            if let error = error {
                print("error getting episodes: \(error.localizedDescription)")
                return
            } else {
                if let episodes = episodes {
                    self.episodes = episodes
                } else {
                    print("error getting episodes after retrieval")
                }
            }
        }
    }
    
    func deleteEpisode(episode: PanicMechanicEpisode) {
        service.deleteEpisode(episode: episode) { error in
            if let error = error {
                // Show alert
                log.error("Delete episode failed:", context: error)
                return
            }
            log.info("Successfully deleted episode:", context: episode)
//            self.loadEpisodes()
        }
    }
    
    private func createDataSource(from episodes: [PanicMechanicEpisode]) -> [TableViewSectionMap]  {
        guard episodes.count > 0 else { return [] }
        var ds: [TableViewSectionMap] = []
        for ep in episodes {
            let bpms = ep.cycles.enumerated().filter { $1.hr != nil }.map { ($0, $1.hr!.bpm) }
            let ratings = ep.cycles.enumerated().filter { $1.anxiety != nil }.map { ($0, $1.anxiety!.rating) }
            let questions = ep.cycles.map { $0.question }
            
            let p1 = PlotCell(title: "Heart Rate", points: bpms, xMin: 0, xMax: Double(bpms.count), yMin: 40, yMax: 220)
            let p2 = PlotCell(title: "Anxiety", points: ratings, xMin: 0, xMax: Double(ratings.count), yMin: 1, yMax: 10)
            
            var cells: [SliderCell] = []
            var trigger: String = "Unknown"
            for question in questions {
                if let question = question {
                    if question.name == "TRIGGER" {
                        trigger = question.answer
                    } else {
                        if let rating = Int(question.answer) {
                            switch question.name {
                            case "SLEEP":
                                let cell = SliderCell(title: "Sleep Quality", value: Float(rating), options: getQuestionValueSet(question: .sleep))
                                cells.append(cell)
                            case "DIET":
                                let cell = SliderCell(title: "Eating Habits", value: Float(rating), options: getQuestionValueSet(question: .diet))
                                cells.append(cell)
                            case "EXERCISE":
                                let cell = SliderCell(title: "Exercise Amount", value: Float(rating), options: getQuestionValueSet(question: .exercise))
                                cells.append(cell)
                            case "STRESS":
                                let cell = SliderCell(title: "Stress Level", value: Float(rating), options: getQuestionValueSet(question: .stress))
                                cells.append(cell)
                            case "SUBSTANCES":
                                let cell = SliderCell(title: "Drug/Alcohol Consumption", value: Float(rating), options: getQuestionValueSet(question: .substances))
                                cells.append(cell)
                            default:
                                continue
                            }
                        }
                    }
                    
                }
            }
            
            let viewModels: [TableViewItemViewModel] = [p1, p2] + cells
            let location = ep.location?.name ?? "Unknown"
            
            let header = HistoryHeader(trigger: trigger, timestamp: ep.startTs, location: location)
            
            let section = TableViewSectionMap(section: header, items: viewModels, footer: nil)
            ds.append(section)
        }
        return ds
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    
    private let dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    private let amPMFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "a"
        return formatter
    }()
    
}


