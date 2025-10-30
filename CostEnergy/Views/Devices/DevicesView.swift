import SwiftUI

struct DevicesView: View {
    @StateObject private var viewModel = DevicesViewModel()
    @State private var showingAddDevice = false
    @State private var deviceToEdit: Device?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                
                if viewModel.devices.isEmpty {
                    emptyState
                } else {
                    devicesList
                }
            }
            .bgGradient()
            .sheet(isPresented: $showingAddDevice) {
                AddDeviceView(viewModel: viewModel, deviceToEdit: deviceToEdit)
                    .onDisappear {
                        deviceToEdit = nil
                    }
            }
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Devices")
                    .font(.system(size: 24))
                    .foregroundStyle(.mustard)
                
                Text("\(viewModel.devices.count) \(viewModel.devices.count == 1 ? "device" : "devices")")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            Button {
                showingAddDevice = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: SFSymbols.add)
                        .resizable()
                        .frame(width: 12, height: 12)
                    
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.mustard)
                )
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 8)
    }
    
    private var emptyState: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.mustard.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: SFSymbols.devices)
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundStyle(.mustard)
                }
                
                Text("No devices added")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text("Create an energy passport for your home by adding appliances to track usage")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button {
                    showingAddDevice = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: SFSymbols.add)
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("Add first device")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.mustard)
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                    )
            )
            .padding()
            
            Spacer()
            Spacer()
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
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .animation(.easeInOut(duration: 0.3), value: viewModel.devices.count)
        }
    }
}

#Preview {
    DevicesView()
}

