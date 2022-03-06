//
//  MapTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import MapKit

class MapTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 360.0
    }
    
    static var reuseIdentifier: String {
        return "map.cell"
    }
    
    private let plotTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Locations"
        label.textColor = Colors.panicRed
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 16.0)

        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.delegate = self
        view.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PinAnnotation")
        return view
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "d MMM yyyy h:mm a"
        return formatter
    }()
    
    func configure(with viewModel: MapTableViewCellViewModel?) {
        if let coordinates = viewModel?.coordinateList, let timestamps = viewModel?.timestampList {
            for (idx, coordinate) in coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.title = "\(dateFormatter.string(from: timestamps[idx]))"
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
//            var zoomRect: MKMapRect = MKMapRect.null
//            for annotation in mapView.annotations {
//                let annotationPoint = MKMapPoint(annotation.coordinate)
//                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
//                zoomRect = zoomRect.union(pointRect)
//            }
//            mapView.setVisibleMapRect(zoomRect, animated: true)
            
        
            mapView.showAnnotations(mapView.annotations, animated: true)
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
        contentView.addSubview(mapView)
        constrain(plotTitleLabel) { view in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
        }
        constrain(mapView, plotTitleLabel) { view, pTL in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == pTL.bottom + 8.0
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
        }
    }
    
}

struct MapCell {
    
    let coordinates: [CLLocationCoordinate2D]
    let timestamps: [Date]

    init(coordinates: [(Date, CLLocationCoordinate2D)]) {
        self.coordinates = coordinates.map { $0.1 }
        self.timestamps = coordinates.map { $0.0 }
    }
    
}

extension MapCell : MapTableViewCellViewModel {
    var coordinateList: [CLLocationCoordinate2D] {
        return coordinates
    }
    var timestampList: [Date] {
        return timestamps
    }
}

extension MapCell : TableViewItemViewModel {
    
    var height: Double {
        return MapTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return MapTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol MapTableViewCellViewModel {
    var coordinateList: [CLLocationCoordinate2D] { get }
    var timestampList: [Date] { get }
}

extension MapTableViewCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotation") as? MKPinAnnotationView
        annotationView?.pinTintColor = Colors.lightPanicRed
        return annotationView
    }
    
}
