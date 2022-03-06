//
//  PlotTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class PlotTableViewCell: UITableViewCell { //, ChartDelegate {
    
    //    fileprivate var chart: Chart? // arc
    
    
    static var standardHeight: Double {
        return 180.0
    }
    
    static var reuseIdentifier: String {
        return "plot.cell"
    }
    
    private let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.bgColor
//        view.elevate(elevation: 4)
//        view.layer.cornerRadius = 10.0
//        view.layer.masksToBounds = true
        return view
    }()
    
    private let plotTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plot Title"
        label.textColor = Colors.panicRed
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 16.0)
        return label
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.delegate = self
        view.chartDescription?.enabled = false
        view.isUserInteractionEnabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = false
        view.legend.enabled = false
        view.leftAxis.labelTextColor = Colors.panicRed
        view.rightAxis.enabled = false
        view.xAxis.labelTextColor = Colors.lightPanicRed
        view.xAxis.drawLabelsEnabled = true
        view.xAxis.drawAxisLineEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.xAxis.gridColor = Colors.lightPanicRed
        view.xAxis.granularityEnabled = true
        view.xAxis.granularity = 1
        view.noDataText = "No HR Values Available"
        view.noDataTextColor = Colors.lightPanicRed
        if let font = UIFont(name: "SFCompactRounded-Bold", size: 18.0) {
            view.noDataFont = font
        } else {
            view.noDataFont = .systemFont(ofSize: 24.0)
        }

        return view
    }()
    
    func configure(with viewModel: PlotTableViewCellViewModel?) {
        self.plotTitleLabel.text = viewModel?.infoMessage
        // chartView.data = data
        if let plotPoints = viewModel?.plotPoints, plotPoints.count > 0, let xRange = viewModel?.xRange, let yRange = viewModel?.yRange {
            setPlotData(data: plotPoints, xRange: xRange, yRange: yRange)
        } else {
            chartView.data = nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(cardView)
        cardView.addSubview(plotTitleLabel)
        cardView.addSubview(chartView)
        constrain(cardView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.safeAreaLayoutGuide.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
        }
        constrain(plotTitleLabel) { view in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
        }
        constrain(chartView, plotTitleLabel) { view, pTL in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == pTL.bottom + 8.0
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
        }
    }
    
    func setPlotData(data: [(Int, Int)], xRange: (Double, Double), yRange: (Double, Double)) {
        
        chartView.xAxis.axisMinimum = xRange.0
        chartView.xAxis.axisMaximum = xRange.1
        chartView.leftAxis.axisMinimum = yRange.0
        chartView.leftAxis.axisMaximum = yRange.1
        
        let missingValues = data.filter { $0.1 == 0 }
        var sanitized: [(Int, Int)] = []
        if missingValues.count > 0 {
            sanitized = data.filter { $0.1 != 0 }
        } else {
            sanitized += data
        }
        

        let values = sanitized.map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i.0), y: Double(i.1), icon: nil)
        }
        let set1 = LineChartDataSet(entries: values, label: nil)
        set1.drawIconsEnabled = false
        set1.drawValuesEnabled = false
        set1.mode = .cubicBezier
    
        
//        set1.lineDashLengths = [5, 2.5]
//        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(Colors.lightPanicRed)
        set1.setCircleColor(Colors.panicRed)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
//        set1.valueFont = .systemFont(ofSize: 9)
//        set1.formLineDashLengths = [5, 2.5]
//        set1.formLineWidth = 1
//        set1.formSize = 15
        
        let gradientColors = [Colors.bgColor.cgColor,
                              Colors.panicRed.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        
        let dataSets: [LineChartDataSet] = [set1]
        if missingValues.count > 0 {
//            let entries = missingValues.map { (i) -> ChartDataEntry in
//                return ChartDataEntry(x: Double(i.0), y: Double(i.1), icon: nil)
//            }
//            let set2 = LineChartDataSet(entries: entries, label: nil)
//            set2.drawIconsEnabled = false
//            set2.drawValuesEnabled = false
//            set2.mode = .cubicBezier
//            
//            set2.lineDashLengths = [5, 2.5]
//            set2.highlightLineDashLengths = [5, 2.5]
//            set2.setColor(.lightGray)
//            set2.setCircleColor(.white)
//            set2.lineWidth = 2
//            set2.circleRadius = 5
//            set2.drawCircleHoleEnabled = true
//            set2.circleHoleRadius = 3
////            set2.valueFont = .systemFont(ofSize: 9)
//    //        set1.formLineDashLengths = [5, 2.5]
//    //        set1.formLineWidth = 1
//    //        set1.formSize = 15
//            
////            let gradientColors = [Colors.bgColor.cgColor,
////                                  Colors.panicRed.cgColor]
////            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
////
////            set1.fillAlpha = 1
////            set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
////            set1.drawFilledEnabled = true
//            dataSets.append(set2)
        }
        
        let data = LineChartData(dataSets: dataSets)
        
        chartView.data = data
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plotTitleLabel.text = nil
        chartView.data = nil
    }
    
}

struct PlotCell {
    
    let title: String
    let points: [(Int, Int)]
    let xMin: Double
    let xMax: Double
    let yMin: Double
    let yMax: Double
    
    init(title: String, points: [(Int, Int)], xMin: Double, xMax: Double, yMin: Double, yMax: Double) {
        self.title = title
        self.points = points
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
    }
    
}

extension PlotCell : PlotTableViewCellViewModel {
    
    var infoMessage: String {
        return title
    }
    
    var plotPoints: [(Int, Int)] {
        return points
    }
    
    var xRange: (Double, Double) {
        return (xMin, xMax)
    }
    
    var yRange: (Double, Double) {
        return (yMin, yMax)
    }
}

extension PlotCell : TableViewItemViewModel {
    
    var height: Double {
        return PlotTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return PlotTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol PlotTableViewCellViewModel {
    var infoMessage: String { get }
    var plotPoints: [(Int, Int)] { get }
    var xRange: (Double, Double) { get }
    var yRange: (Double, Double) { get }
}

extension PlotTableViewCell: ChartViewDelegate {}
