import SwiftUI

struct PipelinesView: View {
    @State private var selectedPipeline: GasPipeline?
    @State private var showingDetails = false
    @State private var showingAddPipeline = false
    @State private var pipelines = GasPipeline.mockPipelines()
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 24) {
                headerSection
                
                GasPipeline3DView(
                    pipelines: pipelines,
                    selectedPipeline: $selectedPipeline
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BrandColors.Surface.card)
                .cornerRadius(16)
                .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
                
                controlsSection
            }
            .padding(24)
            
            if showingDetails, let pipeline = selectedPipeline {
                GasPipelineDetailsPanel(
                    pipeline: pipeline,
                    isShowing: $showingDetails
                )
                .frame(width: 350)
                .transition(.move(edge: .trailing))
            }
        }
        .onChange(of: selectedPipeline) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                showingDetails = newValue != nil
            }
        }
        .sheet(isPresented: $showingAddPipeline) {
            AddGasPipelineView { newPipeline in
                pipelines.append(newPipeline)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gas Pipeline Network")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("3D visualization of smart bolt monitoring system")
                    .font(.title3)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button("Add Pipeline") {
                    showingAddPipeline = true
                }
                .buttonStyle(.bordered)
                
                Button("Reset View") {
                    selectedPipeline = nil
                }
                .buttonStyle(.bordered)
                
                Button("Export Report") {
                    // Handle export
                }
                .buttonStyle(.borderedProminent)
                .tint(BrandColors.smartBlue)
            }
        }
    }
    
    private var controlsSection: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pipeline Status")
                    .font(.headline)
                    .foregroundStyle(BrandColors.Text.primary)
                
                HStack(spacing: 16) {
                    StatusLegendItem(color: BrandColors.techGreen, label: "Normal", count: pipelineCount(for: .normal))
                    StatusLegendItem(color: BrandColors.energyOrange, label: "Warning", count: pipelineCount(for: .warning))
                    StatusLegendItem(color: .red, label: "Critical", count: pipelineCount(for: .critical))
                    StatusLegendItem(color: .blue, label: "Maintenance", count: pipelineCount(for: .maintenance))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("Smart Bolt Overview")
                    .font(.headline)
                    .foregroundStyle(BrandColors.Text.primary)
                
                HStack(spacing: 16) {
                    SmartBoltSummary(label: "Total", count: totalSmartBolts, color: BrandColors.smartBlue)
                    SmartBoltSummary(label: "Online", count: onlineSmartBolts, color: BrandColors.techGreen)
                    SmartBoltSummary(label: "Alerts", count: alertSmartBolts, color: BrandColors.energyOrange)
                }
            }
        }
        .padding(20)
        .background(BrandColors.Surface.card)
        .cornerRadius(12)
    }
    
    private func pipelineCount(for status: PipelineStatus) -> Int {
        pipelines.filter { $0.status == status }.count
    }
    
    private var totalSmartBolts: Int {
        pipelines.reduce(0) { $0 + $1.smartBolts.count }
    }
    
    private var onlineSmartBolts: Int {
        pipelines.reduce(0) { total, pipeline in
            total + pipeline.smartBolts.filter { $0.isOnline }.count
        }
    }
    
    private var alertSmartBolts: Int {
        pipelines.reduce(0) { total, pipeline in
            total + pipeline.smartBolts.filter { $0.hasAlert }.count
        }
    }
}

struct GasPipeline3DView: View {
    let pipelines: [GasPipeline]
    @Binding var selectedPipeline: GasPipeline?
    
    var body: some View {
        GasPipeline2DView(
            pipelines: pipelines,
            selectedPipeline: $selectedPipeline
        )
    }
}

struct GasPipeline2DView: View {
    let pipelines: [GasPipeline]
    @Binding var selectedPipeline: GasPipeline?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(BrandColors.Background.secondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(BrandColors.Border.primary, lineWidth: 1)
                    )
                
                VStack(spacing: 30) {
                    ForEach(Array(pipelines.enumerated()), id: \.element.id) { index, pipeline in
                        PipelineRow(
                            pipeline: pipeline,
                            isSelected: selectedPipeline?.id == pipeline.id,
                            onTap: {
                                selectedPipeline = pipeline
                            }
                        )
                    }
                }
                .padding(40)
            }
        }
    }
}

