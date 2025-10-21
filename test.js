const request = require('supertest');
const app = require('./server');

describe('API Endpoints', () => {
  describe('GET /api/hello', () => {
    it('should return correct response format', async () => {
      const response = await request(app)
        .get('/api/hello')
        .expect(200);

      expect(response.body).toHaveProperty('hostname');
      expect(response.body).toHaveProperty('datetime');
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('weather');
      expect(response.body.weather).toHaveProperty('dhaka');
      expect(response.body.weather.dhaka).toHaveProperty('temperature');
      expect(response.body.weather.dhaka).toHaveProperty('temp_unit');
    });

    it('should return datetime in YYMMDDHHmm format', async () => {
      const response = await request(app)
        .get('/api/hello')
        .expect(200);

      const datetime = response.body.datetime;
      expect(datetime).toMatch(/^\d{10}$/); // Should be exactly 10 digits
    });

    it('should return version from package.json', async () => {
      const response = await request(app)
        .get('/api/hello')
        .expect(200);

      expect(response.body.version).toBeDefined();
      expect(typeof response.body.version).toBe('string');
    });
  });

  describe('GET /api/health', () => {
    it('should return health status', async () => {
      const response = await request(app)
        .get('/api/health');

      // Health endpoint should return 200 or 503 depending on weather API status
      expect([200, 503]).toContain(response.status);
      expect(response.body).toHaveProperty('status');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('services');
      expect(response.body.services).toHaveProperty('api');
      expect(response.body.services).toHaveProperty('weather_api');
    });

    it('should return valid timestamp', async () => {
      const response = await request(app)
        .get('/api/health');

      // Health endpoint should return 200 or 503 depending on weather API status
      expect([200, 503]).toContain(response.status);
      const timestamp = new Date(response.body.timestamp);
      expect(timestamp).toBeInstanceOf(Date);
      expect(timestamp.getTime()).not.toBeNaN();
    });
  });

  describe('GET /', () => {
    it('should return API information', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('endpoints');
    });
  });

  describe('404 handling', () => {
    it('should return 404 for non-existent endpoints', async () => {
      const response = await request(app)
        .get('/api/nonexistent')
        .expect(404);

      expect(response.body).toHaveProperty('error');
      expect(response.body.error).toBe('Not Found');
    });
  });
});
