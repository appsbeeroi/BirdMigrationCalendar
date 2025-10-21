import SwiftUI

struct BirdDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let bird: Bird
    let migration: BirdCalendar
    
    var body: some View {
        ZStack {
            Image(.Images.BG)
                .adoptImage()
            
            VStack(spacing: 24) {
                navigation
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        image
                        name
                        status
                        migrationInfo
                        description
                    }
                    .padding(.horizontal, 35)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
        .padding(.top, 20)
        .padding(.horizontal, 35)
    }
    
    private var image: some View {
        Image(bird.image)
            .resizable()
            .scaledToFill()
            .frame(height: 250)
            .clipped()
            .cornerRadius(20)
    }
    
    private var name: some View {
        StrokedText(text: bird.name, fontSize: 35)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var status: some View {
        Text(bird.status.title)
            .frame(height: 42)
            .padding(.horizontal, 11)
            .font(.poller(with: 14))
            .foregroundStyle(.bmcDarkBrown)
            .background(.white)
            .cornerRadius(35)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var migrationInfo: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.bmcBlue)
                
                Text("Migration")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.poller(with: 14))
                    .foregroundStyle(.bmcBrown.opacity(0.7))
            }
            
            Text(migration.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 16))
                .foregroundStyle(.bmcDarkBrown)
        }
     }
    
    private var description: some View {
        VStack {
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 14))
                .foregroundStyle(.bmcBrown.opacity(0.7))
            
            Text(bird.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 17))
                .foregroundStyle(.bmcDarkBrown)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    BirdDetailView(bird: BirdCalendar.all.first!.birds.first!, migration: .february([]))
}
