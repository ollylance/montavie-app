//
//  LocationView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 1/9/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var post: Post
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.4406,
            longitude: 79.9959),
        latitudinalMeters: .init(10000),
        longitudinalMeters: .init(10000))
    
    var body: some View {
        let regionWithOffset = Binding<MKCoordinateRegion>(
        get: {
            let offsetCenter = CLLocationCoordinate2D(latitude: (post.location?.latitude ?? region.center.latitude) + region.span.latitudeDelta * 0.30, longitude: post.location?.longitude ?? region.center.longitude)
            return MKCoordinateRegion(
                center: offsetCenter,
                span: region.span)
            },
            set: {
                $0
            }
        )
        
        ZStack {
            Map(coordinateRegion: regionWithOffset,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                annotationItems: [post.location ?? region.center]) {
                pin in
                MapMarker(coordinate: pin)
            }
            .edgesIgnoringSafeArea(.all)
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("CloseIcon")
                    .foregroundColor(Color("Text"))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing, 40)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(post: .constant(Post()))
    }
}
