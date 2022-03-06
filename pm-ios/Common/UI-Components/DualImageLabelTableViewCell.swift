//
//  DualImageLabelTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/12/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class DualImageLabelTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 70.0
    }
    
    static var reuseIdentifier: String {
        return "historydetail.cell"
    }
    
    private lazy var plotTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plot Title"
        label.textColor = Colors.panicRed
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        return label
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false

        view.delegate = self
        view.chartDescription?.enabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = false
        view.legend.enabled = true
        view.rightAxis.enabled = false
        view.xAxis.labelPosition = .bottom
        return view
    }()
    
    func configure(with viewModel: DualImageLabelTableViewCellViewModel?) {
        self.plotTitleLabel.text = viewModel?.infoMessage
        // chartView.data = data
        if let plotPoints = viewModel?.plotPoints {
            setPlotData(data: plotPoints)
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
        backgroundColor = Colors.opaquePink
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
    
    func setPlotData(data: [[(Int, Int)]]) {
        guard data.count > 0, let first = data.first, let last = data.last else { return }
        
        let d1 = first.map { ChartDataEntry(x: Double($0.0), y: Double($0.1)) }
        let d2 = last.map { ChartDataEntry(x: Double($0.0), y: Double($0.1)) }
        
        let set1 = LineChartDataSet(entries: d1, label: "Last Attack")
        let set2 = LineChartDataSet(entries: d2, label: "First Attack")
        
        for (idx, set) in [set1, set2].enumerated() {
            
            if idx == 0 {
                set.drawIconsEnabled = false
                set.drawValuesEnabled = false
                set.mode = .cubicBezier
    //            set.lineDashLengths = [5, 2.5]
    //            set.highlightLineDashLengths = [5, 2.5]
                set.setColor(Colors.panicRed)
    //            set.setCircleColor(.black)
                set.lineWidth = 2
                set.circleRadius = 0
                set.drawCircleHoleEnabled = false
    //            set.valueFont = .systemFont(ofSize: 9)
    //            set.formLineDashLengths = [5, 2.5]
    //            set.formLineWidth = 1
    //            set.formSize = 15

    //            let gradientColors = [Colors.opaquePink.cgColor,
    //                                  Colors.panicRed.cgColor]
    //            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
                
    //            set.fillAlpha = 1
    //            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
    //            set.drawFilledEnabled = true
            } else {
                set.drawIconsEnabled = false
                set.drawValuesEnabled = false
                set.mode = .cubicBezier
    //            set.lineDashLengths = [5, 2.5]
    //            set.highlightLineDashLengths = [5, 2.5]
                set.setColor(Colors.bgColor)
    //            set.setCircleColor(.black)
                set.lineWidth = 2
                set.circleRadius = 0
                set.drawCircleHoleEnabled = false
    //            set.valueFont = .systemFont(ofSize: 9)
    //            set.formLineDashLengths = [5, 2.5]
    //            set.formLineWidth = 1
    //            set.formSize = 15

    //            let gradientColors = [Colors.opaquePink.cgColor,
    //                                  Colors.panicRed.cgColor]
    //            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
                
    //            set.fillAlpha = 1
    //            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
    //            set.drawFilledEnabled = true
            }
        }
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plotTitleLabel.text = nil
        chartView.data = nil
    }
    
}

struct DualImageLabelCell {
    
    let title: String
    let points: [[(Int, Int)]]
    
    init(title: String, points: [[(Int, Int)]]) {
        self.title = title
        self.points = points
    }
    
}

extension DualImageLabelCell : DualImageLabelTableViewCellViewModel {
    var infoMessage: String {
        return title
    }
    
    var plotPoints: [[(Int, Int)]] {
        return points
    }
}

extension DualImageLabelCell : TableViewItemViewModel {
    
    var height: Double {
        return DualImageLabelTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return DualImageLabelTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol DualImageLabelTableViewCellViewModel {
    var infoMessage: String { get }
    var plotPoints: [[(Int, Int)]] { get }
}

extension DualImageLabelTableViewCell: ChartViewDelegate {}
