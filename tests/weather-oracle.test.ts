import { describe, it, expect, beforeEach, vi } from 'vitest';

// Mock the Clarity contract environment
const mockClarity = {
  tx: {
    sender: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM', // Mock contract owner
  },
  block: {
    height: 100,
  },
  contracts: {},
};

// Mock functions to simulate contract behavior
const mockWeatherOracle = {
  weatherData: new Map(),
  oracleProviders: new Map(),
  
  getWeatherData(location, timestamp) {
    const key = `${location}-${timestamp}`;
    return this.weatherData.get(key);
  },
  
  getOracleProvider(provider) {
    return this.oracleProviders.get(provider);
  },
  
  isActiveProvider(provider) {
    const oracleProvider = this.getOracleProvider(provider);
    return oracleProvider ? oracleProvider.active : false;
  },
  
  registerOracleProvider(name, sender) {
    // Only contract owner can register providers
    if (sender !== mockClarity.tx.sender) {
      return { error: 100 }; // err-not-authorized
    }
    
    // Register the provider
    this.oracleProviders.set(sender, {
      name,
      active: true,
      registrationDate: mockClarity.block.height,
    });
    
    return { value: true };
  },
  
  deactivateProvider(provider, sender) {
    // Only contract owner can deactivate providers
    if (sender !== mockClarity.tx.sender) {
      return { error: 100 }; // err-not-authorized
    }
    
    const oracleProvider = this.getOracleProvider(provider);
    if (!oracleProvider) {
      return { error: 101 }; // err-not-registered
    }
    
    // Deactivate the provider
    this.oracleProviders.set(provider, {
      ...oracleProvider,
      active: false,
    });
    
    return { value: true };
  },
  
  reportWeatherData(location, timestamp, temperature, rainfall, humidity, windSpeed, sender) {
    // Check if provider is active
    if (!this.isActiveProvider(sender)) {
      return { error: 101 }; // err-not-registered
    }
    
    // Store weather data
    const key = `${location}-${timestamp}`;
    this.weatherData.set(key, {
      temperature,
      rainfall,
      humidity,
      windSpeed,
      reportedBy: sender,
      reportTime: mockClarity.block.height,
    });
    
    return { value: true };
  },
  
  getRainfallData(location, startTime, endTime) {
    // Simplified implementation for testing
    return { value: 0 };
  },
  
  getTemperatureExtremes(location, startTime, endTime) {
    // Simplified implementation for testing
    return { value: { min: 0, max: 0 } };
  },
};

describe('Weather Oracle Contract', () => {
  beforeEach(() => {
    // Reset the mock state before each test
    mockWeatherOracle.weatherData.clear();
    mockWeatherOracle.oracleProviders.clear();
  });
  
  it('should allow contract owner to register an oracle provider', () => {
    const name = 'Weather Service';
    
    const result = mockWeatherOracle.registerOracleProvider(
        name, mockClarity.tx.sender
    );
    
    expect(result.value).toBe(true);
    
    const provider = mockWeatherOracle.getOracleProvider(mockClarity.tx.sender);
    expect(provider).toBeDefined();
    expect(provider.name).toBe(name);
    expect(provider.active).toBe(true);
  });
  
  it('should not allow non-owner to register an oracle provider', () => {
    const name = 'Weather Service';
    const nonOwner = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
    
    const result = mockWeatherOracle.registerOracleProvider(
        name, nonOwner
    );
    
    expect(result.error).toBe(100); // err-not-authorized
  });
  
  it('should allow contract owner to deactivate a provider', () => {
    const name = 'Weather Service';
    const provider = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
    
    // Register provider
    mockWeatherOracle.oracleProviders.set(provider, {
      name,
      active: true,
      registrationDate: mockClarity.block.height,
    });
    
    // Deactivate provider
    const result = mockWeatherOracle.deactivateProvider(
        provider, mockClarity.tx.sender
    );
    
    expect(result.value).toBe(true);
    
    const updatedProvider = mockWeatherOracle.getOracleProvider(provider);
    expect(updatedProvider.active).toBe(false);
  });
  
  it('should allow active provider to report weather data', () => {
    const provider = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
    const location = 'Farm County';
    const timestamp = 12345;
    const temperature = 25;
    const rainfall = 10;
    const humidity = 60;
    const windSpeed = 5;
    
    // Register provider
    mockWeatherOracle.oracleProviders.set(provider, {
      name: 'Weather Service',
      active: true,
      registrationDate: mockClarity.block.height,
    });
    
    // Report weather data
    const result = mockWeatherOracle.reportWeatherData(
        location, timestamp, temperature, rainfall, humidity, windSpeed, provider
    );
    
    expect(result.value).toBe(true);
    
    const weatherData = mockWeatherOracle.getWeatherData(location, timestamp);
    expect(weatherData).toBeDefined();
    expect(weatherData.temperature).toBe(temperature);
    expect(weatherData.rainfall).toBe(rainfall);
    expect(weatherData.humidity).toBe(humidity);
    expect(weatherData.windSpeed).toBe(windSpeed);
    expect(weatherData.reportedBy).toBe(provider);
  });
  
  it('should not allow inactive provider to report weather data', () => {
    const provider = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
    const location = 'Farm County';
    const timestamp = 12345;
    const temperature = 25;
    const rainfall = 10;
    const humidity = 60;
    const windSpeed = 5;
    
    // Provider not registered
    
    // Report weather data
    const result = mockWeatherOracle.reportWeatherData(
        location, timestamp, temperature, rainfall, humidity, windSpeed, provider
    );
    
    expect(result.error).toBe(101); // err-not-registered
  });
});
