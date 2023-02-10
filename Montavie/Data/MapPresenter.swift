//
//  MapPresenter.swift
//  GeoJsonSample
//
//  Created by Kamal Bhardwaj on 05/07/20.
//  Copyright © 2020 Kamal Bhardwaj. All rights reserved.
//

import Foundation
import MapKit


//protocol MapPresenter {
//    func viewDidLoad()
//}
//
//class MapPresenterImplementation: MapPresenter {
//
//    private var geometry: [MKShape & MKGeoJSONObject]!
//    private var properties: Data?
//
//    func viewDidLoad() {
//        self.view?.setUpMapView()
//        self.fetchJson()
//    }
//
//
//
//    private func fetchPolygonCoordinates(polygon: MKPolygon) {
//
//        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
//                                              count: polygon.pointCount)
//        polygon.getCoordinates(&coords,
//                               range: NSRange.init(location: 0, length: polygon.pointCount))
//        var annotations = [MKPointAnnotation]()
//        for coordinate in coords {
//            let annotation = MKPointAnnotation.init()
//            annotation.coordinate = coordinate
//            annotations.append(annotation)
//        }
//        self.view?.setAnnotations(annotations: annotations)
//    }
//}
