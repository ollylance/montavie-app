//
//  RainyDayLoverWidget.swift
//  RainyDayLoverWidget
//
//  Created by Oliver Lance on 1/23/23.
//

import WidgetKit
import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI

struct PhotoModel: Identifiable {
    var id = UUID().uuidString
    var data: UIImage?
    var error: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let photoData: PhotoModel?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), photoData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), photoData: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let date = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 10, to: date)!
        fetchFromDB { photo in
            let e = SimpleEntry(date: date, photoData: photo)
            let timeline = Timeline(entries: [e], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    func fetchFromDB(completion: @escaping ((PhotoModel) -> ())) {
        let db = Firestore.firestore().collection("posts").order(by: "date", descending: true).limit(to: 1)
        db.getDocuments { (snap, err) in
            guard let documents = snap?.documents else {
                completion(PhotoModel(data: nil, error: "No recent photo."))
                return
            }
            
            let data = documents[0]
            let imageURL = data["imageURL"] as! String
            let imageData = try? Data(contentsOf: URL(string: imageURL)!)
            
            completion(PhotoModel(data: UIImage(data: imageData!), error: ""))
        }
    }
}
        
struct MontavieWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center){
                if let photo = entry.photoData {
                    if photo.error == "" && photo.data != nil {
                        Image(uiImage: photo.data!.scalePreservingAspectRatio(targetSize: CGSize(width: 125, height: 125)))
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(uiImage:
                                UIImage(named: "LoadingIcon")!
                            .scalePreservingAspectRatio(targetSize: CGSize(width: geo.size.width, height: geo.size.height)))
                        .resizable()
                        .scaledToFill()
                    }
                } else {
                    Image(uiImage:
                            UIImage(named: "LoadingIcon")!
                        .scalePreservingAspectRatio(targetSize: CGSize(width: geo.size.width, height: geo.size.height)))
                    .resizable()
                    .scaledToFill()
                }
            }
        }
    }
}

struct MontavieWidget: Widget {
    let kind: String = "MontavieWidget"

    init() {
        FirebaseApp.configure()
        try? Auth.auth().useUserAccessGroup("\(teamID).honeysuckle.Montavie")
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MontavieWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Montavie")
        .description("This is my widget.")
    }
}

extension UIImage {
    // from https://www.advancedswift.com/resize-uiimage-no-stretching-swift/
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

struct RainyDayLoverWidget_Previews: PreviewProvider {
    static var previews: some View {
        MontavieWidgetEntryView(entry: SimpleEntry(date: Date(), photoData: PhotoModel(data: nil, error: "No data")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
