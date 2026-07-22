--[[
 Conquest of Azeroth (Ascension) spell data for Loss of Control.

 This file is an add-on data pack. It does NOT redefine the base tables;
 instead it merges CoA crowd-control auras and interrupt lockouts into the
 tables created by Shared\Data\SpellLoC.lua. It must therefore be loaded
 AFTER SpellLoC.lua in the .toc (see load order there).

 Values are normalized to the addon's canonical mechanic keys
 (STUN, FEAR, SILENCE, POLYMORPH, ROOT, DISARM, INCAP, HORROR, SLEEP,
 DISORIENT, BANISH, CHARM, SNARE), so priority, per-type display toggles,
 icons and localization all apply correctly. Interrupts use numeric lockout
 durations (seconds), matching INTERRUPT_LOCKOUT.
]]

--@class Engine<ns>
local Engine = select(2, ...);

--@natives
local pairs = pairs;

--@import<data>
-- These are created by SpellLoC.lua (loaded earlier). We fall back to fresh
-- tables and re-publish them if load order is ever changed, so the pack is
-- forgiving either way.
local AURA_CC = Engine.Data.AURA_CC or {};
Engine.Data.AURA_CC = AURA_CC;
local INTERRUPT_LOCKOUT = Engine.Data.INTERRUPT_LOCKOUT or {};
Engine.Data.INTERRUPT_LOCKOUT = INTERRUPT_LOCKOUT;


