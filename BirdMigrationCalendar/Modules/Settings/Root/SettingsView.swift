import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isNotificationWorked") var isNotificationWorked = false
        
    @State private var isNotificationSwitchOn = false
    @State private var isHistoryCleared = false
    @State private var isShowNotificationAlert = false
    @State private var isShowWeb = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.mainBG)
                    .adoptImage()
                
                VStack(spacing: 20) {
                    navigation
                    
                    VStack(spacing: 12) {
                        Image(.Images.settings)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170, height: 170)
                        
                        ForEach(SettingsRow.allCases) { raw in
                            Button {
                                guard raw != .notification else { return }
                                
                                if raw == .history {
                                    isHistoryCleared = true
                                    PreferencesStorage.shared.removeValue(for: .record)
                                }
                                
                                if raw == .about {
                                    isShowWeb.toggle()
                                }
                            } label: {
                                HStack {
                                    Text(raw.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.poller(with: 18))
                                        .foregroundStyle(.bmcDarkBrown)
                                    
                                    switch raw {
                                        case .about:
                                            Image(systemName: "chevron.right")
                                        case .notification:
                                            Toggle("", isOn: $isNotificationSwitchOn)
                                                .labelsHidden()
                                                .tint(.bmcBlue)
                                        case .history:
                                            if isHistoryCleared {
                                                Text("Deleted")
                                                    .font(.poller(with: 18))
                                                    .foregroundStyle(.red)
                                                    .onAppear {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                            isHistoryCleared = false
                                                        }
                                                    }
                                            } else {
                                                EmptyView()
                                            }
                                    }
                                }
                                .frame(minHeight: 65)
                                .padding(.horizontal,20)
                                .background(.white)
                                .cornerRadius(25)
                                .animation(.default, value: isHistoryCleared)
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 35)
                
                if isShowWeb,
                   let url = URL(string: "https://sites.google.com/view/birdmigration-calendar/home") {
                    WebView(url: url) {
                        self.isShowWeb = false
                    }
                    .ignoresSafeArea(edges: [.bottom])
                }
            }
            .onChange(of: isNotificationSwitchOn) { isEnable in
                if isEnable {
                    Task {
                        switch await NotificationAuthService.shared.status {
                            case .granted:
                                isNotificationWorked = isEnable
                            case .denied:
                                isShowNotificationAlert = true
                            case .notDetermined:
                                await NotificationAuthService.shared.requestAccess()
                        }
                    }
                } else {
                    isNotificationSwitchOn = false
                }
            }
            .alert("Notification permission wasn't allowed", isPresented: $isShowNotificationAlert) {
                Button("Yes") {
                    openSettings()
                }
                
                Button("No") {
                    isNotificationSwitchOn = false
                }
            } message: {
                Text("Open app settings?")
            }
        }
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Settings", fontSize: 35)
            
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
        }
        .padding(.top, 20)
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    SettingsView()
}
