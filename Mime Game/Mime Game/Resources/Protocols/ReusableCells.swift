//
//  ReusableCells.swift
//  Mime Game
//
//  Created by anthony gianeli on 30/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import MapKit

public protocol ReusableView { }
extension UIView: ReusableView { }

extension ReusableView where Self: UITableViewCell {

    public static var cellIdentifier: String {
        return "\(Self.self)"
    }

    public static func registerClass(for tableView: UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    public static func registerNib(for tableView: UITableView) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }

    public static func dequeueCell(from tableView: UITableView?, for indexPath: IndexPath? = nil) -> Self {
        if let indexPath = indexPath, let cell = tableView?.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                                                for: indexPath) as? Self {
            return cell
        } else if let cell = tableView?.dequeueReusableCell(withIdentifier: cellIdentifier) as? Self {
            return cell
        } else {
            return Self()
        }
    }
}

extension ReusableView where Self: UICollectionViewCell {

    public static var cellIdentifier: String {
        return "\(Self.self)"
    }

    public static func registerNib(for collection: UICollectionView) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }

    static func dequeueCell(from collection: UICollectionView?, for indexPath: IndexPath) -> Self {
        if let cell = collection?.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Self {
            return cell
        } else {
            return Self()
        }
    }
}

extension ReusableView where Self: UIView {

    public static var headerIdentifier: String {
        return "\(Self.self)"
    }

    public static func registerNib(for tableView: UITableView) {
        let nib = UINib(nibName: headerIdentifier, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }

    public static func dequeueHeader(from tableView: UITableView?) -> Self {
        if let cell = tableView?.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? Self {
            return cell
        } else {
            return Self()
        }
    }
}

extension ReusableView where Self: MKAnnotationView {

    public static var annotationIdentifier: String {
        return "\(Self.self)"
    }

    public static func registerClass(for mapView: MKMapView) {
        mapView.register(self.classForCoder(), forAnnotationViewWithReuseIdentifier: annotationIdentifier)
    }

    public static func dequeueAnnotationView(from map: MKMapView?, for indexPath: IndexPath) -> Self {

        if let annotationView = map?.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? Self {
            return annotationView
        } else {
            return Self()
        }
    }
}

protocol DisplayableCell {

    var mainInformation: String? { get }
    var descriptionInformation: String? { get }
    var dateString: String? { get }
}
