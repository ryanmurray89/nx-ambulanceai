# nx-ambulanceai - AI EMS Civilian Calls [QBCore | 0.00ms]

> Keep EMS busy when players are down. Fully automatic civilian down calls, now server-driven and optimized to 0.00ms idle.

Resmon: **0.00ms idle** | Version: **2.0.0 Optimized** | QBCore

**Developed by NexLabs Studios LLC**

### What it does
Spawns random unconscious civilians around the city with random injuries. EMS players get a blip, dispatch alert (ps-dispatch), and can assess + revive with a defib for a reward. If no EMS is on duty, nothing runs.

### v2.0.0 - Optimized
- **0 Client Threads** - No loops on client
- **Server-sided duty check** - One server thread checks EMS on-duty every 5 mins. 0 EMS = 0 threads, 0 resmon
- **Cached cache.ped**, SetTimeout cleanup, no Wait(0) spam
- **Exploit patched**
- **0.00ms idle, 0.02ms on spawn** (was 0.05-0.12ms)

### Features
- Auto calls based on % chance & interval
- Only spawns if EMS is on-duty
- 10+ configurable spawn locations
- Random injuries & ped models
- ox_target + ox_lib
- ps-dispatch support
- Auto cleanup + blip
- Reward system (cash/bank)
- GitHub version checker

### Dependencies
qb-core, ox_lib, ox_target, ox_inventory, ps-dispatch (optional)

### Installation
1. Download latest release
2. Drag to `resources` folder
3. `ensure nx-ambulanceai` in server.cfg
4. Restart server

### Commands
/testambu - Test spawn a civilian

### License
MIT