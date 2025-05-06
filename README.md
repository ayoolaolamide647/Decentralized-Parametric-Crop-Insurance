# Decentralized Parametric Crop Insurance (DPCI)

A blockchain-based agricultural risk management platform providing automated weather-indexed crop insurance for farmers worldwide.

## Overview

DPCI revolutionizes agricultural insurance by using smart contracts to provide transparent, efficient, and affordable parametric crop insurance. The system automatically processes claims based on verified weather data, eliminating the need for traditional crop damage assessments and reducing administrative costs while accelerating payouts.

## Core Components

### 1. Farmer Verification Contract

Validates and onboards legitimate agricultural producers to the platform.

- **Identity Verification**: Confirms farmer identities through decentralized credentials
- **Farm History Registry**: Records production history and agricultural activities
- **Reputation System**: Tracks farmer reliability and claim history
- **Membership Management**: Handles farmer onboarding, renewal, and verification status

### 2. Field Registration Contract

Documents and manages insured agricultural land and growing areas.

- **Geospatial Mapping**: Records precise field locations and boundaries using GPS coordinates
- **Crop Specification**: Tracks crop types, planting dates, and expected harvest dates
- **Soil Characteristics**: Documents soil type, quality, and other relevant field attributes
- **Historical Performance**: Maintains records of previous yields and weather events

### 3. Weather Data Oracle Contract

Collects, validates, and secures environmental condition data.

- **Multi-Source Integration**: Aggregates data from various trusted weather stations and satellites
- **Data Validation**: Uses consensus mechanisms to verify weather information accuracy
- **Historical Archiving**: Maintains accessible records of past weather conditions
- **Real-time Monitoring**: Tracks current conditions for immediate event detection

### 4. Policy Management Contract

Defines and manages insurance coverage terms and conditions.

- **Coverage Parameters**: Records protection levels, premium rates, and covered weather events
- **Risk Modeling**: Calculates premiums based on historical data and risk profiles
- **Trigger Definition**: Specifies exact weather thresholds that activate claims
- **Term Management**: Handles policy creation, modification, and renewal processes

### 5. Automated Claims Contract

Processes insurance payouts based on verified weather events.

- **Event Detection**: Monitors oracle data for triggering weather conditions
- **Payout Calculation**: Determines compensation amounts based on policy terms
- **Payment Execution**: Automatically transfers funds to farmers when conditions are met
- **Dispute Resolution**: Handles edge cases and verification challenges

## Getting Started

1. **Setup Development Environment**
   ```bash
   git clone https://github.com/yourusername/dpci.git
   cd dpci
   npm install
   ```

2. **Configure Network Settings**
   ```bash
   cp .env.example .env
   # Edit .env with your blockchain network details and oracle API keys
   ```

3. **Deploy Smart Contracts**
   ```bash
   npx hardhat compile
   npx hardhat deploy --network [network_name]
   ```

4. **Run Tests**
   ```bash
   npx hardhat test
   ```

## Farmer Onboarding Process

1. Complete KYC verification through the web interface
2. Register and verify farm ownership or operating rights
3. Define field boundaries and submit crop planting information
4. Select coverage parameters and policy terms
5. Pay premium in cryptocurrency or stablecoin
6. Receive digital policy certificate as an NFT

## Weather Event Coverage Types

- **Drought**: Insufficient rainfall over defined periods
- **Excessive Rainfall**: Damaging precipitation levels
- **Frost/Freeze**: Temperature dropping below crop-specific thresholds
- **Heat Stress**: Extended periods of high temperatures
- **Wind Damage**: High wind speeds affecting crop development

## Technical Architecture

- **Blockchain**: Ethereum/Polygon for contract deployment
- **Data Storage**: IPFS for storing large datasets and documentation
- **Oracles**: Chainlink for weather data verification
- **Frontend**: React-based dashboard for farmer interaction

## Security Considerations

- All contracts undergo formal verification and third-party audit
- Multi-signature controls for administrative functions
- Circuit breakers to pause operations during anomalous conditions
- Rate limiting to prevent oracle manipulation attacks
- Regular security assessments and penetration testing

## Development Roadmap

- **Phase 1**: Core contract development and testing
- **Phase 2**: Oracle integration and data validation systems
- **Phase 3**: User interface development and farmer onboarding
- **Phase 4**: Pilot program in selected agricultural regions
- **Phase 5**: Global expansion and additional crop type support

## License

[MIT License](LICENSE)

## Contributing

We welcome contributions from developers, agricultural experts, and insurance professionals. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Contact

For questions or support, reach out to the team at support@dpci.io or join our [Discord community](https://discord.gg/dpci).
