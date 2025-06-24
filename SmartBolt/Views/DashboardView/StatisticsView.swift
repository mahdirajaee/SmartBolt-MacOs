import SwiftUI

struct StatisticsView: View {
    @State private var selectedTimeRange: TimeRange = .day
    @State private var statisticsData = GasPipelineStats.mock()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                timeRangeSelector
                
                HStack(spacing: 24) {
                    temperatureChart
                    pressureChart
                }
                
                HStack(spacing: 24) {
                    alertSummaryChart
                    performanceMetricsChart
                }
                
                pipelineOverviewTable
            }
            .padding(24)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gas Pipeline Analytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("Smart bolt monitoring and performance metrics")
                    .font(.title3)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button("Export Report") {
                    // Handle export
                }
                .buttonStyle(.bordered)
                
                Button("Configure Alerts") {
                    // Handle alerts configuration
                }
                .buttonStyle(.borderedProminent)
                .tint(BrandColors.smartBlue)
            }
        }
    }
    
    private var timeRangeSelector: some View {
        HStack {
            Text("Time Range:")
                .font(.headline)
                .foregroundStyle(BrandColors.Text.primary)
            
            Spacer()
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 300)
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(12)
    }
    
    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Temperature Trends")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            CustomMultiTemperatureChart(
                temperatureData: groupTemperatureByPipeline()
            )
            .frame(height: 200)
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var pressureChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pressure Monitoring")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            CustomMultiPressureChart(
                pressureData: groupPressureByPipeline()
            )
            .frame(height: 200)
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var alertSummaryChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Alert Summary")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            CustomBarChart(
                data: statisticsData.alertSummary.map { 
                    ($0.type.rawValue, Double($0.count), $0.severity.color) 
                }
            )
            .frame(height: 200)
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var performanceMetricsChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Metrics")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            VStack(spacing: 12) {
                ForEach(statisticsData.performanceMetrics, id: \.name) { metric in
                    PerformanceMetricRow(metric: metric)
                }
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var pipelineOverviewTable: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pipeline Overview")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                // Header
                GridRow {
                    Text("Pipeline")
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                        .gridColumnAlignment(.leading)
                    
                    Text("Avg Temp")
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                        .gridColumnAlignment(.center)
                    
                    Text("Avg Pressure")
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                        .gridColumnAlignment(.center)
                    
                    Text("Smart Bolts")
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                        .gridColumnAlignment(.center)
                    
                    Text("Efficiency")
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                        .gridColumnAlignment(.trailing)
                }
                .padding(.bottom, 8)
                
                Divider()
                
                ForEach(statisticsData.pipelineOverview, id: \.pipelineId) { pipeline in
                    GridRow {
                        Text(pipeline.name)
                            .foregroundStyle(BrandColors.Text.primary)
                            .gridColumnAlignment(.leading)
                        
                        Text("\(pipeline.avgTemperature, specifier: "%.1f")°C")
                            .foregroundStyle(BrandColors.Text.secondary)
                            .gridColumnAlignment(.center)
                        
                        Text("\(pipeline.avgPressure, specifier: "%.0f") PSI")
                            .foregroundStyle(BrandColors.Text.secondary)
                            .gridColumnAlignment(.center)
                        
                        Text("\(pipeline.activeBolts)/\(pipeline.totalBolts)")
                            .foregroundStyle(BrandColors.Text.secondary)
                            .gridColumnAlignment(.center)
                        
                        Text("\(pipeline.efficiency, specifier: "%.1f")%")
                            .foregroundStyle(pipeline.efficiency > 90 ? BrandColors.techGreen : BrandColors.energyOrange)
                            .gridColumnAlignment(.trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func groupTemperatureByPipeline() -> [String: [(Int, Double)]] {
        var grouped: [String: [(Int, Double)]] = [:]
        
        for reading in statisticsData.temperatureHistory {
            let hour = Calendar.current.component(.hour, from: reading.timestamp)
            if grouped[reading.pipelineId] == nil {
                grouped[reading.pipelineId] = []
            }
            grouped[reading.pipelineId]?.append((hour, reading.temperature))
        }
        
        return grouped
    }
    
    private func groupPressureByPipeline() -> [String: [(Int, Double)]] {
        var grouped: [String: [(Int, Double)]] = [:]
        
        for reading in statisticsData.pressureHistory {
            let hour = Calendar.current.component(.hour, from: reading.timestamp)
            if grouped[reading.pipelineId] == nil {
                grouped[reading.pipelineId] = []
            }
            grouped[reading.pipelineId]?.append((hour, reading.pressure))
        }
        
        return grouped
    }
}

struct PerformanceMetricRow: View {
    let metric: PerformanceMetric
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(metric.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("\(metric.value, specifier: "%.1f") \(metric.unit)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.smartBlue)
            }
            
            Spacer()
            
            Image(systemName: metric.trend.icon)
                .font(.title3)
                .foregroundStyle(metric.trend.color)
        }
        .padding(.vertical, 8)
    }
}

struct CustomMultiTemperatureChart: View {
    let temperatureData: [String: [(Int, Double)]]
    
    var body: some View {
        GeometryReader { geometry in
            let allTemps = temperatureData.values.flatMap { $0.map { $0.1 } }
            let maxTemp = allTemps.max() ?? 50
            let minTemp = allTemps.min() ?? 0
            let colors = [BrandColors.smartBlue, BrandColors.techGreen, BrandColors.energyOrange, Color.purple]
            
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
                
                // Temperature lines for each pipeline
                ForEach(Array(temperatureData.keys.enumerated()), id: \.element) { index, pipelineId in
                    if let data = temperatureData[pipelineId] {
                        Path { path in
                            let sortedData = data.sorted { $0.0 < $1.0 }
                            for (pointIndex, point) in sortedData.enumerated() {
                                let x = geometry.size.width * CGFloat(point.0) / 24
                                let y = geometry.size.height * (1 - CGFloat(point.1 - minTemp) / CGFloat(maxTemp - minTemp))
                                
                                if pointIndex == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(colors[index % colors.count], style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    }
                }
                
                // Legend
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(Array(temperatureData.keys.enumerated()), id: \.element) { index, pipelineId in
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(colors[index % colors.count])
                                        .frame(width: 8, height: 8)
                                    Text(pipelineId)
                                        .font(.caption2)
                                        .foregroundStyle(BrandColors.Text.secondary)
                                }
                            }
                        }
                        .padding(8)
                        .background(BrandColors.Surface.elevated)
                        .cornerRadius(6)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct CustomMultiPressureChart: View {
    let pressureData: [String: [(Int, Double)]]
    
    var body: some View {
        GeometryReader { geometry in
            let allPressures = pressureData.values.flatMap { $0.map { $0.1 } }
            let maxPressure = allPressures.max() ?? 1000
            let minPressure = allPressures.min() ?? 0
            let colors = [BrandColors.smartBlue, BrandColors.techGreen, BrandColors.energyOrange, Color.purple]
            
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
                
                // Pressure lines for each pipeline
                ForEach(Array(pressureData.keys.enumerated()), id: \.element) { index, pipelineId in
                    if let data = pressureData[pipelineId] {
                        Path { path in
                            let sortedData = data.sorted { $0.0 < $1.0 }
                            for (pointIndex, point) in sortedData.enumerated() {
                                let x = geometry.size.width * CGFloat(point.0) / 24
                                let y = geometry.size.height * (1 - CGFloat(point.1 - minPressure) / CGFloat(maxPressure - minPressure))
                                
                                if pointIndex == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(colors[index % colors.count], style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    }
                }
                
                // Legend
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(Array(pressureData.keys.enumerated()), id: \.element) { index, pipelineId in
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(colors[index % colors.count])
                                        .frame(width: 8, height: 8)
                                    Text(pipelineId)
                                        .font(.caption2)
                                        .foregroundStyle(BrandColors.Text.secondary)
                                }
                            }
                        }
                        .padding(8)
                        .background(BrandColors.Surface.elevated)
                        .cornerRadius(6)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

//using models from GasPipelineModels.swift 