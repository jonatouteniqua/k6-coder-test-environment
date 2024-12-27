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
