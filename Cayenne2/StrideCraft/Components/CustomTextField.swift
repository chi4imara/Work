import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(8)
                    .lineLimit(3...6)
            } else {
                TextField(placeholder, text: $text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(8)
            }
        }
    }
}

struct CustomPicker<T: Hashable & CaseIterable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(12)
            .background(ColorTheme.cardBackground)
            .cornerRadius(8)
        }
    }
}

#Preview {
    VStack {
        CustomTextField(title: "Model", placeholder: "Enter shoe model", text: .constant(""))
        CustomTextField(title: "Comment", placeholder: "Add a comment", text: .constant(""), isMultiline: true)
    }
    .padding()
    .background(ColorTheme.primaryBackground)
}
