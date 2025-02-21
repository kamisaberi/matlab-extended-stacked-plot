# Plotter04 - EEG Signal Visualization Tool

## Overview
**Plotter04.m** is a MATLAB script designed to read, process, and visualize multi-channel EEG (Electroencephalography) data. The tool enables interactive navigation, artifact detection, and customizable plotting options to facilitate EEG analysis.

## Features
- **Reads EEG Data:** Loads EEG signals from a file and extracts time-series data.
- **Multi-Channel Plotting:** Displays up to 21 EEG channels in a structured layout.
- **Artifact Detection:** Marks artifacts using scatter points and rectangles.
- **Interactive UI:** Buttons and dropdowns for time navigation and display customization.
- **Configurable Parameters:** Adjustable time intervals, scrolling offsets, and artifact highlighting.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/EEG-Plotter04.git
   cd EEG-Plotter04
   ```
2. Open MATLAB and ensure the required dependencies are installed.
3. Add the FieldTrip toolbox to MATLAB (if not installed already):
   ```matlab
   addpath('E:\LIBRARIES\Matlab\fieldtrip-20240916');
   ```

## Usage
### 1. Load EEG Data
Modify the following line to specify the correct path to your EEG dataset:
```matlab
[hdr, EEG_field, EEG_lab] = readEEG("E:\DATASETS\EEG\Sample_EEG_data\FJ002193.EEG",1,tmax );
```

### 2. Run the Script
Simply execute the script in MATLAB:
```matlab
plotter04
```

### 3. Interactive Controls
| Control | Function |
|---------|----------|
| `<<` Button | Move left in the EEG timeline |
| `>>` Button | Move right in the EEG timeline |
| `axis on/off` | Toggle axis visibility |
| `Time Interval Dropdown` | Adjust the displayed time window |
| `Slide Time Dropdown` | Change scrolling offset |
| `Bars Checkbox` | Toggle artifact rectangle display |
| `Dots Checkbox` | Toggle artifact scatter display |

## Configuration
Modify these parameters in the script to customize the display:
```matlab
PLOT_COUNT = 21;  % Number of EEG channels displayed
PLOT_COLOR = "black";  % Color of EEG signal plots
timeInterval = 10.0;  % Default time window (seconds)
timeOffset = 0.5;  % Scroll offset (seconds)
fs = 500;  % Sampling frequency (Hz)
```

## Dependencies
- MATLAB (R2020 or later recommended)
- [FieldTrip Toolbox](https://www.fieldtriptoolbox.org/) for EEG data processing

## Future Improvements
- **Advanced EEG filtering and preprocessing**
- **Spectral analysis integration**
- **Machine learning-based artifact detection**
- **Export EEG plots as images or reports**

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Contributions are welcome! Feel free to submit issues and pull requests.

## Contact
For any questions or suggestions, reach out via [kamisaberi@gmail.com](mailto:kamisaberi@gmail.com).


## Milestone
- hide/show pots based on channels
- add vertical line on all plots when user click on one of plots
- create and store rects(bars) dynamically only for interval that user is looking at
- change red Dot to some type of regional line plot 
