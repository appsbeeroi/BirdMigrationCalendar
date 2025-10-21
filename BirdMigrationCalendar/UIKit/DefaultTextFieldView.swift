import SwiftUI

struct DefaultTextFieldView: View {
    
    let placeholder: String
    
    @Binding var text: String
    
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.bmcGray))
            .font(.poller(with: 17))
            .foregroundStyle(.bmcDarkBrown)
            
            if text != "" {
                Button {
                    text = ""
                    isFocused = false 
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.bmcGray)
                }
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(20)
    }
}
