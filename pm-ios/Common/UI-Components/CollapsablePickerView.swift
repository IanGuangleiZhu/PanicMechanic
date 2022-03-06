//
//  CollapsablePickerView.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/17/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

// SOURCE: https://stackoverflow.com/questions/15484506/show-uipickerview-like-a-keyboard-without-uitextfield
class CollapsablePickerView: UIView {
    
    // MARK: - Properties -
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    internal let notificationCenter: NotificationCenter = .default
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    // MARK: - UI Elements -
    private lazy var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barStyle = .black
        toolbar.isTranslucent = true
        toolbar.barTintColor = UIColor(red:0.44, green:0.08, blue:0.31, alpha:1.0)
        toolbar.tintColor = .white
        
        func setupLabelBarButtonItem() -> UIBarButtonItem {
            let label = UILabel()
            label.text = "Choose a Date"
            label.textColor = .white
            return UIBarButtonItem(customView: label)
        }
        
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(setToday))
        let selectButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(selectDate))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([todayButton, flexButton, setupLabelBarButtonItem(), flexButton, selectButton], animated: false)
        return toolbar
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.timeZone = TimeZone.current
        picker.backgroundColor = UIColor.gray
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Objective-C Action Methods -
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        print(dateFormatter.string(from: sender.date))
    }
    
    public static func formatDate(date: Date) -> Date? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        print("CAL: \(calendar) Y: \(year) M: \(month) D: \(day)")
        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        print("COMP: \(components)")
        return calendar.date(from: components)
    }
    
    public static func adjustDate(date: Date, forward: Bool) -> Date? {
        let tz = TimeZone.current
        let value = tz.isDaylightSavingTime(for: date) ? (forward ? 4 : -4) : (forward ? 5 : -5)
        return Calendar.current.date(byAdding: .hour, value: value, to: date)
    }
    
    @objc func selectDate(_ sender: UIBarButtonItem) {
        let date = datePicker.date
        let formatted = dateFormatter.string(from: date)
        self.notificationCenter.post(name: .dateChanged, object: ["SELECTED_DATE": date, "FORMATTED": formatted])
    }
    
    @objc func setToday(_ sender: UIBarButtonItem) {
        let now = Date()
        datePicker.setDate(now, animated: true)
    }
    
    // MARK: - Private Helpers -
    private func setupView() {
        backgroundColor = .white
        addSubview(pickerToolbar)
        addSubview(datePicker)
        setupLayout()
    }
    
    private func setupLayout() {
        constrain(pickerToolbar) { view in
            view.height == 40.0
            view.top == view.superview!.top
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
        }
        constrain(datePicker, pickerToolbar) { view, pT in
            view.width == view.superview!.width
            view.top == pT.bottom
            view.bottom == view.superview!.bottom
        }
    }
    
}
