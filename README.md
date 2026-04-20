# Pixel Scaler for macOS 👾

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)
![Platform: macOS](https://img.shields.io/badge/Platform-macOS%2014.0+-lightgrey.svg)
![Language: Swift | C++](https://img.shields.io/badge/Language-Swift%20|%20C++-orange.svg)

> A lightning-fast, native macOS utility for losslessly upscaling pixel art. Powered by the industry-leading xBRZ engine.

![App Screenshot/Hero Image](path/to/your/hero-image.png)  
*(Replace this with a screenshot of your main app UI)*

## ✨ Features

* **🚀 100% Native macOS Experience:** Built from the ground up with SwiftUI. No Electron, no web views. Enjoy extreme performance, minimal memory footprint, and a beautiful native UI.
* **🧠 Advanced xBRZ Engine:** Integrates the state-of-the-art C++ xBRZ (Scale by Rules) algorithm to intelligently smooth pixel edges, creating crisp, vector-like results without the blurriness of traditional bilinear scaling.
* **📦 Lightning-Fast Batch Processing:** Drag and drop dozens of images into the app and export them all at once to a selected directory.
* **🔍 Multiple Scaling Modes:** * **xBRZ:** Best for characters, sprites, and complex pixel art.
  * **Nearest Neighbor:** Perfect for retaining the original blocky, retro aesthetic without any color blending.
* **📏 Flexible Scale Factors:** Supports 2x, 3x, and 4x magnification.

## 🖼️ See the Difference

![Comparison Image: Original vs Nearest Neighbor vs xBRZ](path/to/your/comparison-image.png)  
*(Replace this with a side-by-side comparison of a small pixel art character scaled with Nearest Neighbor vs xBRZ)*

## 🛠 Installation & Build Instructions

Since this app utilizes a C++ backend, it is distributed as source code for compilation. 

### Prerequisites

* macOS 14.0 (Sonoma) or later
* Xcode 15.0 or later

### Building from Source

1. Clone the repository:

   ```bash
   git clone [https://github.com/YourUsername/PixelScaler.git](https://github.com/YourUsername/PixelScaler.git)
   cd PixelScaler
   ```

1. Open `PixelScaler.xcodeproj` in Xcode.
2. Select your Mac as the build target.
3. Hit `Cmd + R` (or click the **Play** button) to build and run the application.

## 🚀 Usage

1. **Import:** Drag and drop PNG/JPG files directly into the application window, or click the **Select Files...** button.
2. **Configure:** Select your preferred algorithm (`xBRZ` or `Nearest Neighbor`) and scale factor (`2x`, `3x`, `4x`) from the right panel.
3. **Export:** Click **Batch Export** and choose a destination folder. Your upscaled images will be saved instantly.

## ⚖️ License & Acknowledgments

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](https://www.google.com/search?q=LICENSE) file for more details.

**Special Thanks:**

- The core pixel scaling magic is powered by the incredible [xBRZ algorithm](https://sourceforge.net/projects/xbrz/) created by **Zenju**.

------

*Built with ❤️ for pixel artists and retro gaming enthusiasts.*
