import SwiftUI

struct CalendarView: View {
    
    @Binding var hasTabBar: Bool
    
    @State var birdsList = BirdCalendar.all
    
    @State private var navigationPath: [CalendarScreen] = []
    @State private var searchedText = ""
    @State private var isShowSettings = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image(.Images.mainBG)
                    .adoptImage()
                
                VStack(spacing: 20) {
                    navigation
                    
                    VStack(spacing: 16) {
                        searchField
                        birds
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(for: CalendarScreen.self) { screen in
                switch screen {
                    case .detail(let bird, let month):
                        BirdDetailView(bird: bird, migration: month)
                }
            }
            .fullScreenCover(isPresented: $isShowSettings) {
                SettingsView()
                    .onDisappear {
                        hasTabBar = true
                    }
            }
            .onAppear {
                hasTabBar = true
            }
            .onChange(of: searchedText) { text in
                guard text != "" else {
                    birdsList = BirdCalendar.all
                    return
                }
        
                birdsList = BirdCalendar.all.filter { month in
                    let flatmap = month.birds.compactMap { $0 }
                    
                    return month.title.contains(text) || flatmap.contains(where: { $0.name.contains(text)})
                }
            }
        }
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Migration\ncalendar", fontSize: 35)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            
            HStack {
                Button {
                    hasTabBar = false
                    isShowSettings.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Image(.Icons.settings)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 35)
    }
    
    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
            
            TextField("", text: $searchedText, prompt: Text("Search by type")
                .foregroundColor(.bmcBrown.opacity(0.5)))
                .font(.poller(with: 20))
                .foregroundStyle(.bmcDarkBrown)
                .focused($isFocused)
            
            if searchedText != "" {
                Button {
                    searchedText = ""
                    isFocused = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 20)
        .foregroundStyle(.bmcBrown)
        .background(.white)
        .cornerRadius(25)
        .padding(.horizontal, 35)
        .onTapGesture {
            isFocused = true
        }
    }
    
    private var birds: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(birdsList) { month in
                    VStack(spacing: 6) {
                        Text(month.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 35)
                            .font(.poller(with: 25))
                            .foregroundStyle(.bmcDarkBrown)
                            .multilineTextAlignment(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(month.birds) { bird in
                                    Button {
                                        hasTabBar = false 
                                        navigationPath.append(.detail(bird: bird, month: month))
                                    } label: {
                                        VStack(spacing: 10) {
                                            Image(bird.image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 135)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                            
                                            Text(bird.name)
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
                            .padding(.leading, 35)
                        }
                    }
                }
                
                Color.clear
                    .frame(height: 30)
            }
        }
        .padding(.bottom, 110)
    }
}

#Preview {
    CalendarView(hasTabBar: .constant(false))
}

