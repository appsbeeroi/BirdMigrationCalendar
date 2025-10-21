import SwiftUI

struct ContentView: View {
    
    @State private var isLaunched = false
    var body: some View {
        if isLaunched {
            AppTabView()
        } else {
            SplashScreen(isLaunched: $isLaunched)
        }
    }
}

#Preview {
    ContentView()
}

