//
//  HelpView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/18/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var tabSelection: TabBarItem
    @ObservedObject var mapData: MapData
    @ObservedObject var sessionAuth: SessionAuth
    @ObservedObject var profileData: ProfileData
    @ObservedObject var likeData = LikeData()
    @ObservedObject var commentData = CommentData()
    @State var selectedLocation: Post? = nil
    
    var body: some View {
        ZStack {
            if (mapData.mapData.count != 0) {
                ZStack {
                    MapPolylineView(mapData: mapData, selectedLocation: $selectedLocation)
                        .edgesIgnoringSafeArea(.all)
                    ZStack {
                        if mapData.selectedLocation != nil {
                            ForEach(mapData.mapData) {post in
                                if post == mapData.selectedLocation {
                                    VStack {
                                        Spacer()
                                        LocationPreviewView(post: mapData.selectedLocation!, sessionAuth: sessionAuth, profileData: profileData, mapData: mapData, likeData: likeData, commentData: commentData)
                                            .padding()
                                    }
                                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Loading Map...")
            }
        }
        .onChange(of: selectedLocation) { new in
            mapData.selectLocation(post: new)
        }
    }
    
}

struct MapPolylineView: UIViewRepresentable {
    @ObservedObject var mapData: MapData
    @Binding var selectedLocation: Post?
    @State var fromButton = false
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.region = mapData.mapRegion
        context.coordinator.cachedRegion = mapData.mapRegion
        
        let multiPolylines = fetchJson()
        var polylines: [MKPolyline] = []
        for p in multiPolylines {
            polylines = polylines + p.polylines
        }
        let multi = MKMultiPolyline(polylines)
        mapView.addOverlay(multi)
        
        let annotationItems: [MKPointAnnotation] = mapData.mapData.map { MKPointAnnotation(__coordinate: $0.location!, title: $0.key, subtitle: $0.color) }
        mapView.addAnnotations(annotationItems)
        context.coordinator.cachedAnnotations = annotationItems
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if (mapData.mapRegion.center != context.coordinator.cachedRegion.center){
            // gets the selected annotation
            guard let annotationIndex = view.annotations.firstIndex(where: {
                let title = $0.title
                if title != nil && title! != nil && mapData.selectedLocation != nil {
                    return title!! == mapData.selectedLocation!.key
                }
                return false
            }) else {
                view.setRegion(mapData.mapRegion, animated: true)
                context.coordinator.cachedRegion = mapData.mapRegion
                return
            }
            view.selectAnnotation(view.annotations[annotationIndex], animated: true)
            view.setRegion(mapData.mapRegion, animated: true)
            context.coordinator.cachedRegion = mapData.mapRegion
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func fetchJson() -> [MKMultiPolyline] {
        guard let geoJsonFileUrl = Bundle.main.url(forResource: "TrailData", withExtension: "geojson"),
            let geoJsonData = try? Data.init(contentsOf: geoJsonFileUrl) else {
                print("Failure to fetch the file.")
                return []
        }

        guard let objs = try? MKGeoJSONDecoder().decode(geoJsonData) as? [MKGeoJSONFeature] else {
            print("Wrong format")
            return []
        }
        
        var polylineVal: [MKMultiPolyline] = []

        objs.forEach { (feature) in
            guard let geometry = feature.geometry.first else {
                return;
            }
            if let polyline = geometry as? MKMultiPolyline {
                polylineVal.append(polyline)
            }
        }
        return polylineVal
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapPolylineView
    var cachedAnnotations: [MKPointAnnotation]
    var cachedRegion: MKCoordinateRegion
    
    init(_ parent: MapPolylineView) {
        self.parent = parent
        self.cachedAnnotations = []
        self.cachedRegion = MKCoordinateRegion()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKMultiPolyline {
            let renderer = MKMultiPolylineRenderer(multiPolyline: routePolyline)
            renderer.strokeColor = UIColor(named: "BrandBlue")!.withAlphaComponent(0.75)
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation?.coordinate != nil {
            guard let currentIndex = self.parent.mapData.mapData.firstIndex(where: {
                return $0.location == view.annotation?.coordinate
            }) else {
                return
            }
            DispatchQueue.main.async { self.parent.selectedLocation = self.parent.mapData.mapData[(currentIndex)] }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        DispatchQueue.main.async { self.parent.selectedLocation = nil }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        if (annotation.subtitle != nil && annotation.subtitle! != nil) {
            annotationView.markerTintColor = UIColor(named: annotation.subtitle!!)
        }
        annotationView.displayPriority = .required
        annotationView.glyphImage = UIImage(named: "ShoeIcon")
        annotationView.titleVisibility = .hidden
        annotationView.subtitleVisibility = .hidden

        return annotationView
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(tabSelection: .constant(.post), mapData: MapData(), sessionAuth: SessionAuth(), profileData: ProfileData())
    }
}
