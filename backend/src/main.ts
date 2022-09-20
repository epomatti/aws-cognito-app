import * as worker from './server'

(async () => {
  try {
    await worker.start();
  } catch (e) {
    console.error(e);
  }
})();