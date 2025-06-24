import SwiftUI
import Foundation

// MARK: - Gas Pipeline Models

struct GasPipeline: Identifiable, Equatable {
    let id: String
    let name: String
    let location: String
    let installationDate: Date
    let maxPressure: Double
    let maxTemperature: Double
    let diameter: Double // in inches
    let length: Double // in meters
    let smartBolts: [SmartBolt]
    let status: PipelineStatus
    
    var averageTemperature: Double {
        guard !smartBolts.isEmpty else { return 0 }
        return smartBolts.reduce(0) { $0 + $1.currentTemperature } / Double(smartBolts.count)
    }
    
    var averagePressure: Double {
        guard !smartBolts.isEmpty else { return 0 }
        return smartBolts.reduce(0) { $0 + $1.currentPressure } / Double(smartBolts.count)
    }
    
    var activeBoltsCount: Int {
        smartBolts.filter { $0.isOnline }.count
    }
    
    var alertCount: Int {
        smartBolts.filter { $0.hasAlert }.count
    }
}

struct SmartBolt: Identifiable, Equatable {
    let id: String
    let serialNumber: String
    let position: String // Position along the pipeline
    let installationDate: Date
    let currentTemperature: Double // in Celsius
    let currentPressure: Double // in PSI
    let batteryLevel: Double // 0-100%
    let lastUpdate: Date
    let isOnline: Bool
    let hasAlert: Bool
    let alertMessage: String?
    
    var status: SmartBoltStatus {
        if !isOnline { return .offline }
        if hasAlert { return .alert }
        if batteryLevel < 20 { return .lowBattery }
        return .normal
    }
}

enum SmartBoltStatus {
    case normal, alert, lowBattery, offline
    
    var color: Color {
        switch self {
        case .normal: return BrandColors.techGreen
        case .alert: return .red
        case .lowBattery: return BrandColors.energyOrange
        case .offline: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .alert: return "exclamationmark.triangle.fill"
        case .lowBattery: return "battery.25"
        case .offline: return "wifi.slash"
        }
    }
}

enum PipelineStatus: String, CaseIterable {
    case normal = "normal"
    case warning = "warning"
    case critical = "critical"
    case maintenance = "maintenance"
    
    var color: Color {
        switch self {
        case .normal: return BrandColors.techGreen
        case .warning: return BrandColors.energyOrange
        case .critical: return .red
        case .maintenance: return .blue
        }
    }
    
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .warning: return "Warning"
        case .critical: return "Critical"
        case .maintenance: return "Maintenance"
        }
    }
}

// MARK: - Statistics Models

struct GasPipelineStats {
    let temperatureHistory: [TemperatureReading]
    let pressureHistory: [PressureReading]
    let pipelineOverview: [PipelineOverviewData]
    let smartBoltMetrics: [SmartBoltMetric]
    let alertSummary: [AlertSummaryData]
    let performanceMetrics: [PerformanceMetric]
}

struct TemperatureReading {
    let timestamp: Date
    let pipelineId: String
    let temperature: Double
    let isAlert: Bool
}

struct PressureReading {
    let timestamp: Date
    let pipelineId: String
    let pressure: Double
    let isAlert: Bool
}

struct PipelineOverviewData {
    let pipelineId: String
    let name: String
    let avgTemperature: Double
    let avgPressure: Double
    let activeBolts: Int
    let totalBolts: Int
    let efficiency: Double
}

struct SmartBoltMetric {
    let boltId: String
    let pipelineId: String
    let temperature: Double
    let pressure: Double
    let batteryLevel: Double
    let signalStrength: Double
}

struct AlertSummaryData {
    let type: AlertType
    let count: Int
    let severity: AlertSeverity
}

enum AlertType: String, CaseIterable {
    case highTemperature = "High Temperature"
    case highPressure = "High Pressure"
    case lowBattery = "Low Battery"
    case offline = "Device Offline"
    case maintenance = "Maintenance Due"
    
    var icon: String {
        switch self {
        case .highTemperature: return "thermometer.high"
        case .highPressure: return "gauge.high"
        case .lowBattery: return "battery.25"
        case .offline: return "wifi.slash"
        case .maintenance: return "wrench.and.screwdriver"
        }
    }
}

enum AlertSeverity {
    case info, warning, critical
    
    var color: Color {
        switch self {
        case .info: return BrandColors.smartBlue
        case .warning: return BrandColors.energyOrange
        case .critical: return .red
        }
    }
}

struct PerformanceMetric {
    let name: String
    let value: Double
    let unit: String
    let trend: TrendDirection
}

enum TrendDirection {
    case up, down, stable
    
    var icon: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .stable: return "arrow.right"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return BrandColors.techGreen
        case .down: return .red
        case .stable: return BrandColors.energyOrange
        }
    }
}

