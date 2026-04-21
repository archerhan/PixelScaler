import SwiftUI
import Observation
import UniformTypeIdentifiers

enum ScaleAlgorithm: String, CaseIterable, Identifiable {
    case nearestNeighbor = "Nearest Neighbor (最近邻)"
    case xBR = "xBRZ (极致平滑)"
    var id: Self { self }
}

struct ImageItem: Identifiable {
    let id = UUID()
    let url: URL
    let image: NSImage
}

@Observable
class ScalerViewModel {
    var inputImages: [ImageItem] = []
    var scaleFactor: Int = 2
    var selectedAlgorithm: ScaleAlgorithm = .nearestNeighbor
    
    @MainActor
    func loadImages(from urls: [URL]) {
        for url in urls {
            if !inputImages.contains(where: { $0.url == url }) {
                if let image = NSImage(contentsOf: url) {
                    inputImages.append(ImageItem(url: url, image: image))
                }
            }
        }
    }
    
    @MainActor
    func openFileSelectionPanel() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [UTType.image]
        openPanel.message = "请选择需要放大的像素图片"
        
        if openPanel.runModal() == .OK {
            loadImages(from: openPanel.urls)
        }
    }
    
    func clearImages() {
        inputImages.removeAll()
    }
    
    @MainActor
    func exportImages() {
        guard !inputImages.isEmpty else { return }
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.message = "请选择保存这些图片的文件夹"
        openPanel.prompt = "导出到此处"
        
        if openPanel.runModal() == .OK, let exportDirectory = openPanel.url {
            
            for item in inputImages {
                var resultImage: NSImage?
                switch selectedAlgorithm {
                case .nearestNeighbor:
                    resultImage = ImageProcessor.shared.scaleNearestNeighbor(image: item.image, scaleFactor: scaleFactor)
                case .xBR:
                    resultImage = ImageProcessor.shared.scaleXBR(image: item.image, scaleFactor: scaleFactor)
                }
                
                if let finalImage = resultImage,
                   let tiffData = finalImage.tiffRepresentation,
                   let bitmap = NSBitmapImageRep(data: tiffData),
                   let pngData = bitmap.representation(using: .png, properties: [:]) {
                    
                    let originalName = item.url.deletingPathExtension().lastPathComponent
                    let algName = selectedAlgorithm == .xBR ? "xBRZ" : "NN"
                    let newName = "\(originalName)_\(algName)_\(scaleFactor)x.png"
                    let saveURL = exportDirectory.appendingPathComponent(newName)
                    
                    do {
                        try pngData.write(to: saveURL)
                        print("🎉 成功导出: \(saveURL.lastPathComponent)")
                    } catch {
                        print("❌ 保存失败: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func removeImage(withId id: UUID) {
        // 使用 transition 动画让移除过程更平滑
        withAnimation {
            inputImages.removeAll { $0.id == id }
        }
    }
}
