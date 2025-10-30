import SwiftUI

struct DevicesView: View {
    @StateObject private var viewModel = DevicesViewModel()
    @State private var showingAddDevice = false
    @State private var deviceToEdit: Device?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.devices.isEmpty {
                    emptyState
                } else {
                    devicesList
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addButton
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Devices")
            .sheet(isPresented: $showingAddDevice) {
                AddDeviceView(viewModel: viewModel, deviceToEdit: deviceToEdit)
                    .onDisappear {
                        deviceToEdit = nil
                    }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.slash.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Devices Added")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first device to start tracking energy consumption")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var devicesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.devices) { device in
                    DeviceCard(
                        device: device,
                        onEdit: {
                            deviceToEdit = device
                            showingAddDevice = true
                        },
                        onDelete: {
                            viewModel.deleteDevice(device)
                        }
                    )
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .padding()
            .animation(.easeInOut, value: viewModel.devices.count)
        }
    }
    
    private var addButton: some View {
        Button {
            showingAddDevice = true
        } label: {
            Image(systemName: SFSymbols.add)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
        }
    }
}

#Preview {
    DevicesView()
}

