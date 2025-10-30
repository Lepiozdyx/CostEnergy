import SwiftUI

extension View {
    func bgGradient() -> some View {
        self.background(
            LinearGradient(
                colors: [.dark1, .dark2, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
