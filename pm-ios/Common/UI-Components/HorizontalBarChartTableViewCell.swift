//
//  HorizontalBarChartTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/12/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class HorizontalBarChartTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 80.0
    }
    
    static var reuseIdentifier: String {
        return "horizontalbarchart.cell"
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
        label.font = .boldSystemFont(ofSize: 16)

        return label
    }()
    
    private lazy var chartView: HorizontalBarChartView = {
        let view = HorizontalBarChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false

        view.chartDescription?.enabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = false
//        view.setViewPortOffsets(left: 12, top: 0, right: -12, bottom: -12)

        view.delegate = self
            
        view.drawBarShadowEnabled = false
        view.drawValueAboveBarEnabled = false
        
//        view.maxVisibleCount = 60
        
        let xAxis = view.xAxis
        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.granularity = 1

        let leftAxis = view.leftAxis
        leftAxis.enabled = false
//        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
         leftAxis.axisMaximum = 4

        let rightAxis = view.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 8)
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 4
        rightAxis.granularityEnabled = true
        rightAxis.granularity = 1
        rightAxis.labelTextColor = Colors.panicRed
        
        view.setExtraOffsets(left: 0, top: 0, right: 30, bottom: 10)
        view.legend.enabled = false
//        view.fitBars = false
//        view.animate(yAxisDuration: 2.5)
        
        return view
    }()
    
    func configure(with viewModel: HorizontalBarChartTableViewCellViewModel?) {
        self.plotTitleLabel.text = viewModel?.infoMessage
        // chartView.data = data
        if let plotPoints = viewModel?.plotPoints, let labels = viewModel?.plotLabels {
            setPlotData(data: plotPoints, labels: labels)
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

    func setPlotData(data: [(Int, Int)], labels: [String]) {
//        print("Setting data: \(data), labels: \(labels)")
        
        chartView.rightAxis.valueFormatter = IndexAxisValueFormatter(values: labels)


//        let barWidth = 4.0
       let spaceForBar = 10.0
                
       let yVals = data.map { (i) -> BarChartDataEntry in
            let val = Double(i.1)
            return BarChartDataEntry(x: Double(i.0)*spaceForBar, y: val, icon: nil)
       }
        print(yVals)
       
       let set1 = BarChartDataSet(entries: yVals, label: nil)
       set1.drawIconsEnabled = false
        set1.setColor(Colors.panicRed)
        set1.drawValuesEnabled = false
        
       let data = BarChartData(dataSet: set1)
//       data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
//       data.barWidth = barWidth
       
       chartView.data = data
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plotTitleLabel.text = nil
        chartView.data = nil
    }
    
}

struct HorizontalBarChartCell {
    
    let title: String
    let points: [(Int, Int)]
    let labels: [String]
    
    init(title: String, points: [(Int, Int)], labels: [String]) {
        self.title = title
        self.points = points
        self.labels = labels
    }
    
}

extension HorizontalBarChartCell : HorizontalBarChartTableViewCellViewModel {
    var infoMessage: String {
        return title
    }
    
    var plotPoints: [(Int, Int)] {
        return points
    }
    
    var plotLabels: [String] {
        return labels
    }
}

extension HorizontalBarChartCell : TableViewItemViewModel {
    
    var height: Double {
        return HorizontalBarChartTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return HorizontalBarChartTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol HorizontalBarChartTableViewCellViewModel {
    var infoMessage: String { get }
    var plotPoints: [(Int, Int)] { get }
    var plotLabels: [String] { get }
}

extension HorizontalBarChartTableViewCell: ChartViewDelegate {}


extension HorizontalBarChartTableViewCell: IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "My cool label " + String(value)
    }
    
    
}
