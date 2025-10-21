import SwiftUI

struct LogbookView: View {
    
    @StateObject private var viewModel = LogBookViewModel()
    
    @Binding var hasTabBar: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.Images.mainBG)
                    .adoptImage()
                
                VStack(spacing: 20) {
                    navigation
                    
                    if viewModel.records.isEmpty {
                        stumb
                    } else {
                        records
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(for: LogBookScreen.self) { screen in
                switch screen {
                    case .add(let record):
                        AddRecordView(record: record, isDateChoosed: record.image != nil)
                    case .detail(let record):
                        RecordDetailView(record: record)
                    case .favorites:
                        FavoriteRecordsView()
                }
            }
            .onAppear {
                hasTabBar = true
                viewModel.loadRecords()
            }
        }
        .environmentObject(viewModel)
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Logbook", fontSize: 35)
            
            HStack {
                Button {
                    hasTabBar = false
                    viewModel.navigationPath.append(.favorites)
                } label: {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(.white)
                        .overlay {
                            Image(systemName: "heart")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.bmcBlue)
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
    
    private var stumb: some View {
        VStack(spacing: 16) {
            Image(.Icons.Stumb.diary)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            Text("Your log is empty")
                .font(.poller(with: 25))
                .foregroundStyle(.bmcDarkBrown)
            
            Text("Press «Add record» to add the first observation ")
                .font(.poller(with: 15))
                .foregroundStyle(.bmcBrown)
                .multilineTextAlignment(.center)
            
            addButton
        }
        .padding(.horizontal, 35)
    }
    
    private var records: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 6), count: 2), spacing: 6) {
                    ForEach(viewModel.records) { record in
                        Button {
                            hasTabBar = false
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
                
                addButton
            }
            .padding(.horizontal, 35)
        }
        .padding(.bottom, 110)
    }
    
    private var addButton: some View {
        Button {
            hasTabBar = false
            viewModel.navigationPath.append(.add(LogRecord(isMock: false)))
        } label: {
            Text("Add record")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.poller(with: 20))
                .foregroundStyle(.white)
                .background(.bmcBlue)
                .cornerRadius(25)
        }
    }
}

#Preview {
    LogbookView(hasTabBar: .constant(false))
}

