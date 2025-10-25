import SwiftUI
import CoreLocation

struct MapDetailView: View {
        
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: MapLogViewModel
    
    @State var record: LogRecord
    
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        image
                        
                        VStack(spacing: 23) {
                            species
                            
                            VStack(spacing: 12) {
                                rarity
                                migrationDate
                                coordinates
                                note
                            }
                        }
                        .padding(.horizontal, 35)
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                navigation
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navigation: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.bmcBlue)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
    
    private var image: some View {
        Image(uiImage: record.image ?? UIImage())
            .resizable()
            .scaledToFill()
    }
    
    private var species: some View {
        StrokedText(text: record.species, fontSize: 35)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var coordinates: some View {
        VStack {
            Text("Coordinates")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 14))
                .foregroundStyle(.bmcBrown.opacity(0.7))
            
            if let latitude = record.latitude,
               let longitude = record.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let coordinates = String(format: "%.2f, %.2f",
                                         coordinate.latitude,
                                         coordinate.longitude)
                Text(coordinates)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.poller(with: 16))
                    .foregroundStyle(.bmcDarkBrown)
            }
        }
    }
    
    private var rarity: some View {
        Text(record.rarity?.title ?? "N/A")
            .frame(height: 42)
            .padding(.horizontal, 11)
            .font(.poller(with: 14))
            .foregroundStyle(.bmcDarkBrown)
            .background(.white)
            .cornerRadius(36)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var migrationDate: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.bmcBlue)
                
                Text("Migration Date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.poller(with: 14))
                    .foregroundStyle(.bmcBrown.opacity(0.7))
            }
            
            Text(record.date.formatted(.dateTime.year().month(.twoDigits).day()))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 16))
                .foregroundStyle(.bmcDarkBrown)
        }
    }
    
    private var note: some View {
        VStack {
            Text("Note")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 14))
                .foregroundStyle(.bmcBrown.opacity(0.7))
            
            Text(record.note)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 16))
                .foregroundStyle(.bmcDarkBrown)
        }
    }
}

#Preview {
    MapDetailView(record: LogRecord(isMock: true))
}
