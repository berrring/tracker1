#pragma once

// Set to 1 only after matching the physical board to the linked vendor schematic
// and checking the UART, BOOT and RGB LED pins in HARDWARE_SETUP.md.
#ifndef SAFETRACK_VERIFIED_PROFILE
#define SAFETRACK_VERIFIED_PROFILE 0
#endif

constexpr bool profileEnabled = SAFETRACK_VERIFIED_PROFILE == 1;
constexpr int modemRx = 17;
constexpr int modemTx = 18;
constexpr int bootButton = 0;
constexpr int rgbPin = 38;
constexpr unsigned long baud = 115200;
