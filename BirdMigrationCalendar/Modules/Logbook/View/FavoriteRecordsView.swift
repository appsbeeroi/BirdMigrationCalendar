import SwiftUI

struct FavoriteRecordsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: LogBookViewModel
    
    var favoriteRecords: [LogRecord] {
        viewModel.records.filter { $0.isFavorite }
    }
    
    var body: some View {
        ZStack {
            Image(.Images.BG)
                .adoptImage()
            
            VStack(spacing: 20) {
                navigation
                
                if favoriteRecords.isEmpty {
                    stumb
                } else {
                    records
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Favorites", fontSize: 35)
            
            HStack {
                Button {
                   dismiss()
                } label: {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(.white)
                        .overlay {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.bmcBlue)
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
    
    private var stumb: some View {
        VStack(spacing: 16) {
            Image(.Icons.Stumb.heart)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            Text("There are no selected observations yet")
                .font(.poller(with: 25))
                .foregroundStyle(.bmcDarkBrown)
            
            Text("Mark rare or favorite encounters, and they will appear here")
                .font(.poller(with: 15))
                .foregroundStyle(.bmcBrown)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 35)
    }
    
    private var records: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 6), count: 2), spacing: 6) {
                    ForEach(favoriteRecords) { record in
                        Button {
                            viewModel.navigationPath.append(.detail(record))
                        } label: {
                            VStack(spacing: 10) {
                                if let image = record.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 135)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                }
                                
                                Text(record.species)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 13)
                                    .font(.poller(with: 16))
                                    .foregroundStyle(.bmcDarkBrown)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(width: (UIScreen.main.bounds.width - 76) / 2)
                            .background(.white)
                            .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.horizontal, 35)
        }
    }
}

#Preview {
    FavoriteRecordsView()
}
