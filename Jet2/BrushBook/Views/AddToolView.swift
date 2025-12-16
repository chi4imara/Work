import SwiftUI

struct AddToolView: View {
    @EnvironmentObject var viewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory: ToolCategory = .brushes
    @State private var purchaseDate = Date()
    @State private var selectedCondition: ToolCondition = .good
    @State private var comment = ""
    @State private var showingDatePicker = false
    
    let toolToEdit: Tool?
    
    init(toolToEdit: Tool? = nil) {
        self.toolToEdit = toolToEdit
    }
    
    var isEditing: Bool {
        toolToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let tool = toolToEdit {
                    loadToolData(tool)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
            
            Spacer()
            
            Text(isEditing ? "Edit Tool" : "New Tool")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.top, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Tool Name") {
                TextField("e.g., Powder Brush", text: $name)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            
            FormField(title: "Category") {
                Menu {
                    ForEach(ToolCategory.allCases) { category in
                        Button(category.displayName) {
                            selectedCategory = category
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory.displayName)
                            .font(.playfairDisplay(16))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }
            
            FormField(title: "Purchase Date") {
                Button(action: { showingDatePicker.toggle() }) {
                    HStack {
                        Text(purchaseDate, formatter: DateFormatter.longDate)
                            .font(.playfairDisplay(16))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                .sheet(isPresented: $showingDatePicker) {
                    DatePickerSheet(selectedDate: $purchaseDate)
                }
            }
            
            FormField(title: "Condition") {
                VStack(spacing: 12) {
                    ForEach(ToolCondition.allCases) { condition in
                        Button(action: { selectedCondition = condition }) {
                            HStack {
                                Circle()
                                    .fill(condition.color)
                                    .frame(width: 12, height: 12)
                                
                                Text(condition.displayName)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Spacer()
                                
                                if selectedCondition == condition {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(ColorManager.primaryText)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedCondition == condition ? AnyShapeStyle(ColorManager.cardGradient) : AnyShapeStyle(Color.white.opacity(0.5)))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
            
            FormField(title: "Comment (Optional)") {
                TextField("Add notes about condition, replacement plans, etc.", text: $comment, axis: .vertical)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(3...6)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveTool) {
            Text(isEditing ? "Update Tool" : "Save Tool")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(name.isEmpty ? AnyShapeStyle(ColorManager.secondaryText) : AnyShapeStyle(ColorManager.primaryButton))
                )
                .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
        }
        .disabled(name.isEmpty)
        .padding(.top, 20)
    }
    
    private func loadToolData(_ tool: Tool) {
        name = tool.name
        selectedCategory = tool.category
        purchaseDate = tool.purchaseDate
        selectedCondition = tool.condition
        comment = tool.comment
    }
    
    private func saveTool() {
        if let existingTool = toolToEdit {
            let updatedTool = Tool(
                id: existingTool.id,
                name: name,
                category: selectedCategory,
                purchaseDate: purchaseDate,
                condition: selectedCondition,
                comment: comment
            )
            viewModel.updateTool(updatedTool)
        } else {
            let tool = Tool(
                name: name,
                category: selectedCategory,
                purchaseDate: purchaseDate,
                condition: selectedCondition,
                comment: comment
            )
            viewModel.addTool(tool)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            content
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .background(ColorManager.backgroundGradient)
            .navigationTitle("Purchase Date")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
