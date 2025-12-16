import SwiftUI

struct TemplatesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddFromTemplate = false
    @State private var selectedTemplate: ProcedureTemplate?
    
    private let defaultTemplates: [ProcedureTemplate] = [
        ProcedureTemplate(name: "Face Mask", category: .skin, defaultProducts: "Hydrating mask, Toner", defaultComment: "Weekly skincare routine"),
        ProcedureTemplate(name: "Manicure", category: .nails, defaultProducts: "Nail polish, Base coat, Top coat", defaultComment: "Regular nail care"),
        ProcedureTemplate(name: "Hair Mask", category: .hair, defaultProducts: "Deep conditioner, Hair oil", defaultComment: "Weekly hair treatment"),
        ProcedureTemplate(name: "Facial Cleansing", category: .skin, defaultProducts: "Cleanser, Exfoliant", defaultComment: "Daily skincare"),
        ProcedureTemplate(name: "Pedicure", category: .nails, defaultProducts: "Nail polish, Foot cream", defaultComment: "Foot care routine"),
        ProcedureTemplate(name: "Hair Coloring", category: .hair, defaultProducts: "Hair dye, Developer", defaultComment: "Hair coloring session"),
        ProcedureTemplate(name: "Exfoliation", category: .skin, defaultProducts: "Scrub, Moisturizer", defaultComment: "Weekly exfoliation"),
        ProcedureTemplate(name: "Nail Art", category: .nails, defaultProducts: "Nail art polish, Brushes", defaultComment: "Creative nail design")
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Templates")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(defaultTemplates) { template in
                            TemplateCardView(template: template) {
                                selectedTemplate = template
                                showingAddFromTemplate = true
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .sheet(item: $selectedTemplate) { template in
            AddProcedureView(template: template)
        }
    }
}

struct TemplateCardView: View {
    let template: ProcedureTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: template.category.icon)
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 50, height: 50)
                    .background(AppColors.accentYellow.opacity(0.2))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(template.name)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(template.category.rawValue)
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    if !template.defaultProducts.isEmpty {
                        Text(template.defaultProducts)
                            .font(.custom("PlayfairDisplay-Regular", size: 12))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TemplatesView()
        .environmentObject(DataManager())
}