struct PipelineRow: View {
    let pipeline: GasPipeline
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pipeline.name)
                        .font(.headline)
                        .foregroundStyle(BrandColors.Text.primary)
                    
                    Text(pipeline.location)
                        .font(.caption)
                        .foregroundStyle(BrandColors.Text.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(pipeline.status.color)
                        .frame(width: 12, height: 12)
                    
                    Text(pipeline.status.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(pipeline.status.color)
                }
            }
            
            HStack(spacing: 0) {
                Circle()
                    .fill(BrandColors.Text.tertiary)
                    .frame(width: 8, height: 8)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                pipeline.status.color.opacity(0.3),
                                pipeline.status.color.opacity(0.6),
                                pipeline.status.color.opacity(0.3)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 20)
                    .overlay(
                        Rectangle()
                            .stroke(pipeline.status.color, lineWidth: 2)
                    )
                    .overlay(
                        Group {
                            if let smartBolt = pipeline.smartBolts.first {
                                SmartBoltIndicator(bolt: smartBolt)
                            }
                        }
                    )
                
                Circle()
                    .fill(BrandColors.Text.tertiary)
                    .frame(width: 8, height: 8)
            }
            .onTapGesture {
                onTap()
            }
            
            HStack(spacing: 24) {
                MetricItem(
                    icon: "thermometer",
                    label: "Temp",
                    value: "\(String(format: "%.1f", pipeline.averageTemperature))°C",
                    color: BrandColors.energyOrange
                )
                
                MetricItem(
                    icon: "gauge",
                    label: "Pressure",
                    value: "\(String(format: "%.0f", pipeline.averagePressure)) PSI",
                    color: BrandColors.smartBlue
                )
                
                MetricItem(
                    icon: "ruler",
                    label: "Length",
                    value: "\(String(format: "%.0f", pipeline.length)) m",
                    color: BrandColors.Text.secondary
                )
                
                if let smartBolt = pipeline.smartBolts.first {
                    MetricItem(
                        icon: "battery.100",
                        label: "Battery",
                        value: "\(String(format: "%.0f", smartBolt.batteryLevel))%",
                        color: smartBolt.batteryLevel > 20 ? BrandColors.techGreen : BrandColors.energyOrange
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? BrandColors.smartBlue.opacity(0.1) : BrandColors.Surface.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? BrandColors.smartBlue : BrandColors.Border.secondary, lineWidth: isSelected ? 2 : 1)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct SmartBoltIndicator: View {
    let bolt: SmartBolt
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(bolt.status.color)
            .frame(width: 16, height: 16)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(isAnimating && bolt.hasAlert ? 1.2 : 1.0)
            .opacity(isAnimating && bolt.hasAlert ? 0.7 : 1.0)
            .onAppear {
                if bolt.hasAlert {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
    }
}

struct MetricItem: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(BrandColors.Text.tertiary)
                
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.primary)
            }
        }
    }
}

struct GasPipelineDetailsPanel: View {
    let pipeline: GasPipeline
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                
                pipelineInfoSection
                
                smartBoltsSection
                
                temperaturePressureSection
                
                Spacer()
                
                actionButtons
            }
            .padding(20)
        }
        .background(BrandColors.Surface.elevated)
        .border(BrandColors.Border.primary, width: 1)
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Pipeline Details")
                    .font(.headline)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text(pipeline.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(BrandColors.smartBlue)
            }
            
            Spacer()
            
            Button {
                isShowing = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var pipelineInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Pipeline Information")
            
            DetailRow(label: "ID", value: pipeline.id)
            DetailRow(label: "Location", value: pipeline.location)
            DetailRow(label: "Status", value: pipeline.status.displayName, valueColor: pipeline.status.color)
            DetailRow(label: "Diameter", value: "\(String(format: "%.0f", pipeline.diameter))\"")
            DetailRow(label: "Length", value: "\(String(format: "%.0f", pipeline.length)) m")
            DetailRow(label: "Max Pressure", value: "\(String(format: "%.0f", pipeline.maxPressure)) PSI")
            DetailRow(label: "Max Temperature", value: "\(String(format: "%.0f", pipeline.maxTemperature))°C")
        }
        .padding(16)
        .background(BrandColors.Surface.card)
        .cornerRadius(12)
    }
    
    private var smartBoltsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Smart Bolt")
            
            ForEach(pipeline.smartBolts) { bolt in
                SmartBoltRow(bolt: bolt)
            }
        }
        .padding(16)
        .background(BrandColors.Surface.card)
        .cornerRadius(12)
    }
    
    private var temperaturePressureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Current Readings")
            
            HStack(spacing: 16) {
                VStack {
                    Text("\(pipeline.averageTemperature, specifier: "%.1f")°C")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(BrandColors.Text.primary)
                    
                    Text("Avg Temperature")
                        .font(.caption)
                        .foregroundStyle(BrandColors.Text.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(pipeline.averagePressure, specifier: "%.0f") PSI")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(BrandColors.Text.primary)
                    
                    Text("Avg Pressure")
                        .font(.caption)
                        .foregroundStyle(BrandColors.Text.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
        .background(BrandColors.Surface.card)
        .cornerRadius(12)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button("Download Report") {
                // Handle download
            }
            .buttonStyle(.borderedProminent)
            .tint(BrandColors.smartBlue)
            .frame(maxWidth: .infinity)
            
            Button("Schedule Maintenance") {
                // Handle maintenance
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
    }
}

struct SmartBoltRow: View {
    let bolt: SmartBolt
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: bolt.status.icon)
                .foregroundStyle(bolt.status.color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(bolt.serialNumber)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text(bolt.position)
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(bolt.currentTemperature, specifier: "%.1f")°C")
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text("\(bolt.currentPressure, specifier: "%.0f") PSI")
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusLegendItem: View {
    let color: Color
    let label: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text("\(label) (\(count))")
                .font(.caption)
                .foregroundStyle(BrandColors.Text.secondary)
        }
    }
}

struct SmartBoltSummary: View {
    let label: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(BrandColors.Text.secondary)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(BrandColors.Text.primary)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var valueColor: Color = BrandColors.Text.primary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(BrandColors.Text.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(valueColor)
        }
    }
} 