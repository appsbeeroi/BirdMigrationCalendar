import SwiftUI

struct AchievementsView: View {
        
    @Environment(\.dismiss) var dismiss
    
    @Binding var hasTabBar: Bool
    
    @StateObject private var viewModel = AchievementsViewModel()
        
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.Images.mainBG)
                    .adoptImage()
                
                VStack(spacing: 20) {
                    navigation
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            achievements
                            challanges
                        }
                        .padding(.top)
                        .padding(.horizontal, 35)
                        
                        Color.clear
                            .frame(height: 80)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(for: AchievementsScreen.self) { screen in
                switch screen {
                    case .achievement(let achievement):
                        AchievementsDetailView(type: achievement)
                    case .challange(let challenge):
                        ChallangeDetailView(type: challenge)
                }
            }
            .onAppear {
                hasTabBar = true
                viewModel.load()
            }
        }
        .environmentObject(viewModel)
    }
    
    private var navigation: some View {
        ZStack {
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
            
            StrokedText(text: "Achievements\nand Chelengi", fontSize: 30)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
        }
    }
    
    private var achievements: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 3), spacing: 4) {
            ForEach(AchievementType.allCases) { type in
                Button {
                    hasTabBar = false
                    viewModel.navigationPath.append(.achievement(type))
                } label: {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 103)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .overlay {
                            Image(type.icon)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                        }
                        .overlay {
                            if isLocked(of: type) {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.black.opacity(0.5))
                                    .overlay {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundStyle(.orange)
                                    }
                            }
                        }
                }
            }
        }
    }
    
    private var challanges: some View {
        VStack(spacing: 16) {
            StrokedText(text: "Challenges", fontSize: 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            toggle
            
            VStack(spacing: 6) {
                ForEach(Challenge.allCases.filter { $0.type == viewModel.selectedPeriodType }) { type in
                    Button {
                        hasTabBar = false
                        viewModel.navigationPath.append(.challange(type))
                    } label: {
                        VStack(spacing: 10) {
                            Text(type.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.poller(with: 20))
                                .foregroundStyle(.bmcDarkBrown)
                                .multilineTextAlignment(.leading)
                            
                            Text(type.description)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.poller(with: 16))
                                .foregroundStyle(.bmcBrown)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.vertical, 17)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .cornerRadius(13)
                    }
                }
            }
        }
    }
    
    private var toggle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .frame(width: 280, height: 73)
                .foregroundStyle(.white)
            
            HStack(spacing: 0) {
                ForEach(ChallengeType.allCases) { type in
                    Button {
                        viewModel.selectedPeriodType = type
                    } label: {
                        Text(type.rawValue)
                            .frame(width: 136, height: 61)
                            .font(.poller(with: viewModel.selectedPeriodType == type ? 20 : 17))
                            .foregroundStyle(viewModel.selectedPeriodType == type ? .white : .bmcGray)
                            .background(viewModel.selectedPeriodType == type ? .bmcBlue : .clear)
                            .cornerRadius(13)
                            .overlay {
                                if viewModel.selectedPeriodType == type {
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(.bmcGray, lineWidth: 3)
                                }
                            }
                    }
                }
            }
            .frame(width: 226)
            .padding(.horizontal, 4)
        }
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
}

#Preview {
    AchievementsView(hasTabBar: .constant(false))
}
