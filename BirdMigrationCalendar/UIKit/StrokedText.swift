import SwiftUI

struct StrokedText: View {
    
    let text: String
    let color: Color
    let fontSize: CGFloat
    
    init(
        text: String,
        color: Color = .white,
        fontSize: CGFloat
    ) {
        self.text = text
        self.color = color
        self.fontSize = fontSize
    }
    
    var body: some View {
        ZStack {
            Group {
                Text(text)
                    .offset(y: 1)
                
                Text(text)
                    .offset(y: -1)
                
                Text(text)
                    .offset(x: 1)
                
                Text(text)
                    .offset(x: -1)
                
                Text(text)
                    .offset(x:-1, y: -1)
                
                Text(text)
                    .offset(x: 1, y: -1)
                
                Text(text)
                    .offset(y: 2)
                
                Text(text)
                    .offset(y: 3)
                
                Text(text)
                    .offset(x: 1, y: 2)
                
                Text(text)
                    .offset(x:-1, y: 2)
                
                Text(text)
                    .offset(x: 1, y: 3)
                
                Text(text)
                    .offset(x:-1, y: 3)
            }
            .foregroundStyle(.bmcBrown)
            .font(.poller(with: fontSize))
            
            Text(text)
                .font(.poller(with: fontSize))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    StrokedText(text: "Migration", fontSize: 35)
}
