-- Debezium signal tables (parent + per-partition)
CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2025_12 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);


CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_01 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_02 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_03 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_04 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_05 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_06 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_07 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_08 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_09 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_10 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_11 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);

CREATE TABLE IF NOT EXISTS public.debezium_signal_tracks_2026_12 (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB
);
