import SwiftUI
import MapKit

struct MapViewSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var record: LogRecord
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, annotationItems: annotationItems) { item in
                MapMarker(coordinate: item.coordinate, tint: .blue)
            }
            .onAppear {
                if let latitude = record.latitude,
                    let longitude = record.longitude {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    region.center = coordinate
                }
            }
            .onTapGestureOnMap { location in
                record.latitude = location.latitude
                record.longitude = location.longitude
                region.center = location
                dismiss()                  
            }
            .ignoresSafeArea()
            
            Button("Cancel") {
                dismiss()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(12)
            .padding()
        }
    }
    
    private var annotationItems: [AnnotationItem] {
        if let latitude = record.latitude,
           let longitude = record.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return [AnnotationItem(coordinate: coordinate)]
        }
        return []
    }
    
    struct AnnotationItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}
