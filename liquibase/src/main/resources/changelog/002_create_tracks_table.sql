-- Table
CREATE TABLE IF NOT EXISTS public.tracks (
                                             track_id BIGSERIAL,
                                             recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    title TEXT NOT NULL,
    artist TEXT NOT NULL,
    album TEXT,
    duration_ms INTEGER NOT NULL,
    CONSTRAINT tracks_pk PRIMARY KEY (track_id, recorded_at)
    ) PARTITION BY RANGE (recorded_at);
