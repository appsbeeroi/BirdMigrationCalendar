import SwiftUI
import Charts

struct StatisticsView: View {
    
    @StateObject private var viewModel = StatisticsViewModel()
    
    @Binding var hasTabBar: Bool
        
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack(spacing: 20) {
                navigation
                
                if viewModel.records.isEmpty {
                    stumb
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {
                            recorsdNumber
                            chartsSection
                            
                            Color.clear
                                .frame(height: 30)
                        }
                        .padding(.horizontal, 35)
                    }
                    .padding(.bottom, 110)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            viewModel.loadRecords()
        }
    }
        
    private var navigation: some View {
        StrokedText(text: "Statistics", fontSize: 35)
            .padding(.top, 20)
    }
    
    private var stumb: some View {
        VStack(spacing: 16) {
            Image(.Icons.Stumb.grapth)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
            
            Text("No data for statistics")
                .font(.poller(with: 25))
                .foregroundStyle(.bmcDarkBrown)
            
            Text("Start adding observations to see your achievements and favorite species")
                .font(.poller(with: 15))
                .foregroundStyle(.bmcBrown)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 35)
    }
    
    private var recorsdNumber: some View {
        HStack {
            HStack(spacing: 8) {
                Image(.Icons.Stumb.grapth)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text("Total number of\nspecies")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.poller(with: 16))
                    .foregroundStyle(.bmcDarkBrown)
                
                Text(viewModel.records.count.formatted())
                    .font(.poller(with: 40))
                    .foregroundStyle(.bmcDarkBrown)
            }
        }
        .frame(height: 85)
        .padding(.horizontal, 8)
        .background(.white)
        .cornerRadius(25)
    }
        
    private var chartsSection: some View {
        VStack(spacing: 50) {
            PieChartView(
                title: "Top 10 bird species",
                data: viewModel.topSpeciesData
            )
            
            PieChartView(
                title: "Migration by month",
                data: viewModel.monthlyMigrationData
            )
        }
    }
}
