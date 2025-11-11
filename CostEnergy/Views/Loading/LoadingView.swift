import SwiftUI

struct LoadingView: View {
    @State private var loading: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.lavender, .dark2, .dark1],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Spacer()
                
                Capsule()
                    .foregroundStyle(.black.opacity(0.4))
                    .frame(maxWidth: 150, maxHeight: 20)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(.mustard)
                            .frame(width: 148 * loading, height: 18)
                            .padding(.horizontal, 1)
                    }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.linear(duration: 4.5)) {
                loading = 1
            }
        }
    }
}

#Preview {
    LoadingView()
}
