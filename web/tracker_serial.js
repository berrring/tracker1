// Local USB only. Commands and replies never leave the selected serial port.
window.safeTrackSerial = (() => {
  let port, reader, reading, pending;
  let nextId = crypto.getRandomValues(new Uint32Array(1))[0] % 1000000000;
  const reply = code => JSON.stringify({code});
  const supported = () => window.isSecureContext && !!navigator.serial;
  const connected = () => !!port?.readable && !!port?.writable && !!reader;

  function finish(value) {
    if (!pending) return;
    const operation = pending;
    pending = undefined;
    clearTimeout(operation.timer);
    operation.resolve(value);
  }

  async function read(input) {
    const decoder = new TextDecoder();
    let buffer = '';
    let discard = false;
    try {
      while (true) {
        const {value, done} = await input.read();
        if (done) break;
        for (const character of decoder.decode(value, {stream: true})) {
          if (character === '\n') {
            if (!discard && pending && buffer.startsWith(pending.prefix)) {
              finish(buffer.slice(pending.prefix.length).trim());
            }
            buffer = '';
            discard = false;
          } else if (!discard) {
            buffer += character;
            if (buffer.length > 512) discard = true;
          }
        }
      }
    } catch (_) {
      // A USB unplug can reject an outstanding read.
    } finally {
      input.releaseLock();
      if (reader === input) reader = undefined;
      finish(reply('disconnected'));
    }
  }

  async function write(line) {
    const writer = port.writable.getWriter();
    try {
      await writer.write(new TextEncoder().encode(line));
    } finally {
      writer.releaseLock();
    }
  }

  async function disconnect() {
    if (pending && connected()) {
      try { await write('ST1 0 CANCEL\n'); } catch (_) {}
    }
    finish(reply('disconnected'));
    if (reader) {
      try { await reader.cancel(); } catch (_) {}
    }
    await reading;
    const previous = port;
    port = undefined;
    if (previous) {
      try { await previous.close(); } catch (_) {}
    }
  }

  function request(command, args = '') {
    if (!connected()) return Promise.resolve(reply('disconnected'));
    if (pending) return Promise.resolve(reply('busy'));
    if (!['STATUS', 'DIAG', 'SET', 'CLEAR', 'TEST'].includes(command) ||
        /[\r\n]/.test(args) || args.length > 80) {
      return Promise.resolve(reply('invalid'));
    }
    const prefix = 'ST1 ' + (++nextId) + ' ';
    const timeout = command === 'TEST' ? 125000 :
      ['SET', 'CLEAR'].includes(command) ? 25000 : command === 'DIAG' ? 15000 : 4500;
    return new Promise(resolve => {
      pending = {prefix, resolve, timer: setTimeout(() => {
        // Stop accepting replies for this request. An SMS result may be unknown.
        finish(reply(command === 'TEST' ? 'sms_unknown' : 'timeout'));
      }, timeout)};
      write(prefix + command + (args ? ' ' + args : '') + '\n')
        .catch(() => finish(reply('serial_error')));
    });
  }

  async function connect() {
    if (!supported()) return reply('unsupported');
    if (connected()) return request('STATUS');
    try {
      const chosen = await navigator.serial.requestPort();
      await disconnect();
      port = chosen;
      await port.open({baudRate: 115200});
      reader = port.readable.getReader();
      reading = read(reader);
      // Some USB bridges reset the ESP32-S3 when the port opens.
      const first = await request('STATUS');
      return first === reply('timeout') ? request('STATUS') : first;
    } catch (error) {
      await disconnect();
      return reply(error?.name === 'NotFoundError' ? 'cancelled' : 'serial_error');
    }
  }

  return {supported, connected, connect, request, disconnect};
})();
