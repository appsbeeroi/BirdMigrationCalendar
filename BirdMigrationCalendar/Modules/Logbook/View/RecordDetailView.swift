import SwiftUI

struct RecordDetailView: View {
    
    @EnvironmentObject var viewModel: LogBookViewModel
    
    @State var record: LogRecord
    
    @State private var isLoading = false
    @State private var isShowRemoveAlert = false
    
    var body: some View {
        ZStack {
            Image(.Images.BG)
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
                                note
                            }
                        }
                        .padding(.horizontal, 35)
                    }
                }
                
                actions
            }
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                navigation
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if isLoading {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .alert("Are you sure you want to revome record?", isPresented: $isShowRemoveAlert) {
            Button("Yes", role: .destructive) {
                viewModel.remove(record)
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                isLoading = true 
                viewModel.save(record)
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
            
            Spacer()
            
            Button {
                record.isFavorite.toggle()
            } label: {
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay {
                        Image(systemName: record.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.bmcBlue)
                    }
            }
        }
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
    
    private var actions: some View {
        HStack(spacing: 6) {
            Button {
                viewModel.navigationPath.append(.add(record))
            } label: {
                Circle()
                    .frame(width: 72, height: 72)
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay {
                        Image(systemName: "pencil")
                            .font(.system(size: 38, weight: .medium))
                            .foregroundStyle(.bmcBlue)
                    }
            }
            
            Button {
                isShowRemoveAlert.toggle()
            } label: {
                Circle()
                    .frame(width: 72, height: 72)
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay {
                        Image(systemName: "trash")
                            .font(.system(size: 38, weight: .medium))
                            .foregroundStyle(.red)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(35)
    }
}

#Preview {
    RecordDetailView(record: LogRecord(isMock: true))
        .environmentObject(LogBookViewModel())
}
