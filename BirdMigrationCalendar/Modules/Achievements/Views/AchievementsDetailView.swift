import SwiftUI

struct AchievementsDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AchievementsViewModel
    
    let type: AchievementType
    
    var hasProgess: Bool {
        type == .differentSpecies || type == .observations || type == .photoprapher
    }
    
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack(spacing: 20) {
                navigation

                if hasProgess {
                    progress
                }
                
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
            Image(type.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 184)
                .padding(5)
            
            Text(type.title)
                .font(.poller(with: 35))
                .foregroundStyle(.bmcDarkBrown)
            
            Text(type.description)
                .font(.poller(with: 22))
                .foregroundStyle(.bmcDarkBrown.opacity(0.5))
        }
        .padding(.vertical, 35)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(30)
        .overlay {
            if isLocked(of: type) {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.black.opacity(0.5))
                    .overlay {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(.orange)
                    }
            }
        }
    }
    
    private var progress: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(hex: "002C6E"))
                
                HStack {
                    let progress = getProgress()
                    
                    RoundedRectangle(cornerRadius: 24)
                        .frame(height: 48)
                        .frame(width: proxy.size.width * progress)
                        .foregroundStyle(Color(hex: "0156D3"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 48)
    }

    private func isLocked(of type: AchievementType) -> Bool {
        switch type {
            case .beginner:
                !viewModel.achievements.isBeginner
            case .observations:
                viewModel.achievements.observationCount < 10
            case .differentSpecies:
                viewModel.achievements.uniqueBirdCount < 5
            case .rareGuest:
                !viewModel.achievements.rareBirdObserved
            case .photoprapher:
                viewModel.achievements.photosCount < 10
        }
    }
    
    private func getProgress() -> Double {
        switch type {
            case .differentSpecies:
                min(1, Double(viewModel.achievements.uniqueBirdCount) / 5)
            case .observations:
                min(1, Double(viewModel.achievements.observationCount) / 10)
            case .photoprapher:
                min(1,Double(viewModel.achievements.photosCount) / 10)
            default:
                0
        }
    }
}

#Preview {
    AchievementsDetailView(type: .photoprapher)
        .environmentObject(AchievementsViewModel())
}

