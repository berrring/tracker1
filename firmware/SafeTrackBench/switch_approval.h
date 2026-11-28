#pragma once

#include <stdint.h>

// A request must observe OFF after it is armed, then a deliberate ON hold.
// Unsigned elapsed time keeps polling safe across millis() rollover.
class SwitchApproval {
 public:
  static constexpr uint32_t offMs = 250;
  static constexpr uint32_t holdMs = 1500;

  void arm(bool on, uint32_t now) {
    phase = offRequired;
    previous = on;
    changed = now;
  }

  void cancel() { phase = idle; }

  bool sample(bool on, uint32_t now) {
    if (phase == idle) return false;
    if (on != previous) {
      previous = on;
      changed = now;
    }
    const uint32_t elapsed = now - changed;
    if (phase == offRequired && !on && elapsed >= offMs) phase = armed;
    if (phase == armed && on && elapsed >= holdMs) {
      phase = idle;
      return true;
    }
    return false;
  }

 private:
  enum Phase { idle, offRequired, armed };
  Phase phase = idle;
  bool previous = false;
  uint32_t changed = 0;
};
