import SwiftUI

struct AppTabView: View {
    
    @State private var selection: AppTabViewState = .calendar
    
    @State private var hasTabBar = true
    
    init() {
        UITabBar.appearance().isHidden = true 
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                tabView
                tabBar
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selection) {
            CalendarView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.calendar)
            
            LogbookView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.logbook)
            
            StatisticsView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.statistics)
            
            MapLogView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.map)
            
            AchievementsView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.achievements)
        }
    }
    
    private var tabBar: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(AppTabViewState.allCases) { state in
                    Button {
                        selection = state 
                    } label: {
                        RoundedRectangle(cornerRadius: 26)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(selection == state ? .bmcBlue : .white)
                            .overlay {
                                Image(state.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(selection == state ? .white : .black)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            .padding(.horizontal, 10)
//            .padding(.bottom, 24)
            .background(.white)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .opacity(hasTabBar ? 1 : 0)
        .animation(.smooth, value: hasTabBar)
    }
}

#Preview {
    AppTabView()
}
