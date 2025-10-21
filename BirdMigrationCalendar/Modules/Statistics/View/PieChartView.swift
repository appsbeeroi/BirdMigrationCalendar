import SwiftUI

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

import SwiftUI

struct PieChartView: View {
    
    let title: String
    let data: [ChartData]
    
    @State private var animateFill = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.poller(with: 20))
                .foregroundColor(.bmcDarkBrown)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                ForEach(Array(pieSlices.enumerated()), id: \.offset) { index, slice in
                    PieSlice(
                        startAngle: slice.startAngle,
                        endAngle: animateFill ? slice.endAngle : slice.startAngle
                    )
                    .fill(slice.color)
                    .animation(.easeOut(duration: 1.0).delay(Double(index) * 0.06), value: animateFill)
                }
            }
            .frame(width: 110, height: 110)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        animateFill = true
                    }
                }
            }
            
            legend
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 4)
    }
        
    private var totalValue: Double {
        let s = data.map { $0.value }.reduce(0, +)
        return s == 0 ? 1 : s
    }
    
    private var pieSlices: [PieSliceData] {
        var slices: [PieSliceData] = []
        var startAngle: Angle = .degrees(0)
        
        for item in data {
            let proportion = item.value / totalValue
            let endAngle = startAngle + .degrees(proportion * 360)
            let slice = PieSliceData(
                id: UUID(),
                startAngle: startAngle,
                endAngle: endAngle,
                color: color(for: item),
                label: item.label,
                value: item.value
            )
            slices.append(slice)
            startAngle = endAngle
        }
        return slices
    }
    
    private var top3Slices: [PieSliceData] {
        pieSlices.sorted(by: { $0.value > $1.value }).prefix(3).map { $0 }
    }
        
    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(data.prefix(10)) { item in
                HStack(spacing: 8) {
                    Circle()
                        .fill(color(for: item))
                        .frame(width: 10, height: 10)
                    Text(item.label)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.bmcDarkBrown)
                    Spacer()
                    Text(String(format: "%.0f", item.value))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.bmcBrown)
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func color(for item: ChartData) -> Color {
        let palette: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .teal, .mint, .brown]
        return palette[abs(item.label.hashValue) % palette.count]
    }
}

struct PieSliceData: Identifiable {
    let id: UUID
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let label: String
    let value: Double
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.degrees, endAngle.degrees) }
        set {
            startAngle = .degrees(newValue.first)
            endAngle = .degrees(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - .degrees(90),
                    endAngle: endAngle - .degrees(90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct LabelLineView: View {
    let slice: PieSliceData
    
    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height * 0.9) / 2
            let midAngle = (slice.startAngle.degrees + slice.endAngle.degrees) / 2 - 90
            
            let lineEnd = CGPoint(
                x: center.x + cos(midAngle * .pi / 180) * radius * 0.9,
                y: center.y + sin(midAngle * .pi / 180) * radius * 0.9
            )
            
            let labelPoint = CGPoint(
                x: center.x + cos(midAngle * .pi / 180) * radius * 1.3,
                y: center.y + sin(midAngle * .pi / 180) * radius * 1.3
            )
            
            Path { path in
                path.move(to: center)
                path.addLine(to: lineEnd)
                path.addLine(to: labelPoint)
            }
            .stroke(slice.color, lineWidth: 1)
            
            Text(slice.label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.bmcDarkBrown)
                .position(labelPoint)
        }
    }
}

