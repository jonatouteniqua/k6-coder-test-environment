#!/bin/bash
# setup-k6-environment.sh

echo "Setting up K6 testing environment..."

# Create working directory in the Coder workspace
mkdir -p ~/k6-testing
cd ~/k6-testing

# Install required packages
sudo apt-get update
sudo apt-get install -y wget

# Download and install K6 binary directly
wget https://github.com/grafana/k6/releases/download/v0.47.0/k6-v0.47.0-linux-amd64.tar.gz
tar xzf k6-v0.47.0-linux-amd64.tar.gz
sudo mv k6-v0.47.0-linux-amd64/k6 /usr/local/bin/
rm -rf k6-v0.47.0-linux-amd64* 

# Verify K6 installation
k6 version

# Create project structure
mkdir -p {tests,scripts,results}

# Create a basic test file
cat > tests/basic-test.js << 'EOL'
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 1,
  duration: '30s',
};

export default function () {
  const res = http.get('http://test.k6.io');
  check(res, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(1);
}
EOL

# Create package.json for npm scripts
cat > package.json << 'EOL'
{
  "name": "k6-testing",
  "version": "1.0.0",
  "scripts": {
    "test:basic": "k6 run tests/basic-test.js",
    "test:load": "k6 run tests/load-test.js --out json=results/load-test-results.json",
    "test:stress": "k6 run tests/stress-test.js --out json=results/stress-test-results.json"
  }
}
EOL

# Set appropriate permissions
chmod +x tests/basic-test.js

echo "K6 testing environment setup complete! Try running: k6 run tests/basic-test.js"