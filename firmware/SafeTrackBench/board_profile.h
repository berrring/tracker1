#pragma once

// 0: USB identification only. 1: verified baseline. 2: verified V2 with gauge.
// Enable a profile only after checking the physical board and wiring.
#ifndef SAFETRACK_VERIFIED_PROFILE
#define SAFETRACK_VERIFIED_PROFILE 0
#endif
#ifndef SAFETRACK_SOS_PIN
#define SAFETRACK_SOS_PIN -1
#endif

static_assert(SAFETRACK_VERIFIED_PROFILE >= 0 && SAFETRACK_VERIFIED_PROFILE <= 2,
              "Use the locked, baseline, or V2 profile");
constexpr bool profileEnabled = SAFETRACK_VERIFIED_PROFILE != 0;
constexpr bool gaugeEnabled = SAFETRACK_VERIFIED_PROFILE == 2;
constexpr int modemRx = 17;
constexpr int modemTx = 18;
constexpr int bootButton = 0;
constexpr int rgbPin = 38;
constexpr int gaugeSda = 15;
constexpr int gaugeScl = 16;
constexpr int sosPin = SAFETRACK_SOS_PIN;
constexpr bool slideEnabled = profileEnabled && sosPin >= 0;
static_assert(!slideEnabled ||
                  (sosPin != 7 && sosPin != bootButton && sosPin != modemRx &&
                   sosPin != modemTx && sosPin != rgbPin &&
                   (!gaugeEnabled || (sosPin != gaugeSda && sosPin != gaugeScl))),
              "SOS pin conflicts with documented board signals");
constexpr unsigned long baud = 115200;
