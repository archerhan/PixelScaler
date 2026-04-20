import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var viewModel = ScalerViewModel()
    @State private var isDropTargeted = false
    
    // 网格布局设定
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 16)
    ]
    
    var body: some View {
        NavigationSplitView {
            // ====== 左侧：主视图（拖拽、预览网格） ======
            ZStack {
                // 背景变色反馈
                if isDropTargeted {
                    Color.accentColor.opacity(0.1).ignoresSafeArea()
                } else {
                    Color(nsColor: .windowBackgroundColor).ignoresSafeArea()
                }
                
                if viewModel.inputImages.isEmpty {
                    // --- 状态 1：空状态 ---
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)
                        
                        Text("将图片拖拽到这里")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("或")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            viewModel.openFileSelectionPanel()
                        }) {
                            Text("选择文件...")
                        }
                    }
                } else {
                    // --- 状态 2：多图网格展示状态 ---
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.inputImages) { item in
                                VStack {
                                    Image(nsImage: item.image)
                                        .resizable()
                                        .interpolation(.none) // 预览时保持像素感
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .background(Color(nsColor: .controlBackgroundColor))
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                                    
                                    Text(item.url.lastPathComponent)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // 拖拽边框高亮
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isDropTargeted ? Color.accentColor : Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: 2, dash: isDropTargeted ? [] : [8]))
                    .padding()
            }
            .frame(minWidth: 400, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            // 核心功能：接收拖拽的文件 URLs (支持多选)
            .dropDestination(for: URL.self) { items, location in
                viewModel.loadImages(from: items)
                return true
            } isTargeted: { targeted in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isDropTargeted = targeted
                }
            }
            
        } detail: {
            // ====== 右侧：控制面板 ======
            VStack(alignment: .leading, spacing: 24) {
                Text("处理设置")
                    .font(.headline)
                
                Picker("算法", selection: $viewModel.selectedAlgorithm) {
                    ForEach(ScaleAlgorithm.allCases) { algorithm in
                        Text(algorithm.rawValue).tag(algorithm)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("放大倍数", selection: $viewModel.scaleFactor) {
                    Text("2x").tag(2)
                    Text("3x").tag(3)
                    Text("4x").tag(4)
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                // 辅助信息
                if !viewModel.inputImages.isEmpty {
                    HStack {
                        Text("已选中 \(viewModel.inputImages.count) 张图片")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button("清空") {
                            withAnimation {
                                viewModel.clearImages()
                            }
                        }
                        .buttonStyle(.link)
                        .font(.caption)
                    }
                }
                
                // 导出按钮
                Button(action: {
                    viewModel.exportImages()
                }) {
                    Text(viewModel.inputImages.count > 1 ? "批量导出" : "导出图片")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.inputImages.isEmpty)
            }
            .padding()
            .frame(minWidth: 250, maxWidth: 300)
        }
        .navigationTitle("Pixel Scaler")
        // 如果想要工具栏上也有选择文件按钮，可以取消注释下面代码
        /*
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { viewModel.openFileSelectionPanel() }) {
                    Label("添加图片", systemImage: "plus")
                }
            }
        }
        */
    }
}
