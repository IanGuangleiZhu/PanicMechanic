//
//  TriggerTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class TriggerTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 360.0
    }
    
    static var reuseIdentifier: String {
        return "trigger.cell"
    }
    
    private let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.opaquePink
        view.elevate(elevation: 4)
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
    
    private lazy var chartView: PieChartView = {
        let view = PieChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.delegate = self
        view.usePercentValuesEnabled = false
        view.drawSlicesUnderHoleEnabled = false
//        view.holeRadiusPercent = 0.25
//        view.transparentCircleRadiusPercent = 0.25
        view.chartDescription?.enabled = false
        view.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        view.drawCenterTextEnabled = false
        
//        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.alignment = .center
        
//        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
//        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
//                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
//        view.centerAttributedText = centerText;
        
        view.drawHoleEnabled = false
        view.rotationAngle = 0
        view.rotationEnabled = true
        view.highlightPerTapEnabled = true
        
        view.legend.enabled = false
        
//        let l = view.legend
//        l.horizontalAlignment = .right
//        l.verticalAlignment = .top
//        l.orientation = .vertical
//        l.drawInside = false
//        l.xEntrySpace = 7
//        l.yEntrySpace = 0
//        l.yOffset = 0
                        
        // entry label styling
        view.entryLabelColor = .white
        view.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
//        view.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        return view
    }()
    
    func configure(with viewModel: TriggerTableViewCellViewModel?) {
        self.plotTitleLabel.text = viewModel?.infoMessage
        // chartView.data = data
        if let plotPoints = viewModel?.plotPoints, plotPoints.count > 0, let labels = viewModel?.plotLabels, labels.count > 0, labels.count == plotPoints.count {
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
        backgroundColor = Colors.bgColor
        contentView.addSubview(plotTitleLabel)
        contentView.addSubview(chartView)
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

        let entries = data.map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(i.1),
                                     label: labels[i.0],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(entries: entries, label: nil)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(Colors.panicRed)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plotTitleLabel.text = nil
        chartView.data = nil
    }
    
}

struct TriggerCell {
    
    let title: String
    let points: [(Int, Int)]
    let labels: [String]

    init(title: String, points: [(Int, Int)], labels: [String]) {
        self.title = title
        self.points = points
        self.labels = labels
    }
    
}

extension TriggerCell : TriggerTableViewCellViewModel {
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

extension TriggerCell : TableViewItemViewModel {
    
    var height: Double {
        return TriggerTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return TriggerTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol TriggerTableViewCellViewModel {
    var infoMessage: String { get }
    var plotPoints: [(Int, Int)] { get }
    var plotLabels: [String] { get }
}

extension TriggerTableViewCell: ChartViewDelegate {}
