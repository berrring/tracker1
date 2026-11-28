#include <cassert>
#include "../SafeTrackBench/switch_approval.h"

int main() {
  SwitchApproval gate;
  assert(!gate.sample(true, 10000)); // no local request

  gate.arm(true, 100);
  assert(!gate.sample(true, 3000)); // already ON
  assert(!gate.sample(false, 3010));
  assert(!gate.sample(true, 3150)); // OFF bounced
  assert(!gate.sample(true, 5000));
  assert(!gate.sample(false, 5010));
  assert(!gate.sample(false, 5260)); // stable OFF
  assert(!gate.sample(true, 5300));
  assert(!gate.sample(false, 5400)); // short activation
  assert(!gate.sample(true, 5500));
  assert(!gate.sample(true, 6999));
  assert(gate.sample(true, 7000));
  assert(!gate.sample(true, 24000)); // no repeat
  assert(!gate.sample(false, 25000));
  assert(!gate.sample(true, 28000)); // another cycle needs a new request

  gate.arm(false, 30000);
  assert(!gate.sample(false, 30250));
  assert(!gate.sample(true, 30300));
  gate.cancel();
  assert(!gate.sample(true, 32000)); // expired/cancelled

  gate.arm(false, UINT32_MAX - 249);
  assert(!gate.sample(false, 0));
  assert(!gate.sample(true, 1));
  assert(gate.sample(true, 1501));
}
