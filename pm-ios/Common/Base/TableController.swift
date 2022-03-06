//
//  TableController.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class TableController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var datasource: [TableViewSectionMap] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
    lazy var tableView: UITableView = {
        // Change to .plain for floating headers
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerAll()
        return tableView
    }()
    
    private func layoutSubviews() {
        constrain(tableView) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.safeAreaLayoutGuide.top
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
        }
    }
    
    // MARK: Headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(datasource[section].section?.height ?? 0)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            do {
                try header.configure(with: datasource[section].section)
            } catch {
                
            }
        }
    }
    
    // MARK: Footers
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(datasource[section].footer?.height ?? 0)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            do {
                try footer.configure(with: datasource[section].footer)
            } catch {
                
            }
        }
    }
    
    // MARK: Cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = datasource[indexPath.section].items[indexPath.row].height
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        do {
            try cell.configure(with: datasource[indexPath.section].items[indexPath.row])
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let action = datasource[indexPath.section].items[indexPath.row].action {
            action()
         } else {
            print("Cell does not have an action")
         }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    // MARK: Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = datasource[section].section, header.height > 0 else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier)
        headerView?.tag = section
        return headerView
    }
    
    // MARK: Footers
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = datasource[section].footer, footer.height > 0 else { return nil }
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.reuseIdentifier)
        return footerView
    }
    
    // MARK: Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = datasource[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
        return cell
    }
    
}

protocol TableViewItemViewModel {
    var reuseIdentifier: String { get }
    var height: Double { get }
    var action: (() -> Void)? { get }
}

struct TableViewSectionMap {
    let section: TableViewItemViewModel?
    let items: [TableViewItemViewModel]
    let footer: TableViewItemViewModel?
}

enum TableViewConfigureError: Error {
    case cellNotRegistered
    case headerFooterNotRegistered
}

extension UITableView {
  func registerAll() {
    // Cells
    register(DestructiveTableViewCell.self, forCellReuseIdentifier: DestructiveTableViewCell.reuseIdentifier)
    register(InfoMessageTableViewCell.self, forCellReuseIdentifier: InfoMessageTableViewCell.reuseIdentifier)
    register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier)
    register(PlotTableViewCell.self, forCellReuseIdentifier: PlotTableViewCell.reuseIdentifier)
    register(MultiPlotTableViewCell.self, forCellReuseIdentifier: MultiPlotTableViewCell.reuseIdentifier)
    register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
    register(TriggerTableViewCell.self, forCellReuseIdentifier: TriggerTableViewCell.reuseIdentifier)
    register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
    register(DualOptionTableViewCell.self, forCellReuseIdentifier: DualOptionTableViewCell.reuseIdentifier)
    register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.reuseIdentifier)
    register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.reuseIdentifier)
    register(HorizontalBarChartTableViewCell.self, forCellReuseIdentifier: HorizontalBarChartTableViewCell.reuseIdentifier)
    register(CenterLabelTableViewCell.self, forCellReuseIdentifier: CenterLabelTableViewCell.reuseIdentifier)
    register(SliderTableViewCell.self, forCellReuseIdentifier: SliderTableViewCell.reuseIdentifier)
    register(ProfileAvatarTableViewCell.self, forCellReuseIdentifier: ProfileAvatarTableViewCell.reuseIdentifier)

    // Headers
    register(HistoryHeaderView.self, forHeaderFooterViewReuseIdentifier: HistoryHeaderView.reuseIdentifier)
    register(QuestionHeaderView.self, forHeaderFooterViewReuseIdentifier: QuestionHeaderView.reuseIdentifier)

    // Footers
//    register(UINib(nibName: String(describing: InfoTableViewHeaderFooterView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: InfoTableViewHeaderFooterView.reuseIdentifier)
  }
}

extension UITableViewCell {
    func configure(with viewModel: TableViewItemViewModel?) throws {
        switch self {
        case is BaseTableViewCell:
            (self as! BaseTableViewCell).configure(with: viewModel as? BaseTableViewCellViewModel)
        case is SubtitleTableViewCell:
            (self as! SubtitleTableViewCell).configure(with: viewModel as? SubtitleTableViewCellViewModel)
        case is InfoMessageTableViewCell:
            (self as! InfoMessageTableViewCell).configure(with: viewModel as? InfoMessageTableViewCellViewModel)
        case is DestructiveTableViewCell:
            (self as! DestructiveTableViewCell).configure(with: viewModel as? DestructiveTableViewCellViewModel)
        case is PlotTableViewCell:
            (self as! PlotTableViewCell).configure(with: viewModel as? PlotTableViewCellViewModel)
        case is MultiPlotTableViewCell:
            (self as! MultiPlotTableViewCell).configure(with: viewModel as? MultiPlotTableViewCellViewModel)
        case is MapTableViewCell:
            (self as! MapTableViewCell).configure(with: viewModel as? MapTableViewCellViewModel)
        case is TriggerTableViewCell:
            (self as! TriggerTableViewCell).configure(with: viewModel as? TriggerTableViewCellViewModel)
        case is DualOptionTableViewCell:
            (self as! DualOptionTableViewCell).configure(with: viewModel as? DualOptionTableViewCellViewModel)
        case is LoadingTableViewCell:
            (self as! LoadingTableViewCell).configure(with: viewModel as? LoadingTableViewCellViewModel)
        case is QuestionTableViewCell:
            (self as! QuestionTableViewCell).configure(with: viewModel as? QuestionTableViewCellViewModel)
        case is HorizontalBarChartTableViewCell:
            (self as! HorizontalBarChartTableViewCell).configure(with: viewModel as? HorizontalBarChartTableViewCellViewModel)
        case is CenterLabelTableViewCell:
            (self as! CenterLabelTableViewCell).configure(with: viewModel as? CenterLabelTableViewCellViewModel)
        case is SliderTableViewCell:
            (self as! SliderTableViewCell).configure(with: viewModel as? SliderTableViewCellViewModel)
        case is ProfileAvatarTableViewCell:
            (self as! ProfileAvatarTableViewCell).configure(with: viewModel as? ProfileAvatarTableViewCellViewModel)
        default:
            throw TableViewConfigureError.cellNotRegistered
        }
    }
}

extension UITableViewHeaderFooterView {
    func configure(with viewModel: TableViewItemViewModel?) throws {
        switch self {
        case is HistoryHeaderView:
            (self as! HistoryHeaderView).configure(with: viewModel as? HistoryHeaderViewModel)
        case is QuestionHeaderView:
            (self as! QuestionHeaderView).configure(with: viewModel as? QuestionHeaderViewModel)
//        case is SubtitleTableViewHeaderView:
//            (self as! SubtitleTableViewHeaderView).configure(with: viewModel as? SubtitleHeaderViewViewModel)
//        case is InfoTableViewHeaderView:
//            (self as! InfoTableViewHeaderView).configure(with: viewModel as? InfoTableViewHeaderViewViewModel)
        default:
            throw TableViewConfigureError.headerFooterNotRegistered
        }
    }
}
