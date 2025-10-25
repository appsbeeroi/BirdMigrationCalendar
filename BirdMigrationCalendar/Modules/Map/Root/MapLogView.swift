import SwiftUI
import MapKit

struct MapLogView: View {
    
    @StateObject private var viewModel = MapLogViewModel()
    
    @Binding var hasTabBar: Bool
    
    @State private var isMapSheetPresented = false
    @State private var isShowDatePicker = false
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.Images.mainBG)
                    .adoptImage()
                
                VStack(spacing: 20) {
                    navigation
                    mapPreview
                        .frame(height: 250)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                if isShowDatePicker {
                    datePicker
                }
            }
            .animation(.default, value: isShowDatePicker)
            .navigationDestination(for: MapLogScreen.self) { screen in
                switch screen {
                    case  .detail(let record):
                        MapDetailView(record: record)
                }
            }
            .onAppear {
                hasTabBar = true
                viewModel.loadRecords()
            }
            .sheet(isPresented: $isMapSheetPresented) {
                FullMapView(viewModel: viewModel, hasTabBar: $hasTabBar)
                    .ignoresSafeArea()
            }
            .onChange(of: viewModel.selectedDate) { _ in
                viewModel.isFilterOn = true
            }
        }
        .environmentObject(viewModel)
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Map", fontSize: 35)
            
            HStack {
                Button {
                    isShowDatePicker.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .overlay {
                            Image(.Icons.filter)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .overlay(alignment: .topTrailing) {
                                    if viewModel.isFilterOn {
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.red)
                                    }
                                }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
    
    private var datePicker: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Clear filter") {
                        viewModel.isFilterOn = false
                        isShowDatePicker = false
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        isShowDatePicker = false
                    }
                }
                
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.graphical)
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .padding(.horizontal, 35)
        }
    }
    
    private var mapPreview: some View {
        ZStack {
            Map(
                coordinateRegion: $viewModel.region,
                annotationItems: viewModel.filteredRecords.compactMap { record in
                    record.coordinate.map {
                        MapAnnotationItem(id: record.id, record: record, coordinate: $0)
                    }
                }
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.bmcBlue)
                }
            }
            .frame(height: 200)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isMapSheetPresented = true
                }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct FullMapView: View {
    
    @ObservedObject var viewModel: MapLogViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var hasTabBar: Bool
    
    @State private var localRegion: MKCoordinateRegion
    
    init(viewModel: MapLogViewModel, hasTabBar: Binding<Bool>) {
        self.viewModel = viewModel
        _localRegion = State(initialValue: viewModel.region)
        self._hasTabBar = hasTabBar
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(
                coordinateRegion: $localRegion,
                interactionModes: .all,
                annotationItems: viewModel.filteredRecords.compactMap { record in
                    record.coordinate.map {
                        MapAnnotationItem(id: record.id, record: record, coordinate: $0)
                    }
                }
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Button {
                        hasTabBar = false
                        viewModel.navigationPath.append(.detail(item.record))
                        dismiss()
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(.bmcBlue)
                            .shadow(radius: 2)
                            .padding(4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .ignoresSafeArea()
            
            Button {
                viewModel.region = localRegion
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding()
            }
        }
        .onDisappear {
            viewModel.region = localRegion
        }
    }
}

#Preview {
    MapLogView(hasTabBar: .constant(false))
}
