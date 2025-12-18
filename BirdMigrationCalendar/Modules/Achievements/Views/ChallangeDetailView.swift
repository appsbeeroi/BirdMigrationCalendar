import SwiftUI

struct ChallangeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private let userDefaults = UserDefaults.standard
    
    let type: Challenge
    
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack(spacing: 20) {
                navigation
                image
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 35)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navigation: some View {
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
    
    private var image: some View {
        VStack(spacing: 14) {
            Text(type.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 25))
                .foregroundStyle(.bmcDarkBrown)
                .multilineTextAlignment(.leading)
            
            Text(type.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 19))
                .foregroundStyle(.bmcDarkBrown.opacity(0.5))
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 35)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(30)
    }
    

    private func getLockStatus(of type: AchievementType) -> Bool {
        let key = type.rawValue
        let value = userDefaults.bool(forKey: key)
        
        return value
    }
}


#Preview {
    ChallangeDetailView(type: .findAStarling)
}