-- CoA CC Auras: [spellID] = MECHANIC
----------------------------------------------------------------
local coaAuras = {
	-- Barbarian
	[520523] = "STUN",       -- Headbutt              -- 4s stun on 40s cd
	[560532] = "DISORIENT",  -- Skull Smash           -- 8s disorient on 2 min cd
	-- Bloodmage
	[281190] = "HORROR",     -- Hemostasis
	[681304] = "HORROR",     -- Hemostasis
	[801074] = "FEAR",       -- Scarlet Delirium
	[804198] = "HORROR",     -- Terrify               -- horror on 2 min cd -- OBSOLETE?
	-- Chronomancer
	[280795] = "DISARM",     -- Desynchronization
	[561310] = "DISARM",     -- Desynchronization
	[706056] = "BANISH",     -- Slipstream
	[706969] = "SNARE",      -- Chronostasis          -- 8s slow for -60% ms, 3 charges, with 10s recharge time
	[801280] = "STUN",       -- Buy Time              -- 10s aoe stun on 2 min cd -- OBSOLETE!
	[804461] = "POLYMORPH",  -- Babify
	[805162] = "INCAP",      -- Breath of Time        -- 3s incapacitate on 30s cd -- OBSOLETE?
	[805847] = "ROOT",       -- Clasp of Infinity
	-- Cultist
	[560109] = "FEAR",       -- Corrupt Mind
	[560110] = "FEAR",       -- Madness
	[560963] = "BANISH",     -- Shackle The Unrepentant
	[805114] = "HORROR",     -- Mass Nightmare        -- 5s aoe horror, on 3 min cd
	-- Felsworn
	[560284] = "HORROR",     -- Infernal -- 3-4s aoe horror, on 45s cd
	[704371] = 'SNARE',      -- Cripple -- slow ms and casting speed by 60%, decaying over 12 sec, no cd
	[805235] = "FEAR",       -- Whispers of the Pit -- 8s aoe fear, on 1 min cd
	-- Guardian
	[501546] = "STUN",       -- Battle Rush           -- charge with 1s stun on 30s cd
	[501547] = "STUN",       -- Battle Rush
	[501548] = "STUN",       -- Battle Rush
	[802197] = "STUN",       -- Battle Rush
	[704418] = "SILENCE",    -- Hammer of the Law     -- 3s cone silence on 40s cd
	[801828] = "STUN",       -- Vanguard X-173: Onslaught -- 3s cone stun on 20s cd
	[802304] = "ROOT",       -- Net Throw             -- 4s root on 20s cd
	-- Knight of Xoroth
	[503361] = "SILENCE",    -- Chainwhip             -- 2s silence on 20s cd
	[503362] = "SILENCE",    -- Chainwhip
	[503363] = "SILENCE",    -- Chainwhip
	[503364] = "SILENCE",    -- Chainwhip
	[503365] = "SILENCE",    -- Chainwhip
	[503366] = "SILENCE",    -- Chainwhip
	[503367] = "SILENCE",    -- Chainwhip
	[800081] = "SILENCE",    -- Chainwhip
	[503142] = "ROOT",       -- Hellhaul              -- 5s dragging root, on 3 min cd
	[503143] = "ROOT",       -- Hellhaul
	[503144] = "ROOT",       -- Hellhaul
	[503145] = "ROOT",       -- Hellhaul
	[503146] = "ROOT",       -- Hellhaul
	[503147] = "ROOT",       -- Hellhaul
	[503148] = "ROOT",       -- Hellhaul
	[804168] = "CHARM",      -- Hellbound Leash       -- 5min (8s vs players) charm bidding leash, on 1 min cd, with 3s cast time
	[803185] = "STUN",       -- Chains of Malice      -- 5s dragging stun on 1 min cd
	-- Necromancer
	[500326] = "ROOT",       -- Bonefreeze            -- (Freeze in place)
	[500341] = "BANISH",     -- Entomb                -- 4s banish on 1 min cd
	[800706] = "FEAR",       -- Ghoulify
	[803741] = "FEAR",       -- Mass Grave
	[280475] = "FEAR",       -- Mass Grave
	[501983] = "ROOT",       -- Black Ice             -- was it removed from Necromancer? -- OBSOLETE?
	[501984] = "ROOT",       -- Black Ice
	[501985] = "ROOT",       -- Black Ice
	[501986] = "ROOT",       -- Black Ice
	[501987] = "ROOT",       -- Black Ice
	[501988] = "ROOT",       -- Black Ice
	[501989] = "ROOT",       -- Black Ice
	[501990] = "ROOT",       -- Black Ice
	[501991] = "ROOT",       -- Black Ice
	[801746] = "ROOT",       -- Black Ice             -- effect
	-- Primalist
	[800145] = "INCAP",      -- Grip                  -- 8s incapacitate, 1.5s cast
	-- Pyromancer
	[535505] = "ROOT",       -- Cindergrip            -- 1.5s cast root
	[535506] = "ROOT",       -- Cindergrip
	[535507] = "ROOT",       -- Cindergrip
	[535508] = "ROOT",       -- Cindergrip
	[805476] = "ROOT",       -- Cindergrip            -- effect?
	[806148] = "SLEEP",      -- Gaze of Ysera
	[502088] = "HORROR",     -- Petrifying Visage     -- 3s stunning horror on 2 min cd
	[502089] = "HORROR",     -- Petrifying Visage
	[502090] = "HORROR",     -- Petrifying Visage
	[801908] = "HORROR",     -- Petrifying Visage
	-- Ranger
	[804936] = "STUN",       -- Ambuscade             -- death grip + 3s stun, on 1 min cd
	-- Reaper
	[500355] = "FEAR",       -- Mark of Terror        -- 5s fear on 30s cd
	[504014] = "HORROR",     -- Soulslam              -- 3s horror on 45s cd
	[803989] = "INCAP",      -- Soul Shock            -- 8s sap (paren says INCAP) -- DOUBLE-CHECK
	[802086] = "SILENCE",    -- Mind Screech          -- 3.5s silence, applied by Shrieking Scythe (talent)
	[806146] = "SILENCE",    -- Ghastly Screech       -- 4s aoe silence on 1 min cd
	-- Runemaster
	[503423] = "INCAP",      -- Inscription: Permafrost -- 8s incap on 1 min cd; cd reduced during stealth/runeshroud
	[503424] = "INCAP",      -- Inscription: Permafrost
	[503425] = "INCAP",      -- Inscription: Permafrost
	[503426] = "INCAP",      -- Inscription: Permafrost
	[503427] = "INCAP",      -- Inscription: Permafrost
	[503428] = "INCAP",      -- Inscription: Permafrost
	[503429] = "INCAP",      -- Inscription: Permafrost
	[503430] = "INCAP",      -- Inscription: Permafrost
	[503431] = "INCAP",      -- Inscription: Permafrost
	[804060] = "INCAP",      -- Permafrost Rune       -- 10s incap on 1 min cd; cd -80% during stealth/runeshroud
	[502634] = "STUN",       -- Everfrost Scroll      -- stun for 3.5s on 1 min cd
	[502635] = "STUN",       -- Everfrost Scroll
	[502636] = "STUN",       -- Everfrost Scroll
	[502637] = "STUN",       -- Everfrost Scroll
	[502638] = "STUN",       -- Everfrost Scroll
	[502639] = "STUN",       -- Everfrost Scroll
	[502640] = "STUN",       -- Everfrost Scroll
	[502641] = "STUN",       -- Everfrost Scroll
	[502642] = "STUN",       -- Everfrost Scroll
	[289080] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- base ability
	[289081] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank2
	[289082] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank3
	[289083] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank4
	[289084] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank5
	[289085] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank6
	[289086] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank7

	[801104] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank1
	[572733] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank2
	[572734] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank3
	[572735] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank4
	[572736] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank5
	[572737] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank6
	[572738] = "ROOT",       -- Hoarfrost (ROOT or FREEZE?) -- 3s aoe root (frozen in place), on 10s cd -- rank7
	[807822] = "ROOT",       -- Cryobrand (ROOT or FREEZE?) -- 8s root (frozen in place), usable from stealth/runeshroud
	-- Starcaller
	[804738] = "CHARM",      -- Siren's Song
	[503012] = "SILENCE",    -- Slipstream            -- self silence 5s + aoe heal, on 15s cd
	[503013] = "SILENCE",    -- Slipstream
	[503014] = "SILENCE",    -- Slipstream
	[503015] = "SILENCE",    -- Slipstream
	[503016] = "SILENCE",    -- Slipstream
	[503017] = "SILENCE",    -- Slipstream
	[503018] = "SILENCE",    -- Slipstream
	[800366] = "SILENCE",    -- Slipstream
	[801135] = "STUN",       -- Starshatter           -- inline 5s stun, on 1 min cd
	[805546] = "SLEEP",      -- Moonlit Slumber       -- 6s sleep, on 1 min cd
	[806156] = "SILENCE",    -- Astral Armor          -- 3s silence
	-- Stormbringer
	[707044] = "FEAR",       -- Storm Alert           -- 8s fear with 2.0s cast
	[707905] = "FEAR",       -- Storm Alert           -- 8s fear with 1.8s cast
	[707906] = "FEAR",       -- Storm Alert           -- 8s fear with 1.7s cast
	[801871] = "ROOT",       -- Thunder Prison Unused
	[804419] = "INCAP",	     -- Stasis                -- 8s incapacitate, instant, on 1 min cd
	-- Sun Cleric
	[805583] = "STUN",       -- Glare                 -- 5s aoe stun on 2 min cd
	[560764] = "INCAP",      -- Celestial Impact      -- OBSOLETE?
	-- Templar
	[560116] = "SILENCE",    -- Interdict             -- 6s silence on 2 min cd (undead/demons also cannot be healed)
	[806121] = "INCAP",      -- Judgement Day
	-- Tinker
	[804861] = "SILENCE",    -- Anti-Magic Grenades   -- aoe silence 4s, on 2 min cd, dispels 3 beneficial magic
	[806173] = "STUN",       -- Drill Smash           -- 4s stun, on 30s cd
	-- Venomancer
	[504335] = "STUN",	     -- Web Wrap (STUN)       -- 5s stun, on 1 min cd
	[800876] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank1
	[502881] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank2
	[502882] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank3
	[502883] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank4
	[502884] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank5
	[502885] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank6
	[502886] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank7
	[502887] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank8
	[502888] = "SNARE",	     -- Web Wrap (SLOW)       -- 4s channeled ms slow on 20s cd (plus 30% dmg increase), rank9
	[504362] = "CHARM",      -- Fungify               -- MC/Seduction mix, 1.5s cast -- OBSOLETE?
	[502890] = "ROOT",       -- Spindlebind           -- 4s root on 16s cd
	[502891] = "ROOT",       -- Spindlebind
	[502892] = "ROOT",       -- Spindlebind
	[502893] = "ROOT",       -- Spindlebind
	[502894] = "ROOT",       -- Spindlebind
	[502895] = "ROOT",       -- Spindlebind
	[800887] = "ROOT",       -- Spindlebind
	[800877] = "STUN",       -- Shadra's Binding
	[704235] = "DISARM",     -- Pinch                 -- disarm 5s on 1 min cd
	[804967] = "ROOT",       -- Venocannon            -- self root on 1 min cd -- OBSOLETE?
	-- Witch Doctor
	[802065] = "SNARE",      -- Lethargy Jinx         -- 50% ms slow for 10s, (75% with Shadow Enchantments)
	[803678] = "SILENCE",    -- Malignant Jinx        -- 5s curse that causes target's next spell cast to silence them for 5s
	[803732] = "SILENCE",    -- Malignant Jinx
	[280056] = "SILENCE",    -- Malignant Jinx
	[500952] = "POLYMORPH",  -- Amphibimorph
	[801665] = "ROOT",       -- Big Bad Voodoo
	[801678] = "STUN",       -- Stasis Ward           -- 4s aoe stun with 2s delay, on 1 min cd
	-- Witch Hunter
	[500089] = "SILENCE",    -- Subjugate             -- 4s silence + 40% ms slow, on 1 min cd
	[802139] = "STUN",       -- Darkslayer's Lantern  -- 5s aoe stun, on 2 min cd
	[805756] = "SNARE",      -- Smoke Grenade         -- 8s snare + untargetable in/out of cloud, on 2 min cd
	-- Other
	[800013] = "STUN",       -- Facehug               -- 3s stun on 1 min cd -- MINDBENDER?
	[800354] = "POLYMORPH",  -- Enslave               -- 8s poly with 1.7s cast -- MINDBENDER?
	[800950] = "SILENCE",    -- Deathmatch            -- banish self and target for 6s on 1 min cd
	[803531] = "SILENCE",    -- Deathmatch            -- banish self and target for 6s on 1 min cd
};


