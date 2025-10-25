import SwiftUI

struct SplashScreen: View {
    
    @Binding var isLaunched: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack {
                Text("BirdMigration\nCalendar")
                    .font(.poller(with: 40))
                    .multilineTextAlignment(.center)
                
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLaunched = true 
            }
        }
    }
}
