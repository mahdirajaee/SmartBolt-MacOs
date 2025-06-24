import SwiftUI

struct CustomLineChart: View {
    let data: [(Int, Double)]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxY = data.map { $0.1 }.max() ?? 100
            let minY = data.map { $0.1 }.min() ?? 0
            let maxX = data.map { $0.0 }.max() ?? 24
            let minX = data.map { $0.0 }.min() ?? 0
            
            ZStack {
                // Grid lines
                ForEach(0..<5) { i in
                    let y = geometry.size.height * CGFloat(i) / 4
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(BrandColors.Border.secondary, lineWidth: 0.5)
                }
                
                // Data line
                Path { path in
                    for (index, point) in data.enumerated() {
                        let x = geometry.size.width * CGFloat(point.0 - minX) / CGFloat(maxX - minX)
                        let y = geometry.size.height * (1 - CGFloat(point.1 - minY) / CGFloat(maxY - minY))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                
                // Area fill
                Path { path in
                    for (index, point) in data.enumerated() {
                        let x = geometry.size.width * CGFloat(point.0 - minX) / CGFloat(maxX - minX)
                        let y = geometry.size.height * (1 - CGFloat(point.1 - minY) / CGFloat(maxY - minY))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        
                        if index == data.count - 1 {
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                        }
                    }
                    path.closeSubpath()
                }
                .fill(color.opacity(0.2))
                
                // Data points
                ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                    let x = geometry.size.width * CGFloat(point.0 - minX) / CGFloat(maxX - minX)
                    let y = geometry.size.height * (1 - CGFloat(point.1 - minY) / CGFloat(maxY - minY))
                    
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

struct CustomBarChart: View {
    let data: [(String, Double, Color)]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map { $0.1 }.max() ?? 100
            let barWidth = geometry.size.width / CGFloat(data.count) * 0.8
            let spacing = geometry.size.width / CGFloat(data.count) * 0.2
            
            HStack(alignment: .bottom, spacing: spacing / CGFloat(data.count - 1)) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.2)
                            .frame(
                                width: barWidth,
                                height: geometry.size.height * 0.8 * CGFloat(item.1 / maxValue)
                            )
                        
                        Text(item.0)
                            .font(.caption)
                            .foregroundStyle(BrandColors.Text.secondary)
                    }
                }
            }
        }
    }
}

struct CustomPieChart: View {
    let data: [(String, Double, Color)]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.8
            let total = data.reduce(0) { $0 + $1.1 }
            
            ZStack {
                var startAngle: Double = 0
                
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    let angle = (item.1 / total) * 360
                    let endAngle = startAngle + angle
                    
                    Path { path in
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius,
                            startAngle: .degrees(startAngle - 90),
                            endAngle: .degrees(endAngle - 90),
                            clockwise: false
                        )
                        path.closeSubpath()
                    }
                    .fill(item.2)
                    .onAppear {
                        startAngle = endAngle
                    }
                }
                
                Circle()
                    .fill(BrandColors.Background.primary)
                    .frame(width: radius, height: radius)
                
                VStack {
                    Text("Resources")
                        .font(.caption)
                        .foregroundStyle(BrandColors.Text.secondary)
                    
                    Text("\(Int(total))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(BrandColors.Text.primary)
                }
            }
        }
    }
}

struct CustomMultiLineChart: View {
    let uploadData: [(Int, Double)]
    let downloadData: [(Int, Double)]
    
    var body: some View {
        GeometryReader { geometry in
            let allData = uploadData.map { $0.1 } + downloadData.map { $0.1 }
            let maxY = allData.max() ?? 100
            let minY = allData.min() ?? 0
            let maxX = max(uploadData.map { $0.0 }.max() ?? 24, downloadData.map { $0.0 }.max() ?? 24)
            let minX = min(uploadData.map { $0.0 }.min() ?? 0, downloadData.map { $0.0 }.min() ?? 0)
            
            ZStack {
                // Grid lines
                ForEach(0..<5) { i in
                    let y = geometry.size.height * CGFloat(i) / 4
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(BrandColors.Border.secondary, lineWidth: 0.5)
                }
                
                // Upload line
                Path { path in
                    for (index, point) in uploadData.enumerated() {
                        let x = geometry.size.width * CGFloat(point.0 - minX) / CGFloat(maxX - minX)
                        let y = geometry.size.height * (1 - CGFloat(point.1 - minY) / CGFloat(maxY - minY))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(BrandColors.techGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // Download line
                Path { path in
                    for (index, point) in downloadData.enumerated() {
                        let x = geometry.size.width * CGFloat(point.0 - minX) / CGFloat(maxX - minX)
                        let y = geometry.size.height * (1 - CGFloat(point.1 - minY) / CGFloat(maxY - minY))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(BrandColors.energyOrange, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // Legend
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(BrandColors.techGreen)
                                    .frame(width: 8, height: 8)
                                Text("Upload")
                                    .font(.caption)
                                    .foregroundStyle(BrandColors.Text.secondary)
                            }
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(BrandColors.energyOrange)
                                    .frame(width: 8, height: 8)
                                Text("Download")
                                    .font(.caption)
                                    .foregroundStyle(BrandColors.Text.secondary)
                            }
                        }
                        .padding(8)
                        .background(BrandColors.Surface.elevated)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
            }
        }
    }
} 