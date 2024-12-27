# K6 Testing Environment in Coder

## Setup
The environment is already configured with K6 installed.

## Running Tests
1. Basic test: `npm run test:basic`
2. Load test: `npm run test:load`
3. Stress test: `npm run test:stress`

## Test Files Location
- Test scripts: `~/k6-testing/tests/`
- Results: `~/k6-testing/results/`

## Creating New Tests
1. Create a new .js file in the tests directory
2. Use the basic-test.js as a template
3. Add the test script to package.json

## Note
This environment is running inside a Coder Docker workspace. All files are persisted in your workspace.