enum TimeRange: String, CaseIterable {
    case hour = "1H"
    case day = "24H" 
    case week = "7D"
    case month = "30D"
}

// MARK: - Mock Data

extension GasPipeline {
    static func mockPipelines() -> [GasPipeline] {
        [
            GasPipeline(
                id: "GP001",
                name: "Main Distribution Line",
                location: "North Sector A",
                installationDate: Date().addingTimeInterval(-86400 * 365), // 1 year ago
                maxPressure: 1000.0,
                maxTemperature: 80.0,
                diameter: 24.0,
                length: 1500.0,
                smartBolts: SmartBolt.mockBoltsForPipeline("GP001"),
                status: .normal
            ),
            GasPipeline(
                id: "GP002",
                name: "Emergency Backup Line",
                location: "South Sector B",
                installationDate: Date().addingTimeInterval(-86400 * 180), // 6 months ago
                maxPressure: 800.0,
                maxTemperature: 75.0,
                diameter: 18.0,
                length: 800.0,
                smartBolts: SmartBolt.mockBoltsForPipeline("GP002"),
                status: .warning
            ),
            GasPipeline(
                id: "GP003",
                name: "Industrial Feed Line",
                location: "East Sector C",
                installationDate: Date().addingTimeInterval(-86400 * 90), // 3 months ago
                maxPressure: 1200.0,
                maxTemperature: 85.0,
                diameter: 30.0,
                length: 2000.0,
                smartBolts: SmartBolt.mockBoltsForPipeline("GP003"),
                status: .critical
            ),
            GasPipeline(
                id: "GP004",
                name: "Residential Distribution",
                location: "West Sector D",
                installationDate: Date().addingTimeInterval(-86400 * 60), // 2 months ago
                maxPressure: 600.0,
                maxTemperature: 70.0,
                diameter: 12.0,
                length: 1200.0,
                smartBolts: SmartBolt.mockBoltsForPipeline("GP004"),
                status: .normal
            )
        ]
    }
}

extension SmartBolt {
    static func mockBoltsForPipeline(_ pipelineId: String) -> [SmartBolt] {
        let hasAlert = Double.random(in: 0...1) < 0.2 // 20% chance of alert
        let isOnline = Double.random(in: 0...1) < 0.95 // 95% online rate
        
        return [SmartBolt(
            id: "\(pipelineId)-SB01",
            serialNumber: "SB-\(Int.random(in: 10000...99999))",
            position: "Center",
            installationDate: Date().addingTimeInterval(-86400 * Double.random(in: 30...365)),
            currentTemperature: Double.random(in: 15...45),
            currentPressure: Double.random(in: 200...800),
            batteryLevel: Double.random(in: 15...100),
            lastUpdate: Date().addingTimeInterval(-Double.random(in: 0...300)), // Last 5 minutes
            isOnline: isOnline,
            hasAlert: hasAlert && isOnline,
            alertMessage: hasAlert && isOnline ? generateAlertMessage() : nil
        )]
    }
    
    private static func generateAlertMessage() -> String {
        let messages = [
            "Temperature exceeding safe limits",
            "Pressure reading above threshold",
            "Low battery warning",
            "Signal strength degraded",
            "Maintenance required"
        ]
        return messages.randomElement() ?? "System alert"
    }
}

extension GasPipelineStats {
    static func mock() -> GasPipelineStats {
        let pipelines = GasPipeline.mockPipelines()
        
        return GasPipelineStats(
            temperatureHistory: generateTemperatureHistory(),
            pressureHistory: generatePressureHistory(),
            pipelineOverview: pipelines.map { pipeline in
                PipelineOverviewData(
                    pipelineId: pipeline.id,
                    name: pipeline.name,
                    avgTemperature: pipeline.averageTemperature,
                    avgPressure: pipeline.averagePressure,
                    activeBolts: pipeline.activeBoltsCount,
                    totalBolts: pipeline.smartBolts.count,
                    efficiency: Double.random(in: 85...98)
                )
            },
            smartBoltMetrics: generateSmartBoltMetrics(pipelines),
            alertSummary: [
                AlertSummaryData(type: .highTemperature, count: 3, severity: .warning),
                AlertSummaryData(type: .highPressure, count: 1, severity: .critical),
                AlertSummaryData(type: .lowBattery, count: 5, severity: .info),
                AlertSummaryData(type: .offline, count: 2, severity: .warning)
            ],
            performanceMetrics: [
                PerformanceMetric(name: "System Efficiency", value: 94.2, unit: "%", trend: .up),
                PerformanceMetric(name: "Average Response Time", value: 0.8, unit: "s", trend: .down),
                PerformanceMetric(name: "Data Accuracy", value: 99.1, unit: "%", trend: .stable),
                PerformanceMetric(name: "Uptime", value: 99.7, unit: "%", trend: .up)
            ]
        )
    }
    
