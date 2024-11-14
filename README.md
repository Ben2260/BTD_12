# Balloon Telemetry Software
<img src="[URL](https://github.com/Ben2260/BTD_12/blob/main/image/balloooon.png)" alt="description" align="left" width="200"/>:
![Balloon Image](https://github.com/Ben2260/BTD_12/blob/main/image/balloooon.png)

Welcome to the Balloon Telemetry Determination Support Software repository! This project is dedicated to developing a comprehensive telemetry system for high-altitude balloon tracking missions. The following are what will be stored and what has been stored in this repository.

1. **Mechanichal Models**
5. **Electrical Models**
2. **On-Board Computer**
3. **Server**
4. **Ground Station**


## Project Goal

The primary goal of this project is to create a robust and reliable telemetry system that can efficiently transmit data from a high-altitude balloon to a ground station via an intermediate server. This system will enable real-time monitoring and data collection during the balloon's flight.

## Repository Structure

### 1. Onboard Computer

The `onboard_computer` directory contains all the necessary code and scripts for the onboard computer system of the high-altitude balloon. This component is responsible for:

- Collecting telemetry data from various sensors.
- Processing and encoding the data.
- Transmitting the data to the server via a radio link or satellite communication.

### 2. Server

The `server` directory hosts the code and scripts for the server component. The server acts as an intermediary between the onboard computer and the ground station. It is responsible for:

- Receiving telemetry data from the onboard computer.
- Storing and organizing the received data.
- Retransmitting the data to the ground station for further analysis and monitoring.

### 3. Ground Station

The `ground_station` directory contains the code and scripts for the ground station component. This is the final destination for the telemetry data and is responsible for:

- Receiving data from the server.
- Displaying real-time telemetry data to mission operators.
- Storing data for post-mission analysis.
- Providing tools for visualizing and analyzing the data.

## How to Use

1. **Onboard Computer**: Follow the instructions in the `onboard_computer/README.md` to set up and configure the onboard computer system.
2. **Server**: Follow the instructions in the `server/README.md` to set up and configure the server.
3. **Ground Station**: Follow the instructions in the `ground_station/README.md` to set up and configure the ground station.

## Contributing

We welcome contributions from the community! If you have any suggestions, improvements, or bug fixes, please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