-- CoA Interrupt Lockouts: [spellID] = duration (seconds)
----------------------------------------------------------------
local coaInterrupts = {
	-- Bloodmage
	[806099] = 4,    -- Aneurysm             -- cs for 4s, on 24s cd
	-- Cultist
	[804056] = 2,    -- Crushing Dissonance  -- aoe cs for 2s, on 30s cd
	-- Felsworn
	[800203] = 3,    -- Fel Break            -- cs for 3s, on 18s cd, 0.5s cast
	-- Guardian
	[500268] = 0,    -- Bastion Slam         -- cs for 0s?, on 25s cd -- DOUBLE-CHECK (duration)
	[704159] = 3,    -- Shield of Denial     -- cs for 3s, on 30s cd
	-- Necromancer
	[801739] = 0,    -- Heartchill           -- cs for 0s (3s ms/haste debuff), on 30s cd -- DOUBLE-CHECK (duration)
	-- Pyromancer
	[800808] = 5,    -- Spellburn            -- cs for 5s, on 25s cd
	-- Reaper
	[806125] = 3,    -- Siphon Essence       -- cs for 3s, on 20s cd
	[807737] = 3,    -- Siphon Essence
	[807738] = 3,    -- Siphon Essence
	[807739] = 3,    -- Siphon Essence
	[807740] = 3,    -- Siphon Essence
	-- Runemaster
	[800995] = 2.5,  -- Ley Lock             -- cs for 2.5s, on 6s cd, 0.5s cast
	-- Starcaller
	[805432] = 3,    -- Halt                 -- cs for 3s, on 15s cd -- OBSOLETE?
	-- Stormbringer
	[500932] = 5,    -- Gust of Wind         -- cs for 5s, on 35s cd
	-- Venomancer
	[805096] = 3,    -- Nullifying Toxin     -- cs for 3s, on 16s cd
	-- Witch Doctor
	-- [806294] = 4, -- Spirit Shock -- DEPRECATED: now a 4s SILENCE vs players, 4s cs interrupt vs NPCs
	-- Witch Hunter
	[804432] = 3,    -- Guard Strike         -- cs for 3s, on 18s cd
};


-- Merge CoA data into the base tables
----------------------------------------------------------------
for id, mechanic in pairs(coaAuras) do
	AURA_CC[id] = mechanic;
end

for id, duration in pairs(coaInterrupts) do
	INTERRUPT_LOCKOUT[id] = duration;
end
