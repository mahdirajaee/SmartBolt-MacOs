import SwiftUI

struct AddGasPipelineView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var diameter: Double = 12.0
    @State private var length: Double = 1000.0
    @State private var maxPressure: Double = 800.0
    @State private var maxTemperature: Double = 75.0

    
    let onSave: (GasPipeline) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Pipeline Information") {
                    TextField("Pipeline Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section("Technical Specifications") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diameter: \(diameter, specifier: "%.0f") inches")
                            .font(.subheadline)
                        Slider(value: $diameter, in: 6...36, step: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Length: \(length, specifier: "%.0f") meters")
                            .font(.subheadline)
                        Slider(value: $length, in: 100...5000, step: 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Max Pressure: \(maxPressure, specifier: "%.0f") PSI")
                            .font(.subheadline)
                        Slider(value: $maxPressure, in: 200...1500, step: 50)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Max Temperature: \(maxTemperature, specifier: "%.0f")°C")
                            .font(.subheadline)
                        Slider(value: $maxTemperature, in: 40...100, step: 5)
                    }
                }
                
                Section("Smart Bolt Configuration") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Smart Bolt: 1 per pipeline")
                            .font(.subheadline)
                            .foregroundStyle(BrandColors.Text.primary)
                        
                        Text("Each pipeline will have one smart bolt for monitoring")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add Gas Pipeline")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePipeline()
                    }
                    .disabled(name.isEmpty || location.isEmpty)
                }
            }
        }
        .frame(width: 600, height: 700)
    }
    
    private func savePipeline() {
        let newPipeline = GasPipeline(
            id: "GP\(String(format: "%03d", Int.random(in: 100...999)))",
            name: name,
            location: location,
            installationDate: Date(),
            maxPressure: maxPressure,
            maxTemperature: maxTemperature,
            diameter: diameter,
            length: length,
            smartBolts: generateSmartBolts(),
            status: .normal
        )
        
        onSave(newPipeline)
        dismiss()
    }
    
    private func generateSmartBolts() -> [SmartBolt] {
        [SmartBolt(
            id: "NEW-SB01",
            serialNumber: "SB-\(Int.random(in: 10000...99999))",
            position: "KM \(String(format: "%.1f", length / 2000.0))", // Position at pipeline center
            installationDate: Date(),
            currentTemperature: Double.random(in: 15...25),
            currentPressure: Double.random(in: 200...400),
            batteryLevel: Double.random(in: 85...100),
            lastUpdate: Date(),
            isOnline: true,
            hasAlert: false,
            alertMessage: nil
        )]
    }
} 