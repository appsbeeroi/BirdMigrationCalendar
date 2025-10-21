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
            
            SettingsView(hasTabBar: $hasTabBar)
                .tag(AppTabViewState.settings)
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
                            .frame(width: 74, height: 74)
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
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal, 35)
        .padding(.bottom, 24)
        .opacity(hasTabBar ? 1 : 0)
        .animation(.smooth, value: hasTabBar)
    }
}

#Preview {
    AppTabView()
}


