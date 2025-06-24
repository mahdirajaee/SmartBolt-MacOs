import SwiftUI

struct OverviewView: View {
    @State private var refreshTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var gasPipelineData = GasPipelineOverviewData.mock()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                metricsGrid
                
                HStack(spacing: 24) {
                    pipelineStatusSection
                    smartBoltAlertsSection
                }
                
                systemHealthSection
            }
            .padding(24)
        }
        .onReceive(refreshTimer) { _ in
            refreshData()
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gas Pipeline Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("Real-time monitoring of pipeline smart bolts")
                    .font(.title3)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button("Refresh") {
                    refreshData()
                }
                .buttonStyle(.bordered)
                
                Button("Add Pipeline") {
                    // Handle add pipeline
                }
                .buttonStyle(.borderedProminent)
                .tint(BrandColors.smartBlue)
            }
        }
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            MetricCard(
                title: "Active Pipelines",
                value: "\(gasPipelineData.activePipelines)",
                change: "All operational",
                icon: "cylinder.split.1x2",
                color: BrandColors.techGreen,
                isPositive: true
            )
            
            MetricCard(
                title: "Smart Bolts Online",
                value: "\(gasPipelineData.onlineSmartBolts)/\(gasPipelineData.totalSmartBolts)",
                change: "\(String(format: "%.1f", gasPipelineData.smartBoltUptime))% uptime",
                icon: "bolt.circle",
                color: BrandColors.smartBlue,
                isPositive: gasPipelineData.smartBoltUptime > 95
            )
            
            MetricCard(
                title: "Temperature Alerts",
                value: "\(gasPipelineData.temperatureAlerts)",
                change: gasPipelineData.temperatureAlerts == 0 ? "All normal" : "Attention needed",
                icon: "thermometer.high",
                color: gasPipelineData.temperatureAlerts > 0 ? BrandColors.energyOrange : BrandColors.techGreen,
                isPositive: gasPipelineData.temperatureAlerts == 0
            )
            
            MetricCard(
                title: "Pressure Alerts",
                value: "\(gasPipelineData.pressureAlerts)",
                change: gasPipelineData.pressureAlerts == 0 ? "All normal" : "Check required",
                icon: "gauge.high",
                color: gasPipelineData.pressureAlerts > 0 ? .red : BrandColors.techGreen,
                isPositive: gasPipelineData.pressureAlerts == 0
            )
        }
    }
    
    private var pipelineStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pipeline Status")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            VStack(spacing: 12) {
                ForEach(gasPipelineData.pipelines, id: \.id) { pipeline in
                    GasPipelineStatusRow(pipeline: pipeline)
                }
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var smartBoltAlertsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Bolt Alerts")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(BrandColors.Text.primary)
            
            VStack(spacing: 12) {
                ForEach(gasPipelineData.smartBoltAlerts, id: \.id) { alert in
                    SmartBoltAlertRow(alert: alert)
                }
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var systemHealthSection: some View {
        HStack(spacing: 24) {
            SystemHealthGauge(
                title: "Avg Temperature",
                value: gasPipelineData.averageTemperature,
                maxValue: 50,
                unit: "°C",
                color: gasPipelineData.averageTemperature > 40 ? BrandColors.energyOrange : BrandColors.smartBlue
            )
            
            SystemHealthGauge(
                title: "Avg Pressure",
                value: gasPipelineData.averagePressure,
                maxValue: 1000,
                unit: "PSI",
                color: gasPipelineData.averagePressure > 800 ? BrandColors.energyOrange : BrandColors.techGreen
            )
            
            SystemHealthGauge(
                title: "Battery Health",
                value: gasPipelineData.averageBatteryLevel,
                maxValue: 100,
                unit: "%",
                color: gasPipelineData.averageBatteryLevel < 30 ? .red : BrandColors.techGreen
            )
            
            SystemHealthGauge(
                title: "Signal Strength",
                value: gasPipelineData.averageSignalStrength,
                maxValue: 100,
                unit: "%",
                color: gasPipelineData.averageSignalStrength < 50 ? BrandColors.energyOrange : BrandColors.smartBlue
            )
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func refreshData() {
        withAnimation(.easeInOut(duration: 0.3)) {
            gasPipelineData = GasPipelineOverviewData.mock()
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let change: String
    let icon: String
    let color: Color
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
                
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption)
                    .foregroundStyle(isPositive ? BrandColors.techGreen : BrandColors.energyOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(BrandColors.Text.secondary)
                
                Text(change)
                    .font(.caption)
                    .foregroundStyle(isPositive ? BrandColors.techGreen : BrandColors.energyOrange)
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct GasPipelineStatusRow: View {
    let pipeline: GasPipelineOverviewItem
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(pipeline.status.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(pipeline.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text(pipeline.location)
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(pipeline.activeBolts)/\(pipeline.totalBolts)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("smart bolt")
                    .font(.caption2)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SmartBoltAlertRow: View {
    let alert: SmartBoltAlertItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: alert.type.icon)
                .font(.subheadline)
                .foregroundStyle(alert.severity.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.message)
                    .font(.subheadline)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("\(alert.pipelineId) • \(alert.timestamp)")
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SystemHealthGauge: View {
    let title: String
    let value: Double
    let maxValue: Double
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(BrandColors.Text.primary)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: min(value / maxValue, 1.0))
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text("\(value, specifier: "%.0f")")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(BrandColors.Text.primary)
                    
                    Text(unit)
                        .font(.caption2)
                        .foregroundStyle(BrandColors.Text.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//using models from GasPipelineModels.swift 