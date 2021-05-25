'use strict';

const {
  ArrayPrototypePop,
  Promise,
} = primordials;

const {
  addAbortSignalNoValidate,
} = require('internal/streams/add-abort-signal');

const {
  validateAbortSignal,
} = require('internal/validators');

const {
  isIterable,
  isStream,
} = require('internal/streams/utils');

let pl;
let eos;

function pipeline(...streams) {
  if (!pl) pl = require('internal/streams/pipeline');
  return new Promise((resolve, reject) => {
    let signal;
    const lastArg = streams[streams.length - 1];
    if (lastArg && typeof lastArg === 'object' &&
        !isStream(lastArg) && !isIterable(lastArg)) {
      const options = ArrayPrototypePop(streams);
      signal = options.signal;
      validateAbortSignal(signal, 'options.signal');
    }

    const pipe = pl(...streams, (err, value) => {
      if (err) {
        reject(err);
      } else {
        resolve(value);
      }
    });
    if (signal) {
      addAbortSignalNoValidate(signal, pipe);
    }
  });
}

function finished(stream, opts) {
  if (!eos) eos = require('internal/streams/end-of-stream');
  return new Promise((resolve, reject) => {
    eos(stream, opts, (err) => {
      if (err) {
        reject(err);
      } else {
        resolve();
      }
    });
  });
}

module.exports = {
  finished,
  pipeline,
};