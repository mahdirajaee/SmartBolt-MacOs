import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSidebar = true
    
    var body: some View {
        NavigationSplitView(sidebar: {
            DashboardSidebar()
                .environmentObject(appState)
        }, detail: {
            DashboardMainContent()
                .environmentObject(appState)
        })
        .navigationSplitViewStyle(.balanced)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BrandColors.Background.primary)
    }
}

struct DashboardSidebar: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            sidebarHeader
            
            VStack(spacing: 8) {
                ForEach(DashboardSection.allCases, id: \.self) { section in
                    SidebarItem(
                        section: section,
                        isSelected: appState.selectedDashboardSection == section
                    ) {
                        appState.selectDashboardSection(section)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            
            Spacer()
            
            sidebarFooter
        }
        .frame(minWidth: 220)
        .background(BrandColors.Surface.elevated)
    }
    
    private var sidebarHeader: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image("PolitectoLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 125)
                
                HStack(spacing: 8) {
                    Image(systemName: "bolt.circle.fill")
                        .font(.caption)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [BrandColors.smartBlue, BrandColors.techGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SmartBolt")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(BrandColors.Text.primary)
                        
                        Text("PoliTO Research")
                            .font(.caption2)
                            .foregroundStyle(BrandColors.Text.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            Divider()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var sidebarFooter: some View {
        VStack(spacing: 12) {
            Divider()
            
            HStack(spacing: 8) {
                Circle()
                    .fill(BrandColors.techGreen)
                    .frame(width: 8, height: 8)
                
                Text("System Online")
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.secondary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Button(action: { appState.logout() }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Sign Out")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            .foregroundStyle(BrandColors.Text.secondary)
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
    }
}

struct SidebarItem: View {
    let section: DashboardSection
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isSelected ? .white : BrandColors.Text.secondary)
                    .frame(width: 20)
                
                Text(section.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .medium : .regular)
                    .foregroundStyle(isSelected ? .white : BrandColors.Text.primary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? BrandColors.smartBlue : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

struct DashboardMainContent: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            switch appState.selectedDashboardSection {
            case .overview:
                OverviewView()
            case .pipelines:
                PipelinesView()
            case .statistics:
                StatisticsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BrandColors.Background.primary)
    }
} 