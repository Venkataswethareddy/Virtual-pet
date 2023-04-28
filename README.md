<div align="center">

# 🥚 tamago alive

**a virtual pet that *actually* feels alive**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/State-Provider-7B1FA2?style=for-the-badge)](https://pub.dev/packages/provider)
[![Hive](https://img.shields.io/badge/Storage-Hive-FFD54F?style=for-the-badge)](https://pub.dev/packages/hive)
[![License](https://img.shields.io/badge/license-Apache_2.0-green?style=for-the-badge)](LICENSE)

<br>

*your pocket companion that breathes, evolves, reacts to sensors,*
*has its own personality DNA, plays mini-games, and knows if it's 3am irl* 🌙

<br>

---

</div>

## 🌸 hey, welcome

this started as a random idea at 2am — "what if a tamagotchi was built with flutter and actually felt alive?"

so i built it. every pixel, every animation, every personality quirk — all in dart.  
no external image assets. the pet is drawn entirely with `CustomPainter`.  
it breathes. it reacts when you shake your phone. it knows if it's night in the real world.  
and no two pets are the same because of the **personality DNA system** 🧬

> *"i didn't just build an app, i birthed a whole creature"* ✨

---

## 🎀 what makes it special

<table>
<tr>
<td width="50%">

### 🧬 personality dna
every pet is born with random traits that change *everything*:

| trait | effect |
|---|---|
| 🦁 **bravery** | brave = excited on shake, shy = hides |
| ⚡ **activity** | active = burns energy fast, more play reward |
| 💗 **friendliness** | friendly = more love animations |
| 🍔 **appetite** | foodie = hungrier faster, gains more from food |

</td>
<td width="50%">

### 🦋 evolution system
5 stages, 3 paths, care style decides everything:

| if you... | path | final form |
|---|---|---|
| feed most 🍎 | cat path | 🐱 → 🦁 lion |
| play most ⚽ | dog path | 🐶 → 🐺 wolf |
| sleep most 😴 | bunny path | 🐰 → 🦊 fox |

neglect = sad form → ghost form 👻  
*(but you can bring them back with love)*

</td>
</tr>
</table>

---

## ✨ feature showcase

<table>
<tr>
<td align="center" width="25%">
<br><b>🏠 living room</b><br><br>
day/night cycle matches real time<br>
sunrise 🌅 → daylight ☀️ → sunset 🌇 → stars 🌙<br>
place decorations, customize everything
<br><br>
</td>
<td align="center" width="25%">
<br><b>🎮 mini-games</b><br><br>
🍔 feed frenzy — tilt to catch food<br>
🃏 memory match — 4×4 card flip<br>
📱 shake challenge — shake it!!<br>
earn coins, buy treats
<br><br>
</td>
<td align="center" width="25%">
<br><b>🛒 shop system</b><br><br>
🍎 food (apples, steak, cake)<br>
🧸 toys (ball, teddy)<br>
🩹 medicine (bandage, potion)<br>
🎩 costumes & 🪴 decorations
<br><br>
</td>
<td align="center" width="25%">
<br><b>💭 thought bubbles</b><br><br>
"i'm hungry..." 😢<br>
"play with me!" 🥺<br>
"i'm sleepy..." 😴<br>
mood-aware thoughts
<br><br>
</td>
</tr>
</table>

---

## 🎨 interactions

| action | how | what happens |
|---|---|---|
| 🍎 **feed** | drag food → pet's mouth | hunger ↑, eating animation |
| ❤️ **pat** | tap on pet | happiness ↑, heart particles |
| ⚽ **play** | tap play button | happy animation, energy ↓ |
| 😴 **sleep** | tap sleep button | room darkens, energy recharges |
| 🩹 **heal** | appears when sick | health ↑ |
| 📱 **shake phone** | shake it | scared or excited (personality!) |
| 📐 **tilt phone** | tilt left/right | pet slides with accelerometer |

---

## 🌍 real-world awareness

your pet **lives in your timezone**:

```
☀️  6am-8am   →  sunrise, pet stretches + wakes up
🌤  8am-6pm   →  bright daylight, pet is active
🌅  6pm-8pm   →  sunset colors
🌙  8pm-6am   →  dark with stars and moon, pet sleepy
```

when you open the app after being away:
> *"while you were away: your pet got hungry, took a nap, and missed you"* 💜

---

## 🏗️ architecture

built clean. no spaghetti. real engineering.

```
lib/
├── core/           →  constants, enums, utilities
│   ├── constants/  →  colors, strings, pet_constants, asset_paths
│   ├── enums/      →  pet_type, pet_mood, pet_stage, item_type, personality
│   └── utils/      →  decay_calculator, evolution_logic, time_helper
├── models/         →  pet, personality, room, inventory, shop_item, game_score
├── services/       →  pet_engine, storage, notifications, audio, sensors, haptics
├── providers/      →  pet, room, inventory, game, theme
├── screens/        →  splash, hatching, home, stats, shop, inventory,
│                      room_editor, settings, + 3 mini-games
├── widgets/        →  pet character (CustomPainter!), room bg, stat bars,
│                      drag-food, action buttons, particles, coin display
├── main.dart       →  bootstrap: hive init, provider tree
└── app.dart        →  MaterialApp + dark theme + google fonts
```

---

## 🛠 tech stack

<table>
<tr>
<td align="center"><b>🎯 Framework</b><br>Flutter 3.x</td>
<td align="center"><b>🧠 State</b><br>Provider</td>
<td align="center"><b>💾 Storage</b><br>Hive</td>
<td align="center"><b>🎨 Fonts</b><br>Google Fonts (Outfit)</td>
</tr>
<tr>
<td align="center"><b>✨ Animations</b><br>flutter_animate + confetti</td>
<td align="center"><b>📱 Sensors</b><br>sensors_plus</td>
<td align="center"><b>🔔 Notifications</b><br>flutter_local_notifications</td>
<td align="center"><b>📳 Haptics</b><br>vibration</td>
</tr>
</table>

---

## 🚀 run it yourself

```bash
git clone https://github.com/Venkataswethareddy/Virtual-pet.git
cd Virtual-pet
flutter pub get
flutter run
```

> **note:** audio files are placeholder paths. drop `.mp3` files into `assets/audio/` when you have them.

---

## 📊 project stats

| metric | count |
|---|---|
| dart files | 61 |
| screens | 11 |
| widgets | 18 |
| mini-games | 3 |
| shop items | 13 |
| personality traits | 4 |
| evolution stages | 5 |
| evolution paths | 3 |
| moods | 7 |
| lines of code | 5000+ |

---

<div align="center">

### 🐾 built with love, dart, and too many late nights

*if you made it this far — give this repo a ⭐ and maybe hatch your own pet* 🥚✨

<br>

**[Venkataswethareddy](https://github.com/Venkataswethareddy)** · 2023

</div>
