import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics
const errors = new Rate('errors');

export const options = {
  stages: [
    { duration: '1m', target: 20 },  // Ramp up to 20 users
    { duration: '3m', target: 20 },  // Stay at 20 users
    { duration: '1m', target: 0 },   // Ramp down to 0 users
  ],
  thresholds: {
    errors: ['rate<0.1'],  // Error rate should be less than 10%
    http_req_duration: ['p(95)<500'],  // 95% of requests should be below 500ms
  },
};

export default function() {
  const url = 'http://test.k6.io';
  
  // Make HTTP request
  const response = http.get(url);
  
  // Check response
  const checkResult = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  // Add to error rate if checks failed
  errors.add(!checkResult);
  
  // Random sleep between 1s and 5s
  sleep(Math.random() * 4 + 1);
}