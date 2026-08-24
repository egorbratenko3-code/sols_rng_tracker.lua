# 🎲 Sol's RNG Tracker & Alert Bot

An automated Roblox script designed for **Sol's RNG** that monitors in-game events, rare biomes, traveling merchants, and special easter eggs in real-time, instantly sending notifications directly to your **Telegram** chat.

---

## ✨ Features

- **📡 Real-Time Telegram Alerts:** Get instant messages on Telegram whenever an event triggers in-game.
- **🌍 Biome Detection:** Tracks rare and custom biomes (e.g., *Glitch, Dreamspace, Cyberspace, Starfall, Corruption, Null, Singularity*, and more).
- **🛒 Merchant Alerts:** Detects when traveling merchants arrive (*Jester, Rin, Mari*).
- **🥚 Easter Egg Detector:** Monitored chat triggers for special Easter Eggs (*Andromeda Egg, Angelic Egg, Blooming Egg*, etc.).
- **💬 Multi-Chat System Support:** Supports `TextChatService`, legacy `DefaultChatSystemChatEvents`, and system console logs (`LogService`).
- **🎨 Modern Customizable UI:**
  - Integrated Draggable Window
  - Theme Switcher (Midnight Dark, Pure Light, Oceanic)
  - Dynamic **RGB Mode**
  - Accordion dropdowns to toggle tracking categories on/off
- **🔒 Whitelist System:** Integrated security verification via user Roblox ID.

---

## ⚡ Quick Start / Loadstrings

Execute either of the following loadstrings in your preferred Roblox Executor (e.g., Wave, Solara, Swift, Celery, etc.):

### 🌟 Version 1.6 (Full UI & Custom Toggles)
Features a full UI with customizable themes, individual event toggles for Biomes, Merchants, and Eggs, and chat integration.

```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/egorbratenko3-code/sols_rng_tracker.lua/refs/heads/main/trecker.lua](https://raw.githubusercontent.com/egorbratenko3-code/sols_rng_tracker.lua/refs/heads/main/trecker.lua)"))()

```

### 🚀 Version 1.1 (Lightweight / Log & Chat Detector)

A compact alert system focusing on core biome notifications via chat and system log monitoring.

```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/egorbratenko3-code/sols_rng_tracker.lua/refs/heads/main/v2.lua](https://raw.githubusercontent.com/egorbratenko3-code/sols_rng_tracker.lua/refs/heads/main/v2.lua)"))()

```

---

## 📖 How to Setup Telegram Notifications

1. Open Telegram and search for [@myidbot](https://t.me/myidbot) or [@userinfobot](https://t.me/userinfobot) to get your personal **Telegram Chat ID**.
2. Run the Roblox script using your executor.
3. Paste your **Chat ID** into the script UI's `CHAT ID` input box and press **Enter**.
4. You will receive a confirmation message in Telegram:
```text
✅ Tracker Connected! ID: <YOUR_CHAT_ID>

```



---

## 🛡️ Whitelist & Access

This script includes an automatic whitelist verification check:

* If your Roblox User ID is added to the whitelist, the script will load smoothly.
* If your User ID is **not** whitelisted or subscription status expires, the game will kick with a message to contact the script author.

---

## ⚠️ Disclaimer & Usage Note

* **HttpService / Request permissions:** Ensure your executor supports `syn.request`, `http_request`, or standard Roblox `HttpService`.
* Use this script responsibly and in compliance with Roblox Terms of Service.

---

### 👨‍💻 Developer

Developed by **egorbratenko3-code (Blinchic111)**.

```

```