    private static func generateTemperatureHistory() -> [TemperatureReading] {
        let pipelines = ["GP001", "GP002", "GP003", "GP004"]
        var readings: [TemperatureReading] = []
        
        for hour in 0..<24 {
            for pipelineId in pipelines {
                let temp = Double.random(in: 15...45)
                readings.append(TemperatureReading(
                    timestamp: Date().addingTimeInterval(-Double(hour) * 3600),
                    pipelineId: pipelineId,
                    temperature: temp,
                    isAlert: temp > 40
                ))
            }
        }
        
        return readings
    }
    
    private static func generatePressureHistory() -> [PressureReading] {
        let pipelines = ["GP001", "GP002", "GP003", "GP004"]
        var readings: [PressureReading] = []
        
        for hour in 0..<24 {
            for pipelineId in pipelines {
                let pressure = Double.random(in: 200...800)
                readings.append(PressureReading(
                    timestamp: Date().addingTimeInterval(-Double(hour) * 3600),
                    pipelineId: pipelineId,
                    pressure: pressure,
                    isAlert: pressure > 750
                ))
            }
        }
        
        return readings
    }
    
    private static func generateSmartBoltMetrics(_ pipelines: [GasPipeline]) -> [SmartBoltMetric] {
        var metrics: [SmartBoltMetric] = []
        
        for pipeline in pipelines {
            for bolt in pipeline.smartBolts {
                metrics.append(SmartBoltMetric(
                    boltId: bolt.id,
                    pipelineId: pipeline.id,
                    temperature: bolt.currentTemperature,
                    pressure: bolt.currentPressure,
                    batteryLevel: bolt.batteryLevel,
                    signalStrength: Double.random(in: 60...100)
                ))
            }
        }
        
        return metrics
    }
}

struct SmartBoltAlertItem {
    let id: String
    let pipelineId: String
    let message: String
    let type: AlertType
    let severity: AlertSeverity
    let timestamp: String
}

struct GasPipelineOverviewData {
    let activePipelines: Int
    let totalSmartBolts: Int
    let onlineSmartBolts: Int
    let temperatureAlerts: Int
    let pressureAlerts: Int
    let smartBoltUptime: Double
    let averageTemperature: Double
    let averagePressure: Double
    let averageBatteryLevel: Double
    let averageSignalStrength: Double
    let pipelines: [GasPipelineOverviewItem]
    let smartBoltAlerts: [SmartBoltAlertItem]
    
    static func mock() -> GasPipelineOverviewData {
        GasPipelineOverviewData(
            activePipelines: 4,
            totalSmartBolts: 4,
            onlineSmartBolts: Int.random(in: 3...4),
            temperatureAlerts: Int.random(in: 0...3),
            pressureAlerts: Int.random(in: 0...2),
            smartBoltUptime: Double.random(in: 95...99.5),
            averageTemperature: Double.random(in: 25...35),
            averagePressure: Double.random(in: 400...600),
            averageBatteryLevel: Double.random(in: 70...95),
            averageSignalStrength: Double.random(in: 80...95),
            pipelines: [
                GasPipelineOverviewItem(id: "GP001", name: "Main Distribution Line", location: "North Sector A", status: .normal, activeBolts: 1, totalBolts: 1),
                GasPipelineOverviewItem(id: "GP002", name: "Emergency Backup Line", location: "South Sector B", status: .warning, activeBolts: 1, totalBolts: 1),
                GasPipelineOverviewItem(id: "GP003", name: "Industrial Feed Line", location: "East Sector C", status: .critical, activeBolts: 1, totalBolts: 1),
                GasPipelineOverviewItem(id: "GP004", name: "Residential Distribution", location: "West Sector D", status: .normal, activeBolts: 1, totalBolts: 1)
            ],
            smartBoltAlerts: [
                SmartBoltAlertItem(id: "1", pipelineId: "GP002", message: "High temperature detected", type: .highTemperature, severity: .warning, timestamp: "2 min ago"),
                SmartBoltAlertItem(id: "2", pipelineId: "GP003", message: "Pressure above threshold", type: .highPressure, severity: .critical, timestamp: "5 min ago"),
                SmartBoltAlertItem(id: "3", pipelineId: "GP001", message: "Low battery warning", type: .lowBattery, severity: .info, timestamp: "10 min ago")
            ]
        )
    }
}

struct GasPipelineOverviewItem {
    let id: String
    let name: String
    let location: String
    let status: PipelineStatus
    let activeBolts: Int
    let totalBolts: Int
} 